// {
// "id": 2,
// "patient": 5,
// "prescribed_medicine": 2,
// "quantity": 6,
// "given_at": "2025-04-18T17:30:43.717667Z",
// "medicine_name": "med 1",
// "total_price": "0.42"
// }

import 'dart:convert';

GivenMedicine givenMedicineModelFromJson(str) => GivenMedicine.fromJson(str);

String givenMedicineModelToJson(GivenMedicine data) => json.encode(data.toJson());

class GivenMedicine {
  final int id;
  final int patient;
  final int prescribedMedicine;
  final int quantity;
  final String givenAt;
  final String medicineName;
  final String totalPrice;

  GivenMedicine({
    required this.id,
    required this.patient,
    required this.prescribedMedicine,
    required this.quantity,
    required this.givenAt,
    required this.medicineName,
    required this.totalPrice,
  });

  factory GivenMedicine.fromJson(Map<String, dynamic> json) {
    return GivenMedicine(
      id: json['id'] ?? 0,
      patient: json['patient'] ?? 0,
      prescribedMedicine: json['prescribed_medicine'] ?? 0,
      quantity: json['quantity'] ?? 0,
      givenAt: json['given_at'] ?? '',
      medicineName: json['medicine_name'] ?? '',
      totalPrice: json['total_price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient,
      'quantity': quantity,
      'given_at': givenAt,
      'medicine_name': medicineName,
      'prescribed_medicine': prescribedMedicine,
      'total_price': totalPrice,
    };
  }

  GivenMedicine copyWith({int? id, int? patient, int? quantity, String? givenAt, String? medicineName, int? prescribedMedicine, String? totalPrice}) {
    return GivenMedicine(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      quantity: quantity ?? this.quantity,
      givenAt: givenAt ?? this.givenAt,
      medicineName: medicineName ?? this.medicineName,
      prescribedMedicine: prescribedMedicine ?? this.prescribedMedicine,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
