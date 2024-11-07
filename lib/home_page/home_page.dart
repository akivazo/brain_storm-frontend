
import 'package:brain_storm/home_page/left_panel/filters.dart';
import 'package:brain_storm/home_page/left_panel/tag_filter.dart';
import 'package:brain_storm/home_page/left_panel/user_profile.dart';
import 'package:brain_storm/home_page/main_feed/main_feed.dart';
import 'package:brain_storm/home_page/left_panel/new_idea.dart';
import 'package:flutter/material.dart';


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

