import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/exceptions.dart';
import '../../../data/models/invoice.dart';
import '../../../domain/use_cases/get_invoice.dart';

part 'invoice_state.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  final GetInvoiceUseCase getInvoiceUseCase;

  ReportCubit({required this.getInvoiceUseCase}) : super(const ReportState());

  Future<void> fetchInvoice() async {
    try {
      emit(const ReportState(status: Status.loading));

      final result = await getInvoiceUseCase();

      result.fold(
            (failure) {
          emit(ReportState(status: Status.error, failure: failure));
        },
            (invoice) {
          emit(ReportState(status: Status.success, invoice: invoice));
        },
      );
    } catch (e) {
      emit(ReportState(status: Status.error, failure: Failure(message: e.toString())));
    }
  }
}