part of 'patients_bloc.dart';

class PatientState extends Equatable {
  final List<Patient> patients;
  final List<Patient?>? searchedPatients;
  final Patient? selectedPatient;
  final String? searchQuery;
  final Failure? failure;

  final List<GivenMedicine?> givenMeds;

  final List<Medicine?> allMeds;

  // Main status for builders (UI updates)
  final Status uiStatus;

  // Separate status for listeners (actions like navigation)
  final Status actionStatus;

  final Status dialogStatus;

  // Error message (can be used for both UI and actions)
  final String? errorMessage;

  const PatientState({
    this.uiStatus = Status.initial,
    this.actionStatus = Status.initial,
    this.patients = const [],
    this.searchedPatients = const [],
    this.givenMeds = const [],
    this.selectedPatient,
    this.searchQuery,
    this.failure,
    this.errorMessage,
    this.allMeds = const [],
    this.dialogStatus = Status.initial,
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
    givenMeds,
    allMeds,
  ];

  PatientState copyWith({
    Status? uiStatus,
    Status? actionStatus,
    Status? dialogStatus,
    List<Patient>? patients,
    List<Patient>? searchedPatients,
    List<GivenMedicine>? givenMeds,
    List<Medicine?> allMeds = const [],
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
      actionStatus: actionStatus ?? Status.initial,
      dialogStatus: dialogStatus ?? Status.initial,
      givenMeds: givenMeds ?? this.givenMeds,
      patients: patients ?? this.patients,
      searchedPatients: searchedPatients ?? null,
      selectedPatient: clearSelectedPatient ? null : selectedPatient ?? this.selectedPatient,
      searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
      failure: clearFailure ? null : failure ?? this.failure,
      errorMessage: errorMessage,
      allMeds: allMeds,
    );
  }
}
