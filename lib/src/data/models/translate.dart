import 'dart:convert';

import 'package:flutter_translator_app/src/data/models/source.dart';
import 'package:flutter_translator_app/src/data/models/translation.dart';

Translate translateFromJson(String str) => Translate.fromJson(json.decode(str));

String translateToJson(Translate data) => json.encode(data.toJson());

class Translate {
  String? text;
  String? originalText;
  String? sourceLanguage;
  String? translationLanguage;
  bool? isCorrect;
  Source? source;
  List<TranslationClass>? translations;
  Translate({
    this.text,
    this.originalText,
    this.sourceLanguage,
    this.translationLanguage,
    this.isCorrect,
    this.source,
    this.translations,
  });

  factory Translate.fromJson(Map<String, dynamic> json) => Translate(
    text: json["text"],
    originalText: json["originalText"],
    sourceLanguage: json["sourceLanguage"],
    translationLanguage: json["translationLanguage"],
    isCorrect: json["isCorrect"],
    source: Source.fromJson(json["source"] ?? {}),
    translations: List<TranslationClass>.from(json["translations"].map((x) => TranslationClass.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "originalText": originalText,
    "sourceLanguage": sourceLanguage,
    "translationLanguage": translationLanguage,
    "isCorrect": isCorrect,
    "source": source!.toJson(),
    "translations": List<dynamic>.from(translations!.map((x) => x.toJson())),
  };
}
