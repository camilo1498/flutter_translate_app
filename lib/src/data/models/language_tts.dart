import 'dart:convert';

LanguageTts languageTtsFromJson(String str) => LanguageTts.fromJson(json.decode(str));

String languageTtsToJson(LanguageTts data) => json.encode(data.toJson());

class LanguageTts {
  String? language;
  String? code;

  LanguageTts({
    this.language,
    this.code,
  });

  factory LanguageTts.fromJson(Map<String, dynamic> json) => LanguageTts(
    language: json["language"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "language": language,
    "code": code,
  };
}
