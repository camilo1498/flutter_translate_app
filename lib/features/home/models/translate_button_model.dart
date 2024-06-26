import 'dart:ui';

import 'package:g_translate_v2/core/models/language_model.dart';

///
enum ButtonTranslationSr { tl, sl }

///
enum ButtonOriginalPosition { right, left }

///
class TranslateButtonModel {
  ///
  TranslateButtonModel({
    this.onTap,
    required this.value,
    required this.language,
    required this.originalPosition,
    required this.source,
  });

  ///
  final double value;

  ///
  final VoidCallback? onTap;

  ///
  final LanguageModel language;

  ///
  final ButtonTranslationSr source;

  ///
  final ButtonOriginalPosition originalPosition;

  ///
  TranslateButtonModel copyWith({
    double? value,
    VoidCallback? onTap,
    LanguageModel? language,
    ButtonTranslationSr? source,
    ButtonOriginalPosition? originalPosition,
  }) =>
      TranslateButtonModel(
        onTap: onTap ?? this.onTap,
        value: value ?? this.value,
        source: source ?? this.source,
        language: language ?? this.language,
        originalPosition: originalPosition ?? this.originalPosition,
      );

  ///
  factory TranslateButtonModel.fromJson(Map<String, dynamic> json) =>
      TranslateButtonModel(
        onTap: json["onTap"],
        value: json["value"],
        language: json["language"],
        source: json["translationPosition"],
        originalPosition: json["originalPosition"],
      );

  ///
  Map<String, dynamic> toMap() => {
        "onTap": onTap,
        "value": value,
        "language": language.toMap(),
        "translationPosition": source,
        "originalPosition": originalPosition,
      };
}
