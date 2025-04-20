import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class GetAllMedsUseCase {
  final PatientRepository repository;

  GetAllMedsUseCase(this.repository);

  Future<Either<Failure, List<Medicine>>> call() {
    return repository.getAllMeds();
  }
}
