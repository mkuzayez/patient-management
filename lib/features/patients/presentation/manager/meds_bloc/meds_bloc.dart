import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/domain/use_cases/get_all_meds.dart';
import 'package:patient_managment/features/patients/domain/use_cases/update_med.dart';

import '../../../../../common/utils/base_state.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../data/models/medicine.dart';
import '../../../domain/use_cases/add_med.dart';

part 'meds_event.dart';
part 'meds_state.dart';

@injectable
class MedsBloc extends Bloc<MedsEvent, MedsState> {
  final GetAllMedsUseCase getAllMedsUseCase;
  final AddMedUseCase addMedUseCase;
  final UpdateMed updateMed;

  MedsBloc({required this.getAllMedsUseCase, required this.addMedUseCase, required this.updateMed}) : super(const MedsState()) {
    on<LoadAllMedsEvent>(_onLoadAllMeds);
    on<AddMedEvent>(_onAddMed);
    on<UpdateMedEvent>(_onUpdateMed);
  }

  Future<void> _onLoadAllMeds(LoadAllMedsEvent event, Emitter<MedsState> emit) async {
    emit(state.copyWith(uiStatus: Status.loading));

    final result = await getAllMedsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(uiStatus: Status.failure, failure: failure, errorMessage: "خطأ بتحميل الأدوية")),
      (meds) => emit(state.copyWith(uiStatus: Status.success, allMeds: meds)),
    );
  }

  Future<void> _onAddMed(AddMedEvent event, Emitter<MedsState> emit) async {
    emit(state.copyWith(dialogStatus: Status.loading));

    final result = await addMedUseCase(
      name: event.name,
      dose: event.dose,
      scientificName: event.scientificName,
      company: event.company,
      price: event.price,
    );

    result.fold(
      (failure) => emit(state.copyWith(dialogStatus: Status.failure, failure: failure, errorMessage: "خطأ بإضافة الدواء، يرجى المحاولة مجددًا")),
      (newMed) {
        final updatedMeds = List.of(state.allMeds)..add(newMed);
        emit(state.copyWith(allMeds: updatedMeds, dialogStatus: Status.success));
      },
    );
  }


  Future<void> _onUpdateMed(UpdateMedEvent event, Emitter<MedsState> emit) async {
    emit(state.copyWith(dialogStatus: Status.loading));

    final result = await updateMed(
      id: event.id.toString(), // Remove .toString() unless your use case requires it
      name: event.name,
      dose: event.dose,
      scientificName: event.scientificName,
      company: event.company,
      price: event.price,
    );

    result.fold(
          (failure) => emit(state.copyWith(
          dialogStatus: Status.failure,
          failure: failure,
          errorMessage: "خطأ بتحديث الدواء، يرجى المحاولة مجددًا" // Changed to "update" error
      )),
          (updatedMed) {
        // Find and replace the existing medicine
        final updatedMeds = List<Medicine>.from(state.allMeds);
        final index = updatedMeds.indexWhere((m) => m.id == event.id);

        if (index != -1) {
          updatedMeds[index] = updatedMed;
          emit(state.copyWith(
              allMeds: updatedMeds,
              dialogStatus: Status.success
          ));
        } else {
          emit(state.copyWith(
              dialogStatus: Status.failure,
              errorMessage: "الدواء غير موجود للتحديث"
          ));
        }
      },
    );
  }
}
