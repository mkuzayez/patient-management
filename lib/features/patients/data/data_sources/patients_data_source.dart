import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/given_medicine.dart';
import 'package:patient_managment/features/patients/data/models/invoice.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/patients.dart';

@lazySingleton
class PatientDataSource with ApiHandler {
  final HTTPClient httpClient;

  PatientDataSource({required this.httpClient});

  Future<Either<Failure, List<Patient>>> getAllPatients() {
    return handleApiCall(
      apiCall: () => httpClient.get('patients/'),
      jsonConvert: (data) {
        final results = data['results'] as List<dynamic>;
        return results.map((json) => Patient.fromJson(json)).toList();
      },
    );
  }

  Future<Either<Failure, Patient>> getPatient(int id) {
    return handleApiCall(apiCall: () => httpClient.get('patients/$id/'), jsonConvert: (data) => Patient.fromJson(data));
  }

  Future<Either<Failure, List<Patient>>> searchPatients(String query) {
    return handleApiCall(
      apiCall: () => httpClient.get('patients/?search=$query'),
      jsonConvert: (data) {
        final results = data['results'] as List<dynamic>;
        return results.map((json) => Patient.fromJson(json)).toList();
      },
    );
  }

  Future<Either<Failure, Patient>> createPatient(Patient patient) {
    return handleApiCall(apiCall: () => httpClient.post('patients/', data: patient.toJson()), jsonConvert: (data) => Patient.fromJson(data['data']));
  }

  Future<Either<Failure, Patient>> updatePatient(Patient patient) {
    return handleApiCall(
      apiCall: () => httpClient.put('patients/${patient.id}/', data: patient.toJson()),
      jsonConvert: (data) => Patient.fromJson(data),
    );
  }

  Future<Either<Failure, Unit>> deletePatient(int id) {
    return handleApiCall(apiCall: () => httpClient.delete('patients/$id/'));
  }

  Future<Either<Failure, List<GivenMedicine>>> getMedicine(int id) {
    return handleApiCall(
      apiCall: () => httpClient.get('patients/$id/given_medicines/'),
      jsonConvert: (data) {
        final results = data['given_medicines'] as List<dynamic>;
        return results.map((json) => GivenMedicine.fromJson(json)).toList();
      },
    );
  }

  Future<Either<Failure, GivenMedicine>> addGivenMed(int patientId, int medID, int quantity, String dosage) {
    return handleApiCall(
      apiCall: () => httpClient.post('/given-medicines/', data: {"patient": patientId, "medicine": medID, "quantity": quantity, "dosage": dosage}),
      jsonConvert: (data) {
        return GivenMedicine.fromJson(data['data']);
      },
    );
  }

  Future<Either<Failure, Unit>> deleteMed(int id) {
    return handleApiCall(apiCall: () => httpClient.delete('/given-medicines/$id/'), returnData: false);
  }

  Future<Either<Failure, List<Medicine>>> getAllMeds() {
    return handleApiCall(
      apiCall: () => httpClient.get('/medicines/'),
      jsonConvert: (data) {
        final results = data['results'] as List<dynamic>;
        return results.map((json) => Medicine.fromJson(json)).toList();
      },
    );
  }

  Future<Either<Failure, Medicine>> addMed({
    required String name,
    required String dose,
    required String scientificName,
    required String company,
    required String price,
  }) {
    return handleApiCall(
      apiCall:
          () => httpClient.post(
            '/medicines/',
            data: {"name": name, "dose": dose, "scientific_name": scientificName, "company": company, "price": price},
          ),
      jsonConvert: (data) {
        return Medicine.fromJson(data);
      },
    );
  }


  Future<Either<Failure, Invoice>> getReport() {
    return handleApiCall(
      apiCall:
          () => httpClient.get(
        '/medicine-report/',
      ),
      jsonConvert: (data) {
        return Invoice.fromJson(data);
      },
    );
  }
}
