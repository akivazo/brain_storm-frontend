
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/filter_view.dart';
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
                NavigationMenu(),
                NewIdeaButton(),
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

          // Right Sidebar
          Container(
            width: 250,
            color: Colors.grey[300],
            child: Column(
              children: [
                FilterView()
              ],
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
    var userManager = Provider.of<UserManager>(context, listen: true);
    var userName = userManager.getUserName();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 10),
          Text(userName),
          SizedBox(height: 5),
          Text('Edit Profile', style: TextStyle(color: Colors.blue)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              userManager.logoutUser();
              Navigator.pop(context);
            }, child: Text("Logout")),
          )
        ],
      ),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.lightbulb_outline),
          title: Text('My Ideas'),
        ),
        ListTile(
          leading: Icon(Icons.trending_up),
          title: Text('Trending Ideas'),
        ),

      ],
    );
  }
}

// Main Feed Widgets

// Right Sidebar Widgets
class TrendingIdeas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trending Ideas', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Idea 1'),
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Idea 2'),
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Idea 3'),
          ),
        ],
      ),
    );
  }
}

class TagsAndCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tags & Categories', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Chip(label: Text('Tech')),
          Chip(label: Text('Business')),
          Chip(label: Text('Design')),
        ],
      ),
    );
  }
}
