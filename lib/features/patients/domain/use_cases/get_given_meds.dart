import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/given_medicine.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class GetGivenMedsUseCase {
  final PatientRepository repository;

  GetGivenMedsUseCase(this.repository);

  Future<Either<Failure, List<GivenMedicine>>> call(int id) {
    return repository.givenMedicine(id);
  }
}
