
import 'package:brain_storm/data/user_cache.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userManager = UserManager.getInstance(context);
    var userName = userManager.getUserName();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Builder(

              builder: (context) {
                var nameToPresent = userName;
                if (userName.length > 5){
                  nameToPresent = userName.substring(0, 5);
                }
                return Text(
                  nameToPresent,
                );
              }
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                UserCache().removeCachedUser();
                Navigator.pop(context);
              },
              child: Text("Logout"))
        ],
      ),
    );
  }
}