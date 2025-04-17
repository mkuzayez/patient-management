import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

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
    return handleApiCall(apiCall: () => httpClient.post('patients/', data: patient.toJson()), jsonConvert: (data) => Patient.fromJson(data));
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
}
