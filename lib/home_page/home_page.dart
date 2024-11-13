
import 'package:brain_storm/home_page/left_panel/filters.dart';
import 'package:brain_storm/home_page/tag_filter.dart';
import 'package:brain_storm/home_page/left_panel/user_profile.dart';
import 'package:brain_storm/home_page/main_feed/main_feed.dart';
import 'package:brain_storm/home_page/left_panel/new_idea.dart';
import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 1000;
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isMobile(context)){
      return MobileHomePage();
    }
    return DesktopHomePage();
  }

}

class MobileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Divider(
            indent: 10,
            endIndent: 10,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(child: Text("Sort By:"), alignment: Alignment.topLeft,),
          ),
          FavoriteSortingIcon(),
          NewestSortingIcon(),
          OldestSortingIcon(),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(child: Text("Fillter By:"), alignment: Alignment.topLeft,),
          ),
          MyIdeasIcon(),
          SizedBox(height: 10,),
          TagsFilter(),
        ],
      ),
    );
  }

}

class MobileHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MobileDrawer(),
      key: _scaffoldKey,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              if (_scaffoldKey.currentState!.isDrawerOpen){
                return SizedBox.shrink();
              }
              return Container(
                color: Colors.purple[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Options:"),
                    ),
                    IconButton(onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    }, icon: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              );
            }
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: MainFeed(),
            ),
          )
        ],
      ),
    );
  }

}
class DesktopHomePage extends StatelessWidget {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child: Text("Sort By:"), alignment: Alignment.topLeft,),
                ),
                FavoriteSortingIcon(),
                NewestSortingIcon(),
                OldestSortingIcon(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 40,
                ),
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
          Container(
            width: 250,
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Filter By:"),
                ),
                MyIdeasIcon(),
                SizedBox(height: 10,),
                TagsFilter(),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// Left Sidebar Widgets

