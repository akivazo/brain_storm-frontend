import 'server_communicator.dart';
import 'package:flutter/material.dart' hide Feedback;

import 'data_models.dart';

class UserManager extends ChangeNotifier {
  late User? user;
  final serverCommunicator = ServerCommunicator();

  void _setUser(User user){
    this.user = user;
    notifyListeners();
  }
  Future<bool> loginUser(String name, String password) async {
    User? user = await serverCommunicator.fetchUser(name, password);
    if (user == null){
      return false;
    }
    _setUser(user);
    return true;
  }

  void registerUser(String name, String password, String email, List<Tag> tags) async {
    User user = await serverCommunicator.createUser(name, password, email, tags);
    _setUser(user);
  }

  Future<bool> isUsernameUsed(String name){
    return serverCommunicator.isUsernameUsed(name);
  }
}


class IdeasManager extends ChangeNotifier {
  late Future<List<Idea>> _ideas;
  final serverCommunicator = ServerCommunicator();

  IdeasManager()  {
    _ideas = serverCommunicator.fetchIdeas();
  }

  void createIdea(String ownerName, String subject, String details, List<String> tags){
    Future<Idea> idea = serverCommunicator.createIdea(ownerName, subject, details, tags);

    _ideas = _ideas.then((ideas) {
      return idea.then((idea) {
        ideas.add(idea);
        return ideas;
      });
    });
    notifyListeners();
    
  }

  Future<List<Idea>> getIdeas(List<Tag> tags){
    return _ideas;
  }
}


class FeedbackManager extends ChangeNotifier {

  final serverCommunicator = ServerCommunicator();

  Future<List<Feedback>> getIdeaFeedbacks(Idea idea){
    return serverCommunicator.fetchIdeaFeedbacks(idea.id);
  }

}

class LocalTagsManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();
  late Future<List<Tag>> tags;

  LocalTagsManager(){
    tags = serverCommunicator.fetchTags();
  }

  Future<List<Tag>> fetchTags() async {
    return tags;
  }

  Future<void> createTag(String tag) async {
    serverCommunicator.createTag(tag);
    tags = tags.then((tags)  {
      tags.add(Tag(name: tag));
      return tags;
    });
  }
}