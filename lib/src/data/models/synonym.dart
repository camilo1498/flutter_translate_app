class Synonym {

  String? id;
  List<String>? words;

  Synonym({
    this.id,
    this.words,
  });

  factory Synonym.fromJson(Map<String, dynamic> json) => Synonym(
    id: json["id"],
    words: List<String>.from(json["words"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "words": List<dynamic>.from(words!.map((x) => x)),
  };
}