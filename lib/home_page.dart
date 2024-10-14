import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/local_data_manager.dart';
import 'package:brain_storm/new_idea.dart';
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
                TrendingIdeas(),
                TagsAndCategories(),
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
    var userManager = Provider.of<LocalUserManager>(context, listen: true);
    var user = userManager.user;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 10),
          Text(user.name),
          SizedBox(height: 5),
          Text('Edit Profile', style: TextStyle(color: Colors.blue)),
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
        ListTile(
          leading: Icon(Icons.feedback),
          title: Text('Feedbacks'),
        ),
      ],
    );
  }
}

// Main Feed Widgets
class MainFeed extends StatefulWidget {
  @override
  State<MainFeed> createState() => _MainFeedState();
}

class _MainFeedState extends State<MainFeed> {

  @override
  Widget build(BuildContext context) {
    final LocalIdeasManager ideasManager = Provider.of<LocalIdeasManager>(context, listen: true);
    final LocalUserManager userManager = Provider.of<LocalUserManager>(context,  listen: true);
    final user = userManager.user;
    var futureIdeas = ideasManager.getIdeas(user.tags);
    return FutureBuilder<List<Idea>>(
        future: futureIdeas,
        builder: (BuildContext context, AsyncSnapshot<List<Idea>> snapshot) {
          if (snapshot.hasData) {
            var ideas = snapshot.data!;
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ideas.length, // Replace with the number of ideas
                itemBuilder: (context, index) {
                  return IdeaCard(idea: ideas[index],);
                }
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Text("Somthing went wrong");
        }

    );
  }
}

class IdeaCard extends StatelessWidget {
  final Idea idea;

  const IdeaCard({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              idea.subject,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(idea.details),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posted by ${idea.owner_name}'),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to view feedback or add feedback
                  },
                  child: Text('Feedback'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
