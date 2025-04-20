import 'package:dartz/dartz.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../core/network/exceptions.dart';
import '../../data/models/given_medicine.dart';
import '../../data/models/invoice.dart';
import '../../data/models/patients.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<Patient>>> getAllPatients();

  Future<Either<Failure, Patient>> getPatient(int id);

  Future<Either<Failure, List<Patient>>> searchPatients(String query);

  Future<Either<Failure, Patient>> createPatient(Patient patient);

  Future<Either<Failure, Patient>> updatePatient(Patient patient);

  Future<Either<Failure, Unit>> deletePatient(int id);

  Future<Either<Failure, List<GivenMedicine>>> givenMedicine(int id);

  Future<Either<Failure, List<Medicine>>> getAllMeds();

  Future<Either<Failure, GivenMedicine>> addGivenMed(int patientId, int medID, int quantity, String dosage);

  Future<Either<Failure, Unit>> deleteGivenMed(int id);


  Future<Either<Failure, Medicine>> addMed({
    required String name,
    required String dose,
    required String scientificName,
    required String company,
    required String price,
  });


  Future<Either<Failure, Invoice>> getInvoice();
}
