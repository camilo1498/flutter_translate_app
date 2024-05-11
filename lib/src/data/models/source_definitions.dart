import 'package:flutter_translate_app/src/data/models/definition.dart';

class SourceDefinition {
  String? type;
  List<Definition>? definitions;

  SourceDefinition({
    this.type,
    this.definitions,
  });

  factory SourceDefinition.fromJson(Map<String, dynamic> json) =>
      SourceDefinition(
        type: json["type"],
        definitions: List<Definition>.from(
            json["definitions"].map((x) => Definition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "definitions": List<dynamic>.from(definitions!.map((x) => x.toJson())),
      };
}
