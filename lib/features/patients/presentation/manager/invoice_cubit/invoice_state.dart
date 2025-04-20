part of 'invoice_cubit.dart';

// Define the states
class ReportState extends Equatable {
  final Status status;
  final Invoice? invoice;
  final Failure? failure;

  const ReportState({this.status = Status.initial, this.invoice, this.failure});

  @override
  List<Object?> get props => [status, invoice, failure];
}

enum Status { initial, loading, success, error }
