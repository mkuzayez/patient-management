import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/domain/use_cases/get_all_meds.dart';

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

  MedsBloc({
    required this.getAllMedsUseCase,
    required this.addMedUseCase,
  }) : super(const MedsState()) {
    on<LoadAllMedsEvent>(_onLoadAllMeds);
    on<AddMedEvent>(_onAddMed);
  }

  Future<void> _onLoadAllMeds(LoadAllMedsEvent event, Emitter<MedsState> emit) async {
    emit(state.copyWith(uiStatus: Status.loading));

    final result = await getAllMedsUseCase();
    result.fold(
          (failure) => emit(state.copyWith(
        uiStatus: Status.failure,
        failure: failure,
        errorMessage: "خطأ بتحميل الأدوية"
      )),
          (meds) => emit(state.copyWith(
        uiStatus: Status.success,
        allMeds: meds,
      )),
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
          (failure) => emit(state.copyWith(
        dialogStatus: Status.failure,
        failure: failure,
        errorMessage: "خطأ بإضافة الدواء، يرجى المحاولة مجددًا",
      )),
          (newMed) {
        final updatedMeds = [...state.allMeds, newMed];
        emit(state.copyWith(
          allMeds: updatedMeds,
          dialogStatus: Status.success,
        ));
      },
    );
  }
}
