import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';
import '../../data/models/patients.dart';

@lazySingleton
class SearchPatients {
  final PatientRepository repository;

  SearchPatients(this.repository);

  Future<Either<Failure, List<Patient>>> call(String query) {
    return repository.searchPatients(query);
  }
}