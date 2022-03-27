// ignore_for_file: file_names

import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  String? id;
  int? timestamp;
  String? originalText;
  String? translatedText;
  String? originalCode;
  String? translatedTextCode;
  bool? isFavorite;
  History({
    this.id,
    this.timestamp,
    this.originalText,
    this.translatedText,
    this.originalCode,
    this.translatedTextCode,
    this.isFavorite,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"],
    timestamp: json["timestamp"],
    originalText: json["originalText"],
    translatedText: json["translatedText"],
    originalCode: json["originalCode"],
    translatedTextCode: json["translatedTextCode"],
    isFavorite: json["isFavorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "timestamp": timestamp,
    "originalText": originalText,
    "translatedText": translatedText,
    "originalCode": originalCode,
    "translatedTextCode": translatedTextCode,
    "isFavorite": isFavorite,
  };
}
