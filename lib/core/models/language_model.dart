import 'package:flutter/material.dart';

///
@immutable
class LanguageModel {
  ///
  const LanguageModel({
    required this.code,
    required this.name,
    required this.tts,
  });

  ///
  final String code;

  ///
  final String name;

  ///
  final String? tts;

  ///
  LanguageModel copyWith({
    String? code,
    String? name,
    String? tts,
  }) =>
      LanguageModel(
        code: code ?? this.code,
        name: name ?? this.name,
        tts: tts ?? this.tts,
      );

  ///
  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        tts: json["tts"] as String?,
        code: json["code"] as String,
        name: json["name"] as String,
      );

  ///
  Map<String, dynamic> toMap() => {
        "code": code,
        "name": name,
        "tts": tts,
      };
}
