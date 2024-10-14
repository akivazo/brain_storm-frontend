import 'package:brain_storm/data/data_creator.dart';
import 'package:brain_storm/data/data_fetcher.dart';
import 'package:flutter/material.dart' hide Feedback;

import 'data_models.dart';

class LocalUserManager extends ChangeNotifier {
  late User user;

  void setUser(User user){
    this.user = user;
    notifyListeners();
  }
}


class LocalIdeasManager extends ChangeNotifier {
  late Future<List<Idea>> _ideas;
  final _dataFetcher = DataFetcher();
  final _dataCreator = DataCreator();

  LocalIdeasManager()  {
    _ideas = _dataFetcher.fetchIdeas();
  }

  void createIdea(String ownerName, String subject, String details, List<String> tags){
    Future<Idea> idea = _dataCreator.createIdea(ownerName, subject, details, tags);

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


class LocalFeedbackManager extends ChangeNotifier {

  final _dataFetcher = DataFetcher();
  final _dataCreator = DataCreator();

  Future<List<Feedback>> getIdeaFeedbacks(Idea idea){
    return _dataFetcher.fetchIdeaFeedbacks(idea.id);
  }

}
