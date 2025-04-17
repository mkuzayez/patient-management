import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';
import '../../data/models/patients.dart';

@lazySingleton
class UpdatePatient {
  final PatientRepository repository;

  UpdatePatient(this.repository);

  Future<Either<Failure, Patient>> call(Patient patient) {
    return repository.updatePatient(patient);
  }
}