import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/server_communicator.dart';
import 'package:brain_storm/data/user_cache.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/entry/app_entry.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


void main() async {
  var serverCommunicator = ServerCommunicator();
  var ideas = await serverCommunicator.fetchIdeas();
  var feedbacks = {for (var idea in ideas) idea.id : await serverCommunicator.fetchIdeaFeedbacks(idea.id)};
  var tags = await serverCommunicator.fetchTags();
  var userCachedData = UserCache().getCachedUser();
  User? user;

  if (userCachedData != null) {
    user = await ServerCommunicator().fetchUser(userCachedData.userName, userCachedData.password);
  }

  print(user);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) =>  IdeasManager(ideas)),
      ChangeNotifierProvider(create: (context) =>  FeedbackManager(feedbacks)),
      ChangeNotifierProvider(create: (context) =>  MainFeedPage()),
      ChangeNotifierProvider(create: (context) =>  TagsManager(tags)),
      ChangeNotifierProvider(create: (context) =>  FavoriteManager()),
      ChangeNotifierProvider(create: (context) =>  UserManager()),
     ],
    child: MyApp(user: user,),
  ));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({super.key, this.user});
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Brain Storm',
        home: EntryPoint(user: user,)
    );
  }
}
