import 'package:wedding/classes/person_class.dart';

class Family {
  int? id;
  List<Person>? members;
  String? comment;

  Family({this.id, this.members, this.comment});

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'] as int?,
      members: (json['members'] as List<dynamic>).map((jsonPerson) => Person.fromJson(jsonPerson as Map<String, dynamic>)).toList(),
      comment: json['comment'] as String?,
    );
  }
}
