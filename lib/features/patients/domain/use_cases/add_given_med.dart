import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/exceptions.dart';
import '../../data/models/given_medicine.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class AddGivenMedUseCase {
  final PatientRepository repository;

  AddGivenMedUseCase(this.repository);

  Future<Either<Failure, GivenMedicine>> call(int patientId, int medID, int quantity, String dosage) {
    return repository.addGivenMed(patientId, medID, quantity, dosage);
  }
}
