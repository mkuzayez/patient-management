import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../core/network/exceptions.dart';
import '../../domain/repositories/patients_repository.dart';

@lazySingleton
class UpdateMed {
  final PatientRepository repository;

  UpdateMed(this.repository);

  Future<Either<Failure, Medicine>> call({
    required String id,
    required String name,
    required String dose,
    required String scientificName,
    required String company,
    required String price,
  }) {
    return repository.updateMed(id: id, name: name, dose: dose, scientificName: scientificName, company: company, price: price);
  }
}
