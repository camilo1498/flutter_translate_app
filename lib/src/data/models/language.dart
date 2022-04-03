import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
  String? name;
  String? code;
  String? tts;

  Language({
    this.name,
    this.code,
    this.tts
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        name: json["name"],
        code: json["code"],
        tts: json["tts"]
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "tts": tts
      };
}
