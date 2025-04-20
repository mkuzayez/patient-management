part of 'meds_bloc.dart';

class MedsState extends Equatable {
  final List<Medicine> allMeds;
  final Status uiStatus;
  final Status actionStatus;
  final Status dialogStatus;
  final Failure? failure;
  final String? errorMessage;

  const MedsState({
    this.allMeds = const [],
    this.uiStatus = Status.initial,
    this.actionStatus = Status.initial,
    this.dialogStatus = Status.initial,
    this.failure,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    allMeds,
    uiStatus,
    actionStatus,
    dialogStatus,
    failure,
    errorMessage,
  ];

  MedsState copyWith({
    List<Medicine>? allMeds,
    Status? uiStatus,
    Status? actionStatus,
    Status? dialogStatus,
    Failure? failure,
    bool clearFailure = false,
    String? errorMessage,
  }) {
    return MedsState(
      allMeds: allMeds ?? this.allMeds,
      uiStatus: uiStatus ?? this.uiStatus,
      actionStatus: actionStatus ?? Status.initial,
      dialogStatus: dialogStatus ?? this.dialogStatus,
      failure: clearFailure ? null : failure ?? this.failure,
      errorMessage: errorMessage,
    );
  }
}
