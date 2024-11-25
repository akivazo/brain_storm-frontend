import 'package:brain_storm/data/user_manager.dart';
import 'package:provider/provider.dart';
import 'server_communicator.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'data_models.dart';


class IdeasManager extends ChangeNotifier {
  final serverCommunicator = ServerCommunicator();
  late Map<String, Idea> _ideas;

  IdeasManager(List<Idea> ideas){
    _ideas = { for (var idea in ideas) idea.id : idea };
  }

  Idea getIdea(String ideaId){
    return _ideas[ideaId]!;
  }
  void createIdea(String ownerName, String subject, String details,
      List<String> tags, BuildContext context) async {
    var tagsManager = TagsManager.getInstance(context);
    tagsManager.createTags(tags);

    var idea = await serverCommunicator.createIdea(ownerName, subject, details, tags);
    _ideas[idea.id] = idea;
    notifyListeners();
  }

  List<Idea> getIdeas(List<String> tags) {
    return _ideas.values.where((idea){
        for (var tag in tags){
          if (!idea.tags.contains(tag)){
            return false;
          }
        }
        return true;
      }).toList();
  }

  void addFavorite(Idea idea){
    _ideas[idea.id]!.addFavorite();
    serverCommunicator.addIdeaFavorite(idea.id);
    notifyListeners();
  }

  void removeFavorite(Idea idea){
    _ideas[idea.id]!.removeFavorite();
    serverCommunicator.removeIdeaFavorite(idea.id);
    notifyListeners();
  }

  void removeIdea(Idea idea, BuildContext context) {
    _ideas.remove(idea.id);

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
  late Map<String, List<Feedback>> feedbacks;

  FeedbackManager(this.feedbacks);

  List<Feedback> getIdeaFeedbacks(Idea idea)  {

    return feedbacks[idea.id] ?? [];
  }

  void addFeedback(String userName, Idea idea, String content) async {
    var id = await serverCommunicator.addFeedback(idea.id, userName, content);

    feedbacks[idea.id]!.add(Feedback(id: id, ownerName: userName, content: content));
    notifyListeners();
  }

  void deleteFeedback(Idea idea, Feedback feedback) {
    feedbacks[idea.id]!.remove(feedback);
    serverCommunicator.deleteFeedback(idea.id, feedback.id);
    notifyListeners();
  }



  void deleteIdeaFeedbacks(Idea idea){
    feedbacks.remove(idea.id);
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

  late Map<String, int> tags;

  TagsManager(this.tags);

  Future<void> createTags(List<String> tagsToAdd) async {

    for (var tag in tagsToAdd){
      if (tags.containsKey(tag)){
        tags[tag] = tags[tag]! + 1;
      } else {
        tags[tag] = 1;
      }
      await serverCommunicator.createTag(tag);
    }
    notifyListeners();
  }

  static TagsManager getInstance(BuildContext context, {bool listen = false}) {
    return Provider.of<TagsManager>(context, listen: listen);
  }

  void removeTags(List<String> tagsToRemove) async {
    for (var tag in tagsToRemove){
      if (tags.containsKey(tag)){
        tags[tag] = tags[tag]! - 1;
      }
      await serverCommunicator.removeTag(tag);
    }
    notifyListeners();
  }

  Map<String, int> getTags(){
    return tags;
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
