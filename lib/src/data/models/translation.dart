class TranslationClass {

  String? type;
  List<List<dynamic>>? translations;

  TranslationClass({
    this.type,
    this.translations,
  });

  factory TranslationClass.fromJson(Map<String, dynamic> json) => TranslationClass(
    type: json["type"],
    translations: List<List<dynamic>>.from(json["translations"].map((x) => List<dynamic>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "translations": List<dynamic>.from(translations!.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}