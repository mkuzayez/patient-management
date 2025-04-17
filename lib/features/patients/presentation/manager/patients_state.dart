part of 'patients_bloc.dart';
class PatientState extends Equatable {
  final List<Patient> patients;
  final List<Patient?>? searchedPatients;
  final Patient? selectedPatient;
  final String? searchQuery;
  final Failure? failure;

  // Main status for builders (UI updates)
  final Status uiStatus;

  // Separate status for listeners (actions like navigation)
  final Status actionStatus;

  // Error message (can be used for both UI and actions)
  final String? errorMessage;

  const PatientState({
    this.uiStatus = Status.initial,
    this.actionStatus = Status.initial,
    this.patients = const [],
    this.searchedPatients = const [],

    this.selectedPatient,
    this.searchQuery,
    this.failure,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    uiStatus,
    actionStatus,
    patients,
    selectedPatient,
    searchedPatients,
    searchQuery,
    failure,
    errorMessage,
  ];

  PatientState copyWith({
    Status? uiStatus,
    Status? actionStatus,
    List<Patient>? patients,
    List<Patient>? searchedPatients,

    Patient? selectedPatient,
    String? searchQuery,
    Failure? failure,
    bool clearSelectedPatient = false,
    bool clearSearchQuery = false,
    bool clearFailure = false,
    String? errorMessage,
  }) {
    return PatientState(
      uiStatus: uiStatus ?? this.uiStatus,
      actionStatus: actionStatus ?? this.actionStatus,

      patients: patients ?? this.patients,
      searchedPatients: searchedPatients ?? null,
      selectedPatient: clearSelectedPatient ? null : selectedPatient ?? this.selectedPatient,
      searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
      failure: clearFailure ? null : failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
