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
  int? id;
  int? timestamp;
  String? originalText;
  String? translationText;
  String? originalTextCode;
  String? translationTextCode;
  String? isFavorite;
  History({
    this.id,
    this.timestamp,
    this.originalText,
    this.translationText,
    this.originalTextCode,
    this.translationTextCode,
    this.isFavorite,
  });

  History copy({
    int? id,
    int? timestamp,
    String? originalText,
    String? translationText,
    String? originalTextCode,
    String? translationTextCode,
    String? isFavorite,
}) => History(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    originalText: originalText ?? this.originalText,
    translationText: translationText ?? this.translationText,
    originalTextCode: originalTextCode ?? this.originalTextCode,
    translationTextCode: translationTextCode ?? this.translationTextCode,
    isFavorite:  isFavorite ?? this.isFavorite
  );


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
