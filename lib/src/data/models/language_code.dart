import 'dart:convert';

LanguageCode languageCodeFromJson(String str) => LanguageCode.fromJson(json.decode(str));

String languageCodeToJson(LanguageCode data) => json.encode(data.toJson());

class LanguageCode {
  String? language;
  String? code;

  LanguageCode({
    this.language,
    this.code,
  });

  factory LanguageCode.fromJson(Map<String, dynamic> json) => LanguageCode(
    language: json["language"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "language": language,
    "code": code,
  };
}
