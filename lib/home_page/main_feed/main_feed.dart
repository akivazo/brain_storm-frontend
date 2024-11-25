
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
  late List<String> tags;
  late bool userIdeas;
  late IdeasSortingMethod sortingMethod;
  late Widget page;

  MainFeedPage(){
    restartIdeaFeed();
  }

  void toggleUserIdea(){
    userIdeas = !userIdeas;
    notifyListeners();
  }

  void setSortingMethod(IdeasSortingMethod sortingMethod){
    this.sortingMethod = sortingMethod;
    notifyListeners();
  }

  void showAllIdeas(){
    restartIdeaFeed();
    notifyListeners();
  }

  void showIdeaPage(Idea idea){
    page = ExpendedIdea(idea: idea);
    notifyListeners();
  }
  void setTagToFilter(String tag){
    tags = [tag];
    notifyListeners();
  }

  void restartIdeaFeed(){
    userIdeas = false;
    tags = [];
    sortingMethod = IdeasSortingMethod.TIMESTAMP;
    page = IdeasFeed();
    notifyListeners();
  }



  static MainFeedPage getInstance(BuildContext context, {bool listen = false}){
    return Provider.of<MainFeedPage>(context, listen: listen);
  }
}

class MainFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("yay");
    return Provider.of<MainFeedPage>(context, listen: true).page;
  }
}



