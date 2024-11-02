import 'package:provider/provider.dart';

import 'server_communicator.dart';
import 'package:flutter/material.dart' hide Feedback;

import 'data_models.dart';







class IdeasManager extends ChangeNotifier {
  late Future<Set<Idea>> _ideas;
  final serverCommunicator = ServerCommunicator();

  IdeasManager()  {
    _ideas = serverCommunicator.fetchIdeas().then((ideas) {return ideas.toSet();});
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

  Future<Set<Idea>> getIdeas(List<Tag> tags){
    return _ideas;
  }

  void removeIdea(Idea idea){
    _ideas = _ideas.then((ideas) {
      ideas.remove(idea);
      return ideas;
    });
    serverCommunicator.deleteIdea(idea.id);
    notifyListeners();
  }
}


class FeedbackManager extends ChangeNotifier {

  final serverCommunicator = ServerCommunicator();
  Map<String, Future<List<Feedback>>> ideasFeedbacks = {};

  Future<List<Feedback>> _getIdeaFeedbacks(Idea idea){
    return serverCommunicator.fetchIdeaFeedbacks(idea.id);
  }

  Future<List<Feedback>> getIdeaFeedbacks(Idea idea) async {
    if (ideasFeedbacks.containsKey(idea.id)){
      return ideasFeedbacks[idea.id]!;
    }
    Future<List<Feedback>> feedbacks = _getIdeaFeedbacks(idea);
    ideasFeedbacks[idea.id] = feedbacks;
    return feedbacks;
  }

  void addFeedback(User user, Idea idea, String content) async{
    var id = await serverCommunicator.addFeedback(idea.id, user.name, content);
    var feedback =  Feedback(id: id, ownerName: user.name, content: content);
    if (!ideasFeedbacks.containsKey(idea.id)) {
      ideasFeedbacks[idea.id] = Future.value(List<Feedback>.empty());
    }
    ideasFeedbacks[idea.id] = ideasFeedbacks[idea.id]!.then((value) {
      value.add(feedback);
      return value;
    });
    notifyListeners();
  }

  void deleteFeedback(Idea idea, Feedback feedback){
    ideasFeedbacks[idea.id] = ideasFeedbacks[idea.id]!.then((feedbacks) {
      feedbacks.remove(feedback);
      return feedbacks;
    });
    serverCommunicator.deleteFeedback(idea.id, feedback.id);
    notifyListeners();
  }
  static FeedbackManager getInstance(BuildContext context, {bool listen = false}){
    return Provider.of<FeedbackManager>(context, listen: listen);
  }

}

class TagsManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();
  late Future<List<Tag>> tags;

  Future<List<Tag>> fetchTags() async {
    tags = serverCommunicator.fetchTags();
    return tags;
  }

  Future<void> createTag(String tag) async {
    var count = await serverCommunicator.createTag(tag);
    tags = tags.then((tags)  {
      tags.add(Tag(name: tag, count: count));
      return tags;
    });
    notifyListeners();
  }


}

