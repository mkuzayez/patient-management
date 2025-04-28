import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/invoice.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';
import '../data_sources/patients_data_source.dart';
import '../models/given_medicine.dart';
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

  @override
  Future<Either<Failure, List<GivenMedicine>>> givenMedicine(int id) {
    return patientDataSource.getMedicine(id);
  }

  @override
  Future<Either<Failure, GivenMedicine>> addGivenMed(int patientId, int medID, int quantity, String dosage) {
    return patientDataSource.addGivenMed(patientId, medID, quantity, dosage);
  }

  @override
  Future<Either<Failure, Unit>> deleteGivenMed(int id) {
    return patientDataSource.deleteMed(id);
  }

  @override
  Future<Either<Failure, List<Medicine>>> getAllMeds() {
    return patientDataSource.getAllMeds();
  }

  @override
  Future<Either<Failure, Medicine>> addMed({
    required String name,
    required String dose,
    required String scientificName,
    required String company,
    required String price,
  }) {
    return patientDataSource.addMed(name: name, dose: dose, scientificName: scientificName, company: company, price: price);
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice() {
    return patientDataSource.getReport();
  }


  @override
  Future<Either<Failure, Medicine>> updateMed({
    required String id,
    required String name,
    required String dose,
    required String scientificName,
    required String company,
    required String price,
  }) {
    return patientDataSource.addMed(name: name, dose: dose, scientificName: scientificName, company: company, price: price);
  }
}
