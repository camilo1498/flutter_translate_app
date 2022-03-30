import 'package:flutter_translator_app/src/data/models/source_definitions.dart';

class Source {
  List<dynamic>? synonyms;
  List<dynamic>? pronunciation;
  List<SourceDefinition>? definitions;
  List<dynamic>? examples;
  Source({
    this.synonyms,
    this.pronunciation,
    this.definitions,
    this.examples,
  });



  factory Source.fromJson(Map<String, dynamic> json) => Source(
    synonyms: List<dynamic>.from(json["synonyms"].map((x) => x)),
    pronunciation: List<dynamic>.from(json["pronunciation"].map((x) => x)),
    definitions: List<SourceDefinition>.from(json["definitions"].map((x) => SourceDefinition.fromJson(x))),
    examples: List<dynamic>.from(json["examples"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "synonyms": List<dynamic>.from(synonyms!.map((x) => x)),
    "pronunciation": List<dynamic>.from(pronunciation!.map((x) => x)),
    "definitions": List<dynamic>.from(definitions!.map((x) => x.toJson())),
    "examples": List<dynamic>.from(examples!.map((x) => x)),
  };
}
