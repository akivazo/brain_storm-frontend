import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_cache.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/ideas_feed.dart';
import 'package:brain_storm/home_page/tag_filter.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:brain_storm/home_page/new_idea.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              children: [
                UserProfile(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 40,
                ),
                NewIdeaButton(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 40,
                ),
                ShowAllIdeasIcon(),
                FavoriteFilterIcon(),
                MyIdeasIcon(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 40,
                ),
                TagsFilter()
              ],
            ),
          ),

          // Main Feed
          Expanded(
            child: Container(
              color: Colors.white,
              child: MainFeed(),
            ),
          ),
        ],
      ),
    );
  }
}


// Left Sidebar Widgets
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userManager = UserManager.getInstance(context);
    var userName = userManager.getUserName();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              userName,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                UserCache().removeCachedUser();
                Navigator.pop(context);
              },
              child: Text("Logout"))
        ],
      ),
    );
  }
}

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
