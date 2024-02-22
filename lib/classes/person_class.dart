class Person {
  int? id;
  int? familyId;
  final String name;
  bool hasAccepted;

  Person({
    this.id,
    this.familyId,
    required this.name,
    required this.hasAccepted,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'familyId': int familyId,
        'name': String name,
        'hasAccepted': bool hasAccepted,
      } =>
        Person(
          id: id,
          familyId: familyId,
          name: name,
          hasAccepted: hasAccepted,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
