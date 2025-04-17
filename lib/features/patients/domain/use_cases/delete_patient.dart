import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class DeletePatient {
  final PatientRepository repository;

  DeletePatient(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePatient(id);
  }
}