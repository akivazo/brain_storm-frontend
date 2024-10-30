
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/entry/login.dart';
import 'package:brain_storm/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register.dart';
import 'dart:html' as html;

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  late Future<bool> isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    var userManager = Provider.of<UserManager>(context, listen: false);
    isUserLoggedIn = userManager.isUserLoggedIn();
  }

  Future<void> _register(BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RegisterPage()));
    _navigateToHomePage();
  }

  Future<void> _login(BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginPage()));

    _navigateToHomePage();
  }

  void _navigateToHomePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          //return Center(child: Text('An error occurred: ${snapshot.error}'));
        }

        if (snapshot.data!) {
          // user is logged in
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          });
          return Center(child: SizedBox.shrink(),);
        } else {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/entry_point_background.webp"),
                      fit: BoxFit.fill)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
                    Text("Welcom to the BrainStorm app",
                        style: TextStyle(color: Colors.black, fontSize: 35),
                        textAlign: TextAlign.center),
                    Text(
                      "Where you can share your ideas, get help and feedback from other people, or just get inspired from other people ideas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _login(context);
                              },
                              child: Text("Login")),
                          SizedBox(width: 100),
                          ElevatedButton(
                              onPressed: () {
                                _register(context);
                              },
                              child: Text("Register"))
                        ],
                      ),
                    ),
                    SizedBox(height: 100,),

                  ],
                ),
              ),
            ),
          );
      }
      },

    );
  }
}
