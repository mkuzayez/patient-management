import 'dart:convert';

Invoice invoiceModelFromJson(String str) => Invoice.fromJson(json.decode(str));

String invoiceModelToJson(Invoice data) => json.encode(data.toJson());

class Invoice {
  final Metadata metadata;
  final List<ReportMedicine> medicines;

  Invoice({required this.metadata, required this.medicines});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      metadata: Metadata.fromJson(json['metadata']),
      medicines: List<ReportMedicine>.from(
        json['medicines'].map((x) => ReportMedicine.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata.toJson(),
      'medicines': List<dynamic>.from(medicines.map((x) => x.toJson())),
    };
  }
}

class Metadata {
  final String? fromDate;
  final String? toDate;
  final dynamic totalPrice;
  final FiltersApplied filtersApplied;

  Metadata({
     this.fromDate,
     this.toDate,
    this.totalPrice,
    required this.filtersApplied,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      fromDate: json['from_date'],
      toDate: json['to_date'],
      totalPrice: json['total_price'],
      filtersApplied: FiltersApplied.fromJson(json['filters_applied']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_date': fromDate,
      'to_date': toDate,
      'total_price': totalPrice,
      'filters_applied': filtersApplied.toJson(),
    };
  }
}

class FiltersApplied {
  final String? area;
  final String? period;

  FiltersApplied({
    this.area,
    this.period,
  });

  factory FiltersApplied.fromJson(Map<String, dynamic> json) {
    return FiltersApplied(
      area: json['area'],
      period: json['period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'period': period,
    };
  }
}

class ReportMedicine {
  final String medicineName;
  final int totalQuantity;
  final double pricePerUnit;
  final double totalPrice;

  ReportMedicine({
    required this.medicineName,
    required this.totalQuantity,
    required this.pricePerUnit,
    required this.totalPrice,
  });

  factory ReportMedicine.fromJson(Map<String, dynamic> json) {
    return ReportMedicine(
      medicineName: json['medicine_name'],
      totalQuantity: json['total_quantity'],
      pricePerUnit: json['price_per_unit'],
      totalPrice: json['total_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_name': medicineName,
      'total_quantity': totalQuantity,
      'price_per_unit': pricePerUnit,
      'total_price': totalPrice,
    };
  }
}
