import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/common/consts/keys.dart';
import 'package:patient_managment/features/patients/data/models/given_medicine.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';
import 'package:patient_managment/features/patients/domain/use_cases/add_given_med.dart';
import 'package:patient_managment/features/patients/domain/use_cases/delete_given_med.dart';
import 'package:patient_managment/features/patients/domain/use_cases/get_all_meds.dart';

import '../../../../common/utils/base_state.dart';
import '../../../../common/utils/cache_manager.dart';
import '../../../../core/network/exceptions.dart';
import '../../data/models/patients.dart';
import '../../domain/use_cases/create_patient.dart';
import '../../domain/use_cases/delete_patient.dart';
import '../../domain/use_cases/get_all_patients.dart';
import '../../domain/use_cases/get_given_meds.dart';
import '../../domain/use_cases/get_patient.dart';
import '../../domain/use_cases/update_patient.dart';

part 'patients_event.dart';

part 'patients_state.dart';

@injectable
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final GetAllPatients _getAllPatients;
  final GetPatient _getPatient;

  // final SearchPatients _searchPatients;
  final CreatePatient _createPatient;
  final UpdatePatient _updatePatient;
  final DeletePatient _deletePatient;

  final GetGivenMedsUseCase _getGivenMeds;
  final CacheManager _cacheManager;

  final AddGivenMedUseCase addGivenMedUseCase;

  final DeleteGivenMedUsecase deleteGivenMed;

  final GetAllMedsUseCase getAllMeds;

  PatientBloc(
    this._getAllPatients,
    this._getPatient,
    this._getGivenMeds,
    // this._searchPatients,
    this._createPatient,
    this._updatePatient,
    this._deletePatient,
    this._cacheManager,
    this.addGivenMedUseCase,
    this.deleteGivenMed,
    this.getAllMeds,
  ) : super(const PatientState(uiStatus: Status.initial)) {
    on<PatientFetchAll>(_onFetchAll);
    on<PatientFetchOne>(_onFetchOne);
    on<PatientSearch>(_onSearch);
    on<PatientCreate>(_onCreate);
    on<PatientUpdate>(_onUpdate);
    on<PatientDelete>(_onDelete);
    on<GivenMedsFetchAll>(_onGetGivenMedsEvent);
    on<MedsFetchAll>(_onGetAllMeds);
    on<AddGivenMed>(_addGivenMed);
    on<DeleteGivenMedEvent>(_deleteGivenMed);
  }

  Future<void> _onFetchAll(PatientFetchAll event, Emitter<PatientState> emit) async {
    // Only case where we use uiStatus - affects the entire screen
    emit(state.copyWith(uiStatus: Status.loading, actionStatus: Status.initial, errorMessage: null));

    if (event.shouldRefresh == true) {
      try {
        final cachedPatients = _cacheManager.getData<List<Patient>>(key: CacheKeys.patients);

        if (cachedPatients?.isNotEmpty == true) {
          emit(state.copyWith(uiStatus: Status.success, patients: List.of(cachedPatients!), errorMessage: null));
          return;
        }

        final result = await _getAllPatients();

        await result.fold<Future<void>>(
          (failure) async {
            emit(state.copyWith(uiStatus: Status.failure, errorMessage: failure.message));
          },
          (patients) async {
            _cacheManager.cacheData(key: CacheKeys.patients, data: patients);
            emit(state.copyWith(uiStatus: Status.success, patients: patients, errorMessage: null));
          },
        );
      } on Object catch (e) {
        emit(state.copyWith(uiStatus: Status.failure, errorMessage: 'Failed to fetch patients: ${e.toString()}'));
      }
    } else {
      final cachedPatients = _cacheManager.getData<List<Patient>>(key: CacheKeys.patients);

      emit(state.copyWith(uiStatus: Status.success, patients: List.of(cachedPatients!), errorMessage: null));
    }
  }

  Future<void> _onFetchOne(PatientFetchOne event, Emitter<PatientState> emit) async {
    // Uses actionStatus only - shows dialog over existing UI
    emit(state.copyWith(uiStatus: Status.loading, errorMessage: null, givenMeds: null, selectedPatient: null, clearSelectedPatient: true));

    final Patient? patient = _cacheManager.getData(key: "${CacheKeys.patientID}_${event.patientId}");

    if (_cacheManager.getData(key: "${CacheKeys.patientID}_${event.patientId}") != null) {
      emit(state.copyWith(uiStatus: Status.success, selectedPatient: patient, errorMessage: null));
      return;
    }

    final results = await Future.wait([_getPatient(event.patientId), _getGivenMeds(event.patientId)]);

    final patientResult = results[0] as Either<Failure, Patient>;
    final medsResult = results[1] as Either<Failure, List<GivenMedicine>>;

    patientResult.fold((failure) => emit(state.copyWith(uiStatus: Status.failure, errorMessage: failure.message)), (patient) {
      // _cacheManager.cacheData(key: "${CacheKeys.patientID}_${patient.id}", data: patient);
      emit(state.copyWith(uiStatus: Status.success, selectedPatient: patient, errorMessage: null));
    });

    medsResult.fold((_) {}, (meds) {
      emit(state.copyWith(givenMeds: meds));
      print("meds $meds");
    });
  }

  Future<void> _onCreate(PatientCreate event, Emitter<PatientState> emit) async {
    // Uses actionStatus only - shows dialog over existing UI
    emit(state.copyWith(actionStatus: Status.loading, errorMessage: null));

    final result = await _createPatient(event.patient);

    result.fold((failure) => emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message)), (newPatient) {
      final updatedPatients = List<Patient>.from(state.patients)..add(newPatient);
      _cacheManager.cacheData(key: CacheKeys.patients, data: List.of(updatedPatients));

      emit(state.copyWith(actionStatus: Status.success, patients: updatedPatients, selectedPatient: newPatient, errorMessage: null));
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(content: Text('تم إضافة بيانات المريض بنجاح')));
      event.context.pop();
      return;
    });
  }

  Future<void> _onSearch(PatientSearch event, Emitter<PatientState> emit) async {
    if (event.query.isEmpty || event.query == '') {
      final cachedPatients = _cacheManager.getData(key: CacheKeys.patients);
      if (cachedPatients == null) {
        log("BUG");
        final result = await _getAllPatients();

        result.fold((failure) => emit(state.copyWith(uiStatus: Status.failure, errorMessage: failure.message)), (patients) async {
          _cacheManager.cacheData(key: CacheKeys.patients, data: patients);
          emit(state.copyWith(uiStatus: Status.success, patients: patients, errorMessage: null));
        });
      } else {
        emit(state.copyWith(patients: cachedPatients));
      }
    } else {
      emit(state.copyWith(patients: List.of(state.patients.where((element) => element.fullName.toLowerCase().contains(event.query)).toList())));
    }
  }

  Future<void> _onUpdate(PatientUpdate event, Emitter<PatientState> emit) async {
    // Uses actionStatus only - shows dialog over existing UI
    emit(state.copyWith(actionStatus: Status.loading, errorMessage: null));

    try {
      final result = await _updatePatient(event.patient);
      result.fold(
        (failure) {
          print("LEFT, LEFT");
          debugPrint("failure ${failure.message}");
          emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message));
        },
        (savedPatient) {
          print("${savedPatient.id} savedPatient.id");
          // print("${state.selectedPatient?.id} selectedPatient.id");

          state.patients.remove(state.patients.firstWhere((element) => element.id == event.patient.id));

          final updated = state.patients;
          updated.add(savedPatient);
          _cacheManager.cacheData(key: "${CacheKeys.patientID}_${savedPatient.id}", data: savedPatient);
          _cacheManager.cacheData(key: CacheKeys.patients, data: List.of(updated));

          emit(
            state.copyWith(
              actionStatus: Status.success,
              patients: List.of(updated),
              selectedPatient: savedPatient,
              errorMessage: null,
              clearFailure: true,
              shouldPop: true,
            ),
          );
          ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(content: Text('تم تحديث بيانات المريض بنجاح')));
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("e.toString() ${e.toString()}");
      }
      emit(state.copyWith(actionStatus: Status.failure, errorMessage: 'خطأ بالاتصال، يرجى المحاولة مجددًا'));

      emit(state.copyWith(actionStatus: Status.initial, uiStatus: Status.initial, errorMessage: null));
    }
  }

