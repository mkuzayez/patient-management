import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../data/models/patients.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class CreatePatient {
  final PatientRepository repository;

  CreatePatient(this.repository);

  Future<Either<Failure, Patient>> call(Patient patient) {
    return repository.createPatient(patient);
  }
}