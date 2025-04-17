import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';
import '../data_sources/patients_data_source.dart';
import '../models/patients.dart';

@LazySingleton(as: PatientRepository)
class PatientRepositoryImpl implements PatientRepository {
  final PatientDataSource patientDataSource;

  PatientRepositoryImpl(this.patientDataSource);

  @override
  Future<Either<Failure, List<Patient>>> getAllPatients() {
    return patientDataSource.getAllPatients();
  }

  @override
  Future<Either<Failure, Patient>> getPatient(int id) {
    return patientDataSource.getPatient(id);
  }

  @override
  Future<Either<Failure, List<Patient>>> searchPatients(String query) {
    return patientDataSource.searchPatients(query);
  }

  @override
  Future<Either<Failure, Patient>> createPatient(Patient patient) {
    return patientDataSource.createPatient(patient);
  }

  @override
  Future<Either<Failure, Patient>> updatePatient(Patient patient) {
    return patientDataSource.updatePatient(patient);
  }

  @override
  Future<Either<Failure, Unit>> deletePatient(int id) {
    return patientDataSource.deletePatient(id);
  }
}