Future<void> _onDelete(PatientDelete event, Emitter<PatientState> emit) async {
  emit(state.copyWith(actionStatus: Status.loading, errorMessage: null));

  final result = await _deletePatient(event.patientId);

  result.fold((failure) {
      emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message));
    }, 
    (_) {
      final updatedList = state.patients.where((p) => p.id != event.patientId).toList();
      _cacheManager.cacheData(key: CacheKeys.patients, data: List.of(updatedList));
      emit(
        state.copyWith(
          actionStatus: Status.success,
          patients: List.of(updatedList),
          selectedPatient: null,
          errorMessage: null,
          shouldPop: true
        ),
      );
    },
  );
}


  Future<void> _onGetGivenMedsEvent(GivenMedsFetchAll event, Emitter<PatientState> emit) async {
    //   emit(state.copyWith(uiStatus: Status.loading, givenMeds: null, errorMessage: null));
    //
    //   final result = await _getGivenMeds(event.id);
    //
    //   result.fold(
    //     (failure) {
    //       print(failure.message);
    //       emit(state.copyWith(uiStatus: Status.failure, errorMessage: failure.message));
    //     },
    //     (givenMeds) {
    //       emit(state.copyWith(uiStatus: Status.success, givenMeds: givenMeds, errorMessage: null));
    //     },
    //   );
  }

  Future<void> _onGetAllMeds(MedsFetchAll event, Emitter<PatientState> emit) async {
    emit(state.copyWith(dialogStatus: Status.loading, errorMessage: null, clearFailure: true, allMeds: state.allMeds));

    final result = await getAllMeds();

    result.fold((l) {}, (r) {
      emit(state.copyWith(allMeds: r, dialogStatus: Status.success));
    });
  }

  Future<void> _addGivenMed(AddGivenMed event, Emitter<PatientState> emit) async {
    emit(state.copyWith(dialogStatus: Status.loading, errorMessage: null, clearFailure: true));

    final result = await addGivenMedUseCase(event.patientId, event.medId, event.quantity, event.dosage);

    result.fold(
      (f) {
        emit(state.copyWith(actionStatus: Status.failure, failure: f));
      },
      (g) {
        final updated = List<GivenMedicine>.from(state.givenMeds);
        updated.add(g);

        emit(state.copyWith(actionStatus: Status.success, givenMeds: updated));
        event.context.pop();
      },
    );
  }

  Future<void> _deleteGivenMed(DeleteGivenMedEvent event, Emitter<PatientState> emit) async {
    emit(state.copyWith(actionStatus: Status.loading, errorMessage: null, clearFailure: true));

    final result = await deleteGivenMed(event.id);

    result.fold(
          (l) {
            if (kDebugMode) {
              print("l.message ${l.message}");
            }
        emit(state.copyWith(actionStatus: Status.failure, errorMessage: null, clearFailure: true));
      },
          (r) {
        try {
          final updated = List<GivenMedicine>.from(state.givenMeds);
          updated.removeWhere((element) => element.id == event.id);

          emit(state.copyWith(actionStatus: Status.success, givenMeds: updated));
        } catch (e) {
          emit(state.copyWith(actionStatus: Status.failure, errorMessage: null, clearFailure: true));

          if (kDebugMode) {
            print("e.toString() ${e.toString()}");
          }
        }
      },
    );
  }



}
