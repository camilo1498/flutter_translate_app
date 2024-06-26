import 'package:flutter_translate_app/src/data/models/source_definitions.dart';
import 'package:flutter_translate_app/src/data/models/synonym.dart';

class Source {
  List<List<Synonym>>? synonyms;
  List<String>? pronunciation;
  List<SourceDefinition>? definitions;
  List<String>? examples;

  Source({
    this.synonyms,
    this.pronunciation,
    this.definitions,
    this.examples,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        synonyms: json["synonyms"] != null
            ? List<List<Synonym>>.from(json["synonyms"].map(
                (x) => List<Synonym>.from(x.map((x) => Synonym.fromJson(x)))))
            : null,
        pronunciation: json["pronunciation"] != null
            ? List<String>.from(json["pronunciation"].map((x) => x))
            : null,
        definitions: json["definitions"] != null
            ? List<SourceDefinition>.from(
                json["definitions"].map((x) => SourceDefinition.fromJson(x)))
            : null,
        examples: json["examples"] != null
            ? List<String>.from(json["examples"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "synonyms": List<dynamic>.from(
            synonyms!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "pronunciation": List<dynamic>.from(pronunciation!.map((x) => x)),
        "definitions": List<dynamic>.from(definitions!.map((x) => x.toJson())),
        "examples": List<dynamic>.from(examples!.map((x) => x)),
      };
}
