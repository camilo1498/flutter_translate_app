class Definition {
  String? id;
  String? definition;
  String? example;

  Definition({
    this.id,
    this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        id: json["id"],
        definition: json["definition"],
        example: json["example"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "definition": definition,
        "example": example,
      };
}
