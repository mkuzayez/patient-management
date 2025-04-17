import 'dart:convert';

Patient patientFromJson(str) => Patient.fromJson(str);

String patientModelToJson(Patient data) => json.encode(data.toJson());

class Patient {
  int id;
  String fullName;
  int age;
  String gender;
  String? area;
  String? mobileNumber;
  String? pastIllnesses;
  String? status;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  int recordsCount;
  String? lastVisit;
  bool isWaiting;

  Patient({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    this.area,
    this.mobileNumber,
    this.pastIllnesses,
    this.status,
    // this.createdAt,
    // this.updatedAt,
    this.recordsCount = 0,
    this.lastVisit,
    required this.isWaiting,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['full_name'],
      age: json['age'],
      gender: json['gender'],
      area: json['area'],
      mobileNumber: json['mobile_number'],
      pastIllnesses: json['past_illnesses'] ?? '',
      status: json['status'],
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
      recordsCount: json['records_count'] ?? 0,
      lastVisit: json['last_visit'],
      isWaiting: json['is_waiting'],
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
      'past_illnesses': pastIllnesses,
      'status': status,
      // 'created_at': createdAt,
      // 'updated_at': updatedAt,
      'records_count': recordsCount,
      'last_visit': lastVisit,
      "is_waiting": isWaiting,
    };
  }

  Patient copyWith({
    int? id,
    String? fullName,
    int? age,
    String? gender,
    String? area,
    String? mobileNumber,
    String? pastIllnesses,
    String? status,
    // DateTime? createdAt,
    // DateTime? updatedAt,
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
      pastIllnesses: pastIllnesses ?? this.pastIllnesses,
      status: status ?? this.status,
      // createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
      recordsCount: recordsCount ?? this.recordsCount,
      lastVisit: lastVisit ?? this.lastVisit,
      isWaiting: isWaiting ?? this.isWaiting,
    );
  }
}