
import 'package:brain_storm/home_page/ideas_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

class MainFeedPage extends ChangeNotifier {

  Widget feedPage = IdeasFeed();

  void setPage(Widget page){
    feedPage = page;
    notifyListeners();
  }
}

class MainFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider.of<MainFeedPage>(context, listen: true).feedPage;
  }
}



