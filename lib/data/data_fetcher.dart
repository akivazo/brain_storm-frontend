import 'data_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For working with JSON


class DataFetcher {
  final serverIP = "185.253.75.126";
  Idea _createIdea(Map<String, dynamic> json) {
    return Idea(
      id: json['id'],
      owner_name: json['owner_name'],
      subject: json['subject'],
      details: json['details'],
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => Tag(name: tag as String))
          .toList(),
    );
  }

  Feedback _createFeedback(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      ideaId: json['idea_id'],
      ownerId: json['owner_id'],
      content: json['content'],
    );
  }

  User _createUser(Map<String, dynamic> json){
    return User(
      name: json['name'],
      password: json["password"],
      email: json['email'],
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => Tag(name: tag as String))
          .toList(),
    );
  }


  Future<List<Idea>> fetchIdeas({List<String> tags = const []}) async {
    // return only the ideas which has at least one tag from 'tags'
    final response = await http.get(Uri.http('${serverIP}:5001', '/ideas'));

    if (response.statusCode == 200) {
      final List<dynamic> ideasJson = jsonDecode(response.body)["ideas"];
      return ideasJson.map((ideaJson) => _createIdea(ideaJson)).toList();
    } else  {
      throw Exception("Failed to load ideas: ${response.body}, ${response.statusCode}");
    }
  }
  
  Future<List<Feedback>> fetchIdeaFeedbacks(String ideaId) async {
    final response = await http.get(Uri.http("${serverIP}:5003", "/feedbacks/${ideaId}"));

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
    final response = await http.get(Uri.http("${serverIP}:5002", "/user/${userName}/${password}"));

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
    final response = await http.get(Uri.http("${serverIP}:5004", "/tags"));
    if (response.statusCode == 200){
      final List<dynamic> tags = jsonDecode(response.body)["tags"];
      return tags.map((name) => Tag(name: name as String)).toList();
    } else {
      throw Exception("Failed to load tags: ${response.body}, ${response.statusCode}");
    }


  }
}