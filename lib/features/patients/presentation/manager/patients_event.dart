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

  const PatientCreate(this.patient);

  @override
  List<Object?> get props => [patient];
}

class PatientUpdate extends PatientEvent {
  final Patient patient;

  const PatientUpdate({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class PatientDelete extends PatientEvent {
  final int patientId;

  const PatientDelete(this.patientId);

  @override
  List<Object?> get props => [patientId];
}
