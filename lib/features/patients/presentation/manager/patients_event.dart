part of 'patients_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object?> get props => [];
}

class PatientFetchAll extends PatientEvent {
  /// fetch remotely only from patients main screen
  final bool? shouldRefresh;

  const PatientFetchAll({this.shouldRefresh = true});
}

class PatientFetchOne extends PatientEvent {
  final int patientId;

  const PatientFetchOne(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class PatientSearch extends PatientEvent {
  final String query;

  const PatientSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class PatientCreate extends PatientEvent {
  final Patient patient;
  final BuildContext context;

  const PatientCreate(this.patient, this.context);

  @override
  List<Object?> get props => [patient];
}

class PatientUpdate extends PatientEvent {
  final Patient patient;
  final BuildContext context;

  const PatientUpdate({required this.patient, required this.context});

  @override
  List<Object?> get props => [patient];
}

class PatientDelete extends PatientEvent {
  final int patientId;

  const PatientDelete(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class GivenMedsFetchAll extends PatientEvent {
  final int id;

  const GivenMedsFetchAll({required this.id});

  @override
  List<Object?> get props => [id];
}

class MedsFetchAll extends PatientEvent {
  const MedsFetchAll();

  @override
  List<Object?> get props => [];
}

class AddGivenMed extends PatientEvent {
  final int patientId;
  final int medId;
  final int quantity;
  final String dosage;
  final BuildContext context;

  const AddGivenMed({required this.patientId, required this.medId, required this.quantity, required this.dosage, required this.context});

  @override
  List<Object?> get props => [id];
}

class DeleteGivenMedEvent extends PatientEvent {
  final int id;

  const DeleteGivenMedEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
