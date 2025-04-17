import 'dart:convert';

Success successFromJson(str) => Success.fromJson(str);

String successToJson(Success data) => json.encode(data.toJson());

class Success {
  final String? message;

  Success({
    this.message,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
