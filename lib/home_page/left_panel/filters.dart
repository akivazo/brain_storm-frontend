import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_cache.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed/ideas_feed.dart';
import 'package:brain_storm/home_page/left_panel/tag_filter.dart';
import 'package:brain_storm/home_page/main_feed/main_feed.dart';
import 'package:brain_storm/home_page/left_panel/new_idea.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ShowAllIdeasIcon extends StatelessWidget {
  const ShowAllIdeasIcon({super.key});

  @override
  Widget build(BuildContext context) {
    var mainFeedPage = MainFeedPage.getInstance(context);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.list),
        ),
        TextButton(
            onPressed: () {
              mainFeedPage.setPage(IdeasFeed());
            },
            child: Text("All ideas")),
      ],
    );
  }
}

class FavoriteFilterIcon extends StatelessWidget {
  const FavoriteFilterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.thumb_up_alt_outlined),
        ),
        TextButton(
            onPressed: () {
              var mainFeedPage = MainFeedPage.getInstance(context);
              mainFeedPage.setPage(IdeasFeed(
                sortingMethod: IdeasSortingMethod.FAVORITES,
              ));
            },
            child: Text("Most Liked Ideas"))
      ],
    );
  }
}

class MyIdeasIcon extends StatelessWidget {
  const MyIdeasIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.lightbulb_outline),
        ),
        TextButton(
            onPressed: () {
              var mainFeedPage = MainFeedPage.getInstance(context);
              mainFeedPage.setPage(IdeasFeed(userIdeas: true));
            },
            child: Text("My Ideas"))
      ],
    );
  }
}