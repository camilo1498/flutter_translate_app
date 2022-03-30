class Definition {
  String? definition;
  String? example;

  Definition({
    this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
    definition: json["definition"],
    example: json["example"],
  );

  Map<String, dynamic> toJson() => {
    "definition": definition,
    "example": example,
  };
}