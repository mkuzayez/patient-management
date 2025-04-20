import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class DeleteGivenMedUsecase {
  final PatientRepository repository;

  DeleteGivenMedUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) {
    return repository.deleteGivenMed(id);
  }
}
