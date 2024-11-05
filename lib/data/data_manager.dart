import 'dart:js_interop';

import 'package:brain_storm/data/user_manager.dart';
import 'package:provider/provider.dart';

import 'server_communicator.dart';
import 'package:flutter/material.dart' hide Feedback;

import 'data_models.dart';


class IdeasManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();



  void createIdea(String ownerName, String subject, String details,
      List<String> tags, BuildContext context) {
    var tagsManager = TagsManager.getInstance(context);
    tagsManager.createTags(tags);
    serverCommunicator.createIdea(ownerName, subject, details, tags);
    notifyListeners();
  }

  Future<Set<Idea>> getIdeas(List<String> tags) {
    return serverCommunicator.fetchIdeas().then((ideas) {return ideas.toSet();});
  }

  void addFavorite(Idea idea){

    serverCommunicator.addIdeaFavorite(idea.id);
  }

  void removeFavorite(Idea idea){
    serverCommunicator.removeIdeaFavorite(idea.id);
  }

  void removeIdea(Idea idea, BuildContext context) {
    var tagsManager = TagsManager.getInstance(context);
    var feedbackManager = FeedbackManager.getInstance(context);
    var userManager = UserManager.getInstance(context);

    userManager.removeFavoriteIdea(idea);
    feedbackManager.deleteIdeaFeedbacks(idea);
    tagsManager.removeTags(idea.tags);

    serverCommunicator.deleteIdea(idea.id);

    notifyListeners();
  }

  static IdeasManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<IdeasManager>(context, listen: listen);
  }
}

class FeedbackManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();

  Future<List<Feedback>> _getIdeaFeedbacks(Idea idea) {
    return serverCommunicator.fetchIdeaFeedbacks(idea.id);
  }

  Future<List<Feedback>> getIdeaFeedbacks(Idea idea) async {

    return _getIdeaFeedbacks(idea);
  }

  void addFeedback(String userName, Idea idea, String content) async {
    var id = await serverCommunicator.addFeedback(idea.id, userName, content);
    Feedback(id: id, ownerName: userName, content: content);

    notifyListeners();
  }

  void deleteFeedback(Idea idea, Feedback feedback) {
    serverCommunicator.deleteFeedback(idea.id, feedback.id);
    notifyListeners();
  }



  void deleteIdeaFeedbacks(Idea idea){
    serverCommunicator.deleteIdeaFeedbacks(idea.id);
    notifyListeners();
  }

  static FeedbackManager getInstance(BuildContext context,
      {bool listen = false}) {
    return Provider.of<FeedbackManager>(context, listen: listen);
  }
}

class TagsManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();



  Future<Map<String, int>> getTags() async {
    return serverCommunicator.fetchTags();
  }

  Future<void> createTags(List<String> tagsToAdd) async {
    for (var tag in tagsToAdd){
      await serverCommunicator.createTag(tag);
    }
    notifyListeners();
  }

  static TagsManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<TagsManager>(context, listen: listen);
  }

  void removeTags(List<String> tagsToRemove) async {
    for (var tag in tagsToRemove){
      await serverCommunicator.removeTag(tag);
    }
    notifyListeners();
  }
}

class FavoriteManager extends ChangeNotifier {

  void addFavorite(Idea idea, BuildContext context) {
    var userManager = UserManager.getInstance(context);
    var ideaManager = IdeasManager.getInstance(context);

    userManager.addFavoriteIdea(idea);
    ideaManager.addFavorite(idea);
  }

  void removeFavorite(Idea idea, BuildContext context) {
    var userManager = UserManager.getInstance(context);
    var ideaManager = IdeasManager.getInstance(context);

    userManager.removeFavoriteIdea(idea);
    ideaManager.removeFavorite(idea);
  }


  static FavoriteManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<FavoriteManager>(context, listen: listen);
  }
}
