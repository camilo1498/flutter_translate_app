// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'package:flutter_translate_app/src/data/models/translate.dart';

class ApiResponse {
  bool? success;
  Translate? data;
  String? message;

  ApiResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        data: Translate.fromJson(json["data"] ?? {}),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
        "message": message,
      };
}
