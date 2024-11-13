import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_cache.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed/ideas_feed.dart';
import 'package:brain_storm/home_page/tag_filter.dart';
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

class NewestSortingIcon extends StatelessWidget {
  const NewestSortingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.access_time),
        ),
        TextButton(
            onPressed: () {
              var mainFeedPage = MainFeedPage.getInstance(context);
              mainFeedPage.setSortingMethod(IdeasSortingMethod.TIMESTAMP);
            },
            child: Text("Newest Ideas"))
      ],
    );
  }
}

class OldestSortingIcon extends StatelessWidget {
  const OldestSortingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.hourglass_bottom_sharp),
        ),
        TextButton(
            onPressed: () {
              var mainFeedPage = MainFeedPage.getInstance(context);
              mainFeedPage.setSortingMethod(IdeasSortingMethod.TIMESTAMP_REVERSE);
            },
            child: Text("Oldest Ideas"))
      ],
    );
  }
}

class FavoriteSortingIcon extends StatelessWidget {
  const FavoriteSortingIcon({super.key});

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
              mainFeedPage.setSortingMethod(IdeasSortingMethod.FAVORITES);
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
              mainFeedPage.toggleUserIdea();
            },
            child: Text("My Ideas"))
      ],
    );
  }
}