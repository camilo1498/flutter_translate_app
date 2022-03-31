import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
  String? name;
  String? code;

  Language({
    this.name,
    this.code,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
      };
}
