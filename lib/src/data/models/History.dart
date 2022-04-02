// ignore_for_file: file_names
import 'package:flutter_translator_app/src/data/models/language.dart';

class HistoryFields {
  static const String tableHistory = 'history';
  static const String id = '_id';
  static const String timestamp = 'timestamp';
  static const String originalText = 'originalText';
  static const String translationText = 'translationText';
  static const String originalTextCode = 'originalTextCode';
  static const String translationTextCode = 'translationTextCode';
  static const String isFavorite = 'isFavorite';
}

class History {
  String? id;
  int? timestamp;
  String? originalText;
  String? translationText;
  String? originalTextCode;
  String? translationTextCode;
  bool? isFavorite;
  History({
    this.id,
    this.timestamp,
    this.originalText,
    this.translationText,
    this.originalTextCode,
    this.translationTextCode,
    this.isFavorite,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        timestamp: json["timestamp"],
        originalText: json["originalText"],
        translationText: json["translationText"],
        originalTextCode: json["originalTextCode"],
        translationTextCode: json["translationTextCode"],
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        HistoryFields.id: id,
        HistoryFields.timestamp: timestamp,
        HistoryFields.originalText: originalText,
        HistoryFields.translationText: translationText,
        HistoryFields.originalTextCode: originalTextCode,
        HistoryFields.translationTextCode: translationTextCode,
        HistoryFields.isFavorite: isFavorite,
      };
}
