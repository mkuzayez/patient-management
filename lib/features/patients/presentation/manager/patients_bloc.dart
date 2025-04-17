import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/common/consts/keys.dart';

import '../../../../common/utils/base_state.dart';
import '../../../../common/utils/cache_manager.dart';
import '../../../../core/network/exceptions.dart';
import '../../data/models/patients.dart';
import '../../domain/use_cases/create_patient.dart';
import '../../domain/use_cases/delete_patient.dart';
import '../../domain/use_cases/get_all_patients.dart';
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
  final CacheManager _cacheManager;

  PatientBloc(
    this._getAllPatients,
    this._getPatient,
    // this._searchPatients,
    this._createPatient,
    this._updatePatient,
    this._deletePatient,
    this._cacheManager,
  ) : super(const PatientState(uiStatus: Status.initial)) {
    on<PatientFetchAll>(_onFetchAll);
    on<PatientFetchOne>(_onFetchOne);
    on<PatientSearch>(_onSearch);
    on<PatientCreate>(_onCreate);
    on<PatientUpdate>(_onUpdate);
    on<PatientDelete>(_onDelete);
  }

  Future<void> _onFetchAll(PatientFetchAll event, Emitter<PatientState> emit) async {
    // Only case where we use uiStatus - affects the entire screen
    emit(state.copyWith(uiStatus: Status.loading, actionStatus: Status.initial, errorMessage: null));

    if (event.shouldRefresh == true) {
      try {
        final cachedPatients = _cacheManager.getData<List<Patient>>(key: CacheKeys.patients);

        if (cachedPatients?.isNotEmpty == true) {
          emit(state.copyWith(uiStatus: Status.success, patients: cachedPatients, errorMessage: null));
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
    }
  }

  Future<void> _onFetchOne(PatientFetchOne event, Emitter<PatientState> emit) async {
    // Uses actionStatus only - shows dialog over existing UI
    emit(state.copyWith(actionStatus: Status.loading, errorMessage: null));

    final result = await _getPatient(event.patientId);

    result.fold(
      (failure) => emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message)),
      (patient) => emit(state.copyWith(actionStatus: Status.success, selectedPatient: patient, errorMessage: null)),
    );
  }

  Future<void> _onCreate(PatientCreate event, Emitter<PatientState> emit) async {
    // Uses actionStatus only - shows dialog over existing UI
    emit(state.copyWith(actionStatus: Status.loading, errorMessage: null));

    final result = await _createPatient(event.patient);

    result.fold((failure) => emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message)), (newPatient) {
      final updatedPatients = List<Patient>.from(state.patients)..add(newPatient);
      emit(state.copyWith(actionStatus: Status.success, patients: updatedPatients, selectedPatient: newPatient, errorMessage: null));
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

      result.fold((failure) => emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message)), (savedPatient) {
        final updatedPatients = state.patients.map((p) => p.id == savedPatient.id ? savedPatient : p).toList();

        emit(state.copyWith(actionStatus: Status.success, patients: updatedPatients, selectedPatient: savedPatient, errorMessage: null));
      });
    } catch (e) {
      emit(state.copyWith(actionStatus: Status.failure, errorMessage: 'Failed to update patient: ${e.toString()}'));
    }
  }

  Future<void> _onDelete(PatientDelete event, Emitter<PatientState> emit) async {
    // Uses actionStatus only - shows confirmation dialog
    emit(state.copyWith(actionStatus: Status.loading, errorMessage: null));

    final result = await _deletePatient(event.patientId);

    result.fold((failure) => emit(state.copyWith(actionStatus: Status.failure, errorMessage: failure.message)), (_) {
      final updatedList = state.patients.where((p) => p.id != event.patientId).toList();
      emit(
        state.copyWith(
          actionStatus: Status.success,
          patients: updatedList,
          selectedPatient: state.selectedPatient?.id == event.patientId ? null : state.selectedPatient,
          errorMessage: null,
        ),
      );
    });
  }
  // bool _validatePatient(Patient patient) {
  //   return patient.fullName.isNotEmpty &&
  //       patient.age >= 0 &&
  //       patient.gender!.isNotEmpty &&
  //       (patient.mobileNumber?.isEmpty ?? true || _isValidMobileNumber(patient.mobileNumber!));
  // }

  // bool _isValidMobileNumber(String mobileNumber) {
  //   final regex = RegExp(r'^\+?[1-9]\d{1,14}$');
  //   return regex.hasMatch(mobileNumber);
  // }
}
