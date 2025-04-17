import 'package:dartz/dartz.dart';

import '../../../../core/network/exceptions.dart';
import '../../data/models/patients.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<Patient>>> getAllPatients();

  Future<Either<Failure, Patient>> getPatient(int id);

  Future<Either<Failure, List<Patient>>> searchPatients(String query);

  Future<Either<Failure, Patient>> createPatient(Patient patient);

  Future<Either<Failure, Patient>> updatePatient(Patient patient);

  Future<Either<Failure, Unit>> deletePatient(int id);
}
