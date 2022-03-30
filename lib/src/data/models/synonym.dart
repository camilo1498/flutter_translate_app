import 'package:flutter_translator_app/src/data/models/content.dart';

class Synonym {

  String? type;
  List<Content>? content;

  Synonym({
    this.type,
    this.content,
  });

  factory Synonym.fromJson(Map<String, dynamic> json) => Synonym(
    type: json["type"],
    content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "content": List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}