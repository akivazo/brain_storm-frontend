import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data_models.dart';

class DataCreator {
  final serverIP = "https://akivazonenfeld.com";
  Future<User> createUser(String name, String password, String email, List<Tag> tags) async {
    // return the id of the user created
    var response = await http.post(
        Uri.https('${serverIP}', "/user_api/user"),
        headers: {
          "Content-Type": "application/json", // Specify that you're sending JSON data
        },
        body: jsonEncode({
          "name": name,
          "password": password,
          "email": email,
          "tags": tags.map((tag) => tag.name).toList()
        }));

    if (response.statusCode == 201){
      return User(name: name, password: password, email: email, tags: tags);
    }
    throw Exception("Creation went wrong: ${response.body}");
  }

  Future<Idea> createIdea(String ownerName, String subject, String details, List<String> tags) async {
    // return the id of the user created
    var response = await http.post(
        Uri.https('${serverIP}', "/idea_api/idea"),
        headers: {
          "Content-Type": "application/json", // Specify that you're sending JSON data
        },
        body: jsonEncode({
          "owner_name": ownerName,
          "subject": subject,
          "details": details,
          "tags": tags
        }));

    if (response.statusCode == 201){
      var id = jsonDecode(response.body)["id"];
      return Idea(id: id, owner_name: ownerName, subject: subject, details: details, tags: tags.map((name) => Tag(name: name)).toList());
    }
    throw Exception("Creation went wrong: ${response.body}");
  }

  Future<void> createTag(String tag) async{
    var response = await http.post(Uri.https('${serverIP}', "/tag_api/tag/${tag}"));
    if (response.statusCode != 201) {
      throw Exception("Error creating tag: ${response.body}");
    }

  }

  Future<bool> isUsernameUsed(String userName) async {
    var response = await http.get(Uri.https('${serverIP}', "/user_api/user_exist/$userName"));
    if (response.statusCode == 200){
      return jsonDecode(response.body) == "Y";
    }
    throw Exception("Error: ${response.body}");
  }


}