import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/invoice.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class GetInvoiceUseCase {
  final PatientRepository repository;

  GetInvoiceUseCase(this.repository);

  Future<Either<Failure, Invoice>> call() {
    return repository.getInvoice();
  }
}
