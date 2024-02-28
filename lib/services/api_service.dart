import 'dart:convert';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/classes/person_class.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Person>> fetchPeople() async {
    final responsePeople = await http.get(Uri.parse('https://sarafara-wedding-app-backend-22dbb06e697f.herokuapp.com/api/people'));

    if (responsePeople.statusCode == 200) {
      // Decode the response body using the determined encoding
      final decodedBody = utf8.decode(responsePeople.bodyBytes, allowMalformed: true);

      // then parse the JSON.
      List<dynamic> jsonResponse = jsonDecode(decodedBody);
      List<Person> people = jsonResponse.map((jsonPerson) => Person.fromJson(jsonPerson)).toList();
      return people;
    } else {
      // If the server did not return a 200 OK responsePeople, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Family> fetchFamily(selectedFamilyId) async {
    final responseFamily = await http.get(Uri.parse('https://sarafara-wedding-app-backend-22dbb06e697f.herokuapp.com/api/families/$selectedFamilyId'));

    if (responseFamily.statusCode == 200) {
      // If the server did return a 200 OK responsePeople,
      final decodedBody = utf8.decode(responseFamily.bodyBytes, allowMalformed: true);
      // then parse the JSON.
      return Family.fromJson(jsonDecode(decodedBody) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK responsePeople,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void sendFamily(Family selectedFamily, void closingModal) async {
    final responsePeople = await http.put(Uri.parse('https://sarafara-wedding-app-backend-22dbb06e697f.herokuapp.com/api/families/${selectedFamily.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Specify JSON content type
        },
        body: jsonEncode(<String, dynamic>{
          'id': selectedFamily.id,
          'members': selectedFamily.members!
              .map((member) => {'id': member.id, 'name': member.name, 'hasAccepted': member.hasAccepted, 'familyId': member.familyId})
              .toList(),
          'comment': selectedFamily.comment
        }));

    if (responsePeople.statusCode == 204) {
      // If the server did return a 200 OK responsePeople, call the closingModal
      closingModal;
    } else {
      // If the server did not return a 200 OK responsePeople, then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
