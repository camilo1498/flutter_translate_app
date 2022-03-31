import 'package:flutter_translator_app/src/data/models/translation_data.dart';

class Translation {
  String? type;
  List<TranslationData>? translations;

  Translation({
    this.type,
    this.translations,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        type: json["type"],
        translations: List<TranslationData>.from(
            json["translations"].map((x) => TranslationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "translations":
            List<dynamic>.from(translations!.map((x) => x.toJson())),
      };
}
