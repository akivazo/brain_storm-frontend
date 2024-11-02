import 'data_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For working with JSON

class ServerCommunicator {
  final serverIP = "akivazonenfeld.com";
  Idea _createIdea(Map<String, dynamic> json) {
    return Idea(
      id: json['id'],
      owner_name: json['owner_name'],
      subject: json['subject'],
      details: json['details'],
      tags: (json['tags'] as List<dynamic>).cast<String>(),
    );
  }

  Feedback _createFeedback(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      ownerName: json['owner_name'],
      content: json['content'],
    );
  }

  User _createUser(Map<String, dynamic> json){
    return User(
      name: json['name'],
      password: json["password"],
      email: json['email'],
    );
  }

  Uri _getUri(String queryPath){
    return Uri.https(serverIP, queryPath);
  }

  Future<List<Idea>> fetchIdeas({List<String> tags = const []}) async {
    // return only the ideas which has at least one tag from 'tags'
    final response = await http.get(_getUri('/idea_api/ideas'));

    if (response.statusCode == 200) {
      final List<dynamic> ideasJson = jsonDecode(response.body)["ideas"];
      return ideasJson.map((ideaJson) => _createIdea(ideaJson)).toList();
    } else  {
      throw Exception("Failed to load ideas: ${response.body}, ${response.statusCode}");
    }
  }


  Future<List<Feedback>> fetchIdeaFeedbacks(String ideaId) async {
    final response = await http.get(_getUri("/feedback_api/feedbacks/${ideaId}"));

    if (response.statusCode == 302) {
      final List<dynamic> feedbacksJson = jsonDecode(response.body)["feedbacks"];
      return feedbacksJson.map((feedbackJson) => _createFeedback(feedbackJson)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else{
      throw Exception("Failed to load feedbacks: ${response.body}, ${response.statusCode}");
    }
  }

  Future<User?> fetchUser(String userName, String password) async {
    final response = await http.get(_getUri("/user_api/user/${userName}/${password}"));

    if (response.statusCode == 200){
      final dynamic userJson = jsonDecode(response.body)["user"];
      return _createUser(userJson);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Failed to load user: ${response.body}, ${response.statusCode}");
    }


  }

  Future<List<Tag>> fetchTags() async {
    final response = await http.get(_getUri("/tag_api/tags"));
    if (response.statusCode == 200){
      final Map<String, int> tags = jsonDecode(response.body)["tags"];
      return tags.entries.map((entry) {return Tag(name: entry.key, count: entry.value);}).toList();
    } else {
      throw Exception("Failed to load tags: ${response.body}, ${response.statusCode}");
    }


  }



  Future<User> createUser(String name, String password, String email) async {
    // return the id of the user created
    var response = await http.post(
        _getUri("/user_api/user"),
        headers: {
          "Content-Type": "application/json", // Specify that you're sending JSON data
        },
        body: jsonEncode({
          "name": name,
          "password": password,
          "email": email
        }));

    if (response.statusCode == 201){
      return User(name: name, password: password, email: email);
    }
    throw Exception("Creation went wrong: ${response.body}");
  }

  Future<Idea> createIdea(String ownerName, String subject, String details, List<String> tags) async {
    // return the id of the user created
    var response = await http.post(
        _getUri("/idea_api/idea"),
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
      Map<String, String> idea = jsonDecode(response.body)["idea"];
      return _createIdea(idea);

    }
    throw Exception("Creation went wrong: ${response.body}");
  }

  Future<int> createTag(String tag) async{
    var response = await http.post(_getUri("/tag_api/tag/${tag}"));
    if (response.statusCode != 201) {
      throw Exception("Error creating tag: ${response.body}");
    }
    return jsonDecode(response.body)["count"] as int;

  }

  Future<String> addFeedback(String ideaId, String username, String content) async{
    var response = await http.post(_getUri("/feedback_api/feedback"),
        headers: {
          "Content-Type": "application/json", // Specify that you're sending JSON data
        },
        body: jsonEncode({
          "owner_name": username,
          "content": content,
          "idea_id": ideaId
        }));
    if (response.statusCode != 201) {
      throw Exception("Error creating feedback: ${response.body}, ${response.body}");
    }
    return jsonDecode(response.body)["id"];
  }

  Future<bool> isUsernameUsed(String userName) async {
    var response = await http.get(_getUri("/user_api/user_exist/$userName"));
    if (response.statusCode == 200){
      return jsonDecode(response.body) == "Y";
    }
    throw Exception("Error: ${response.body}");
  }

  void deleteIdea(String ideaId) async {
    await http.delete(_getUri('/idea_api/idea/${ideaId}'));
  }

  void deleteFeedback(String ideaId, String feedbackId) async {
    await http.delete(_getUri('/feedback_api/feedback/${ideaId}/${feedbackId}'));
  }
}