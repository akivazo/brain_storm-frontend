import 'package:brain_storm/data/local_data_manager.dart';
import 'package:brain_storm/entry/app_entry.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) =>  LocalUserManager()),
      ChangeNotifierProvider(create: (context) =>  LocalIdeasManager())
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
