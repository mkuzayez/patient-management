// { {
//   "count": 3,
//   "next": null,
//   "previous": null,
//   "results": [
//     {
//       "id": 1,
//       "name": "med 1",
//       "dose": "23",
//       "scientific_name": "",
//       "company": "",
//       "price": "0.07"
//     },
//     {
//       "id": 2,
//       "name": "med 2",
//       "dose": "20",
//       "scientific_name": "",
//       "company": "",
//       "price": "21.00"
//     },
//     {
//       "id": 3,
//       "name": "med 3",
//       "dose": "20",
//       "scientific_name": "",
//       "company": "",
//       "price": "321.00"
//     }
//   ]
// }

import 'dart:convert';

Medicine givenMedicineModelFromJson(str) => Medicine.fromJson(str);

String givenMedicineModelToJson(Medicine data) => json.encode(data.toJson());

class Medicine {
  final int id;
  final String name;
  final String dose;
  final String scientificName;

  final String company;
  final String price;

  Medicine({required this.id, required this.name, required this.dose, required this.scientificName, required this.company, required this.price});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      dose: json['dose'],
      scientificName: json['scientific_name'],
      company: json['company'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'dose': dose, 'scientific_name': scientificName, 'company': company, 'price': price};
  }

  Medicine copyWith({int? id, int? patient, int? quantity, String? givenAt, String? medicineName, int? prescribedMedicine, String? totalPrice}) {
    return Medicine(id: id ?? this.id, name: name, dose: dose, scientificName: scientificName, company: company, price: price);
  }
}
