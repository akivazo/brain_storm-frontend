import 'dart:js_interop';

import 'package:provider/provider.dart';

import 'server_communicator.dart';
import 'package:flutter/material.dart' hide Feedback;

import 'data_models.dart';


class IdeasManager extends ChangeNotifier {
  late Future<Set<Idea>> _ideas;
  final serverCommunicator = ServerCommunicator();

  IdeasManager() {
    _ideas = serverCommunicator.fetchIdeas().then((ideas) {
      return ideas.toSet();
    });
  }

  void createIdea(String ownerName, String subject, String details,
      List<String> tags, BuildContext context) {
    var tagsManager = TagsManager.getInstance(context);
    tagsManager.createTags(tags);
    Future<Idea> idea = serverCommunicator.createIdea(ownerName, subject, details, tags);
    _ideas = _ideas.then((ideas) {
      return idea.then((idea) {
        ideas.add(idea);
        return ideas;
      });
    });
    notifyListeners();
  }

  Future<Set<Idea>> getIdeas(List<String> tags) {
    return _ideas.then((ideas) {
      return ideas.where((idea) {
        for (var desiredTag in tags) {
          if (!idea.tags.contains(desiredTag)) {
            return false;
          }
        }
        return true;
      }).toSet();
    });
  }

  void removeIdea(Idea idea, BuildContext context) {
    var tagsManager = TagsManager.getInstance(context);
    FeedbackManager feedbackManager = FeedbackManager.getInstance(context);

    feedbackManager.deleteIdeaFeedbacks(idea);
    tagsManager.removeTags(idea.tags);
    _ideas = _ideas.then((ideas) {
      ideas.remove(idea);
      return ideas;
    });

    serverCommunicator.deleteIdea(idea.id);
    serverCommunicator.deleteIdeaFeedbacks(idea.id);

    notifyListeners();
  }

  static IdeasManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<IdeasManager>(context, listen: listen);
  }
}

class FeedbackManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();
  Map<String, Future<List<Feedback>>> ideasFeedbacks = {};

  Future<List<Feedback>> _getIdeaFeedbacks(Idea idea) {
    return serverCommunicator.fetchIdeaFeedbacks(idea.id);
  }

  Future<List<Feedback>> getIdeaFeedbacks(Idea idea) async {
    if (ideasFeedbacks.containsKey(idea.id)) {
      return ideasFeedbacks[idea.id]!;
    }
    Future<List<Feedback>> feedbacks = _getIdeaFeedbacks(idea);
    ideasFeedbacks[idea.id] = feedbacks;
    return feedbacks;
  }

  void addFeedback(User user, Idea idea, String content) async {
    var id = await serverCommunicator.addFeedback(idea.id, user.name, content);
    var feedback = Feedback(id: id, ownerName: user.name, content: content);
    if (!ideasFeedbacks.containsKey(idea.id)) {
      ideasFeedbacks[idea.id] = Future.value(List<Feedback>.empty());
    }
    ideasFeedbacks[idea.id] = ideasFeedbacks[idea.id]!.then((value) {
      value.add(feedback);
      return value;
    });
    notifyListeners();
  }

  void deleteFeedback(Idea idea, Feedback feedback) {
    ideasFeedbacks[idea.id] = ideasFeedbacks[idea.id]!.then((feedbacks) {
      feedbacks.remove(feedback);
      return feedbacks;
    });
    serverCommunicator.deleteFeedback(idea.id, feedback.id);
    notifyListeners();
  }



  void deleteIdeaFeedbacks(Idea idea){
    if (ideasFeedbacks.containsKey(idea.id)) {
      ideasFeedbacks.remove(idea.id);
      serverCommunicator.deleteIdeaFeedbacks(idea.id);
      notifyListeners();
    }

  }

  static FeedbackManager getInstance(BuildContext context,
      {bool listen = false}) {
    return Provider.of<FeedbackManager>(context, listen: listen);
  }
}

class TagsManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();
  late Future<Map<String, int>> tags;

  TagsManager() {
    tags = serverCommunicator.fetchTags();
  }

  Future<List<String>> getSortedTags(){
    var sortedTags = tags.then((tags) {
      var _tags = tags.entries
          .toList();
        _tags.sort((a, b) => a.value.compareTo(b.value));
        return _tags.map((entry) => entry.key).toList();
    });
    return sortedTags;
  }

  Future<Map<String, int>> getTags() async {
    return tags;
  }

  Future<void> createTags(List<String> tagsToAdd) async {
    for (var tag in tagsToAdd){
      var count = await serverCommunicator.createTag(tag);
      tags = tags.then((tags) {
        tags[tag] = count;
        return tags;
      });
    }
    notifyListeners();
  }

  static TagsManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<TagsManager>(context, listen: listen);
  }

  void removeTags(List<String> tagsToRemove) async {
    for (var tag in tagsToRemove){
      var count = await serverCommunicator.removeTag(tag);

      if (count == 0) {
        tags = tags.then((tags) {
          tags.remove(tag);
          return tags;
        });
      } else {
        tags = tags.then((tags) {
          tags[tag] = count;
          return tags;
        });
      }
    }
    notifyListeners();
  }
}

class FavoriteManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();

  void addFavorite(User user, Idea idea) {
    serverCommunicator.addFavoriteIdea(user.name, idea.id);
  }

  void removeFavorite(User user, Idea idea) {
    serverCommunicator.removeFavoriteIdea(user.name, idea.id);
  }

  static FavoriteManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<FavoriteManager>(context, listen: listen);
  }
}
