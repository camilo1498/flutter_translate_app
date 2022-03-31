class TranslationData {

  String? word;
  List<String>? translations;
  String? frequency;
  String? article;

  TranslationData({
    this.word,
    this.translations,
    this.frequency,
    this.article,
  });

  factory TranslationData.fromJson(Map<String, dynamic> json) => TranslationData(
    word: json["word"],
    translations: List<String>.from(json["translations"].map((x) => x)),
    frequency: json["frequency"].toString(),
    article: json["article"],
  );

  Map<String, dynamic> toJson() => {
    "word": word,
    "translations": List<dynamic>.from(translations!.map((x) => x)),
    "frequency": frequency,
    "article": article,
  };
}
