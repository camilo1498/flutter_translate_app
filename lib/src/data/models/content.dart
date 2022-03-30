class Content {

  String? id;
  List<String>? synonyms;

  Content({
    this.id,
    this.synonyms,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    synonyms: List<String>.from(json["synonyms"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "synonyms": List<dynamic>.from(synonyms!.map((x) => x)),
  };
}