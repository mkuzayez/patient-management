import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';
import '../../data/models/patients.dart';

@lazySingleton
class GetPatient {
  final PatientRepository repository;

  GetPatient(this.repository);

  Future<Either<Failure, Patient>> call(int id) {
    return repository.getPatient(id);
  }
}