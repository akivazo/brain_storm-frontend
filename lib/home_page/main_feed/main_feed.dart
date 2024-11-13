
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/home_page/main_feed/expended_idea.dart';
import 'package:brain_storm/home_page/main_feed/ideas_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

enum IdeasSortingMethod {
  TIMESTAMP,
  TIMESTAMP_REVERSE,
  FAVORITES,
}

class MainFeedPage extends ChangeNotifier {
  List<String> tags;
  bool userIdeas = false;
  IdeasSortingMethod sortingMethod;
  Widget page = IdeasFeed();

  MainFeedPage({this.tags = const [], this.sortingMethod = IdeasSortingMethod.TIMESTAMP});

  void toggleUserIdea(){
    userIdeas = !userIdeas;
    notifyListeners();
  }

  void setSortingMethod(IdeasSortingMethod sortingMethod){
    this.sortingMethod = sortingMethod;
    notifyListeners();
  }

  void setTags(List<String> tags){
    this.tags = tags;
    notifyListeners();
  }
  void goToIdeaFeed(Idea idea){
    setPage(ExpendedIdea(idea: idea));
    notifyListeners();
  }

  void goToIdeasFeed(){
    setPage(IdeasFeed());
  }

  void setPage(Widget page){
    this.page = page;
    notifyListeners();
  }

  static MainFeedPage getInstance(BuildContext context, {bool listen = false}){
    return Provider.of<MainFeedPage>(context, listen: listen);
  }
}

class MainFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider.of<MainFeedPage>(context, listen: true).page;
  }
}



