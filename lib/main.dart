import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/entry/app_entry.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


void main() {

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) =>  UserManager()),
      ChangeNotifierProvider(create: (context) =>  IdeasManager()),
      ChangeNotifierProvider(create: (context) =>  LocalTagsManager())
     ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Storm',
      home: EntryPoint()
    );
  }
}
