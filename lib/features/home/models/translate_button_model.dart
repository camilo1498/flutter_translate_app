import 'dart:ui';

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
    required this.translationPosition,
  });

  ///
  final double value;

  ///
  final String language;

  ///
  final VoidCallback? onTap;

  ///
  final ButtonOriginalPosition originalPosition;

  ///
  final ButtonOriginalPosition translationPosition;

  ///
  TranslateButtonModel copyWith({
    double? value,
    String? language,
    VoidCallback? onTap,
    ButtonOriginalPosition? originalPosition,
    ButtonOriginalPosition? translationPosition,
  }) =>
      TranslateButtonModel(
        onTap: onTap ?? this.onTap,
        value: value ?? this.value,
        language: language ?? this.language,
        originalPosition: originalPosition ?? this.originalPosition,
        translationPosition: translationPosition ?? this.translationPosition,
      );

  ///
  factory TranslateButtonModel.fromJson(Map<String, dynamic> json) =>
      TranslateButtonModel(
        onTap: json["onTap"],
        value: json["value"],
        language: json["language"],
        originalPosition: json["originalPosition"],
        translationPosition: json["translationPosition"],
      );

  ///
  Map<String, dynamic> toMap() => {
        "onTap": onTap,
        "value": value,
        "language": language,
        "originalPosition": originalPosition,
        "translationPosition": translationPosition,
      };
}
