import 'dart:convert';

import 'package:flutter_translate_app/src/data/models/source.dart';
import 'package:flutter_translate_app/src/data/models/translation.dart';

Translate translateFromJson(String str) => Translate.fromJson(json.decode(str));

String translateToJson(Translate data) => json.encode(data.toJson());

class Translate {
  String? text;
  String? originalText;
  String? correctionSourceText;
  String? sourceLanguage;
  String? translationLanguage;
  bool? isCorrect;
  Source? source;
  List<Translation>? translations;
  Translate({
    this.text,
    this.originalText,
    this.correctionSourceText,
    this.sourceLanguage,
    this.translationLanguage,
    this.isCorrect,
    this.source,
    this.translations,
  });

  factory Translate.fromJson(Map<String, dynamic> json) => Translate(
        text: json["text"],
        originalText: json["originalText"],
        correctionSourceText: json["correctionSourceText"],
        sourceLanguage: json["sourceLanguage"],
        translationLanguage: json["translationLanguage"],
        isCorrect: json["isCorrect"],
        source: Source.fromJson(json["source"] ?? {}),
        translations: json["translations"] != null
            ? List<Translation>.from(
                json["translations"].map((x) => Translation.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "originalText": originalText,
        "correctionSourceText": correctionSourceText,
        "sourceLanguage": sourceLanguage,
        "translationLanguage": translationLanguage,
        "isCorrect": isCorrect,
        "source": source!.toJson(),
        "translations":
            List<dynamic>.from(translations!.map((x) => x.toJson())),
      };
}
