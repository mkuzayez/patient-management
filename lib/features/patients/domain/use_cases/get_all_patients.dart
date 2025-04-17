import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../data/models/patients.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class GetAllPatients {
  final PatientRepository repository;

  GetAllPatients(this.repository);

  Future<Either<Failure, List<Patient>>> call() {
    return repository.getAllPatients();
  }
}
