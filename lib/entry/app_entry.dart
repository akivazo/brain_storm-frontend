import 'package:brain_storm/data/data_creator.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/local_data_manager.dart';
import 'package:brain_storm/entry/login.dart';
import 'package:brain_storm/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register.dart';
import 'tags_picker.dart';

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  void _goToHomePage(User user, BuildContext context) async {
    var localUSerManager = Provider.of<LocalUserManager>(context, listen: false);
    localUSerManager.setUser(user);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> _register(BuildContext context) async {
    var user = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));

    var dataCreator = DataCreator();
    dataCreator.createUser(user.name, user.password, user.email, user.tags);
    _goToHomePage(user, context);
  }

  Future<void> _login(BuildContext context) async {
    var user = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
    _goToHomePage(user as User, context);
  }

  @override
  Widget build(BuildContext context) {
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
              Text("Welcom to the BrainStorm app",
                  style: TextStyle(color: Colors.black, fontSize: 35),
                  textAlign: TextAlign.center),
              Text(
                "Where you can share your ideas, get help and feedback from other people, or just get inspired from other people ideas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              SizedBox(
                height: 750,
              ),
              Row(
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
              )

            ],
          ),
        ),
      ),
    );
  }
}
