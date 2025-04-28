import 'dart:convert';
import 'package:equatable/equatable.dart';

Patient patientFromJson(str) => Patient.fromJson(json.decode(str));

String patientModelToJson(Patient data) => json.encode(data.toJson());

class Patient extends Equatable {
  final int? id;
  final String fullName;
  final int age;
  final String gender;
  final String? area;
  final String? mobileNumber;
  final String? status;
  final int recordsCount;
  final String? lastVisit;
  final bool isWaiting;

  const Patient({
    this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    this.area,
    this.mobileNumber,
    this.status,
    this.recordsCount = 0,
    this.lastVisit,
    required this.isWaiting,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      area: json['area'],
      mobileNumber: json['mobile_number'],
      status: json['status'] ?? '',
      recordsCount: json['records_count'] ?? 0,
      lastVisit: json['last_visit'] ?? '',
      isWaiting: json['is_waiting'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'area': area,
      'mobile_number': mobileNumber,
      'status': status,
      'records_count': recordsCount,
      'last_visit': lastVisit,
      'is_waiting': isWaiting,
    };
  }

  Patient copyWith({
    int? id,
    String? fullName,
    int? age,
    String? gender,
    String? area,
    String? mobileNumber,
    String? status,
    int? recordsCount,
    String? lastVisit,
    bool? isWaiting,
  }) {
    return Patient(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      area: area ?? this.area,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status ?? this.status,
      recordsCount: recordsCount ?? this.recordsCount,
      lastVisit: lastVisit ?? this.lastVisit,
      isWaiting: isWaiting ?? this.isWaiting,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    age,
    gender,
    area,
    mobileNumber,
    status,
    recordsCount,
    lastVisit,
    isWaiting,
  ];
}
