
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/home_page/main_feed/expended_idea.dart';
import 'package:brain_storm/home_page/main_feed/ideas_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

class MainFeedPage extends ChangeNotifier {
  Widget _ideasFeed = IdeasFeed();
  Widget? feedPage;

  MainFeedPage(){
    feedPage = _ideasFeed;
  }

  Widget getPage(){
    return feedPage!;
  }
  void goToIdeaFeed(Idea idea){
    setPage(ExpendedIdea(idea: idea));
  }

  void goToIdeasFeed(){
    setPage(_ideasFeed);
  }

  void setPage(Widget page){
    feedPage = page;
    notifyListeners();
  }

  static MainFeedPage getInstance(BuildContext context, {bool listen = false}){
    return Provider.of<MainFeedPage>(context, listen: listen);
  }
}

class MainFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider.of<MainFeedPage>(context, listen: true).getPage();
  }
}



