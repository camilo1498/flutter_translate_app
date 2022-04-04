class FavouriteFields {
  static const String tableFavourite = 'favourite';
  static const String id = '_id';
  static const String timestamp = 'timestamp';
  static const String originalText = 'originalText';
  static const String translationText = 'translationText';
  static const String originalTextCode = 'originalTextCode';
  static const String translationTextCode = 'translationTextCode';
  static const String isFavorite = 'isFavorite';
  static const String historyId = '_historyId';
}

class Favourite {
  int? id;
  int? timestamp;
  int? historyId;
  String? originalText;
  String? translationText;
  String? originalTextCode;
  String? translationTextCode;
  String? isFavorite;
  Favourite({
    this.id,
    this.timestamp,
    this.historyId,
    this.originalText,
    this.translationText,
    this.originalTextCode,
    this.translationTextCode,
    this.isFavorite,
  });

  Favourite copy({
    int? id,
    int? timestamp,
    int? historyId,
    String? originalText,
    String? translationText,
    String? originalTextCode,
    String? translationTextCode,
    String? isFavorite,
  }) => Favourite(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      historyId: historyId ?? this.historyId,
      originalText: originalText ?? this.originalText,
      translationText: translationText ?? this.translationText,
      originalTextCode: originalTextCode ?? this.originalTextCode,
      translationTextCode: translationTextCode ?? this.translationTextCode,
      isFavorite:  isFavorite ?? this.isFavorite
  );


  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
    id: json["_id"],
    timestamp: json["timestamp"],
    historyId: json['_historyId'],
    originalText: json["originalText"],
    translationText: json["translationText"],
    originalTextCode: json["originalTextCode"],
    translationTextCode: json["translationTextCode"],
    isFavorite: json["isFavorite"],
  );

  Map<String, dynamic> toJson() => {
    FavouriteFields.id: id,
    FavouriteFields.timestamp: timestamp,
    FavouriteFields.historyId: historyId,
    FavouriteFields.originalText: originalText,
    FavouriteFields.translationText: translationText,
    FavouriteFields.originalTextCode: originalTextCode,
    FavouriteFields.translationTextCode: translationTextCode,
    FavouriteFields.isFavorite: isFavorite,
  };
}
