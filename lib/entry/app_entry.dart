
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/entry/login.dart';
import 'package:brain_storm/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register.dart';

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  Future<void> _register(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> _login(BuildContext context) async {
     await Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
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
              SizedBox(height: 100,),
              Text("Welcom to the BrainStorm app",
                  style: TextStyle(color: Colors.black, fontSize: 35),
                  textAlign: TextAlign.center),
              Text(
                "Where you can share your ideas, get help and feedback from other people, or just get inspired from other people ideas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 2 ,),
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
}
