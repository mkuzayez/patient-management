import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../core/network/exceptions.dart';
import '../../data/models/given_medicine.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class AddMedUseCase {
  final PatientRepository repository;

  AddMedUseCase(this.repository);

  Future<Either<Failure, Medicine>> call({
    required String name,
    required String dose,
    required String scientificName,
    required String company,
    required String price,
  }) {
    return repository.addMed(name: name, dose: dose, scientificName: scientificName, company: company, price: price);
  }
}
