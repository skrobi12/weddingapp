class Person {
  int? id;
  int? familyId;
  final String name;
  bool hasAccepted;
  bool isNew;

  Person({
    this.id,
    this.familyId,
    required this.name,
    required this.hasAccepted,
    required this.isNew,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'familyId': int familyId,
        'name': String name,
        'hasAccepted': bool? hasAccepted,
      } =>
        Person(
            id: id, familyId: familyId, name: name, hasAccepted: (hasAccepted == null) ? false : hasAccepted, isNew: false),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
