import 'package:provider/provider.dart';
import 'server_communicator.dart';
import 'package:flutter/material.dart';
import 'data_models.dart';


class UserManager extends ChangeNotifier {
  late User? _user;
  final _serverCommunicator = ServerCommunicator();

  void setUser(User user){
    _user = user;
  }
  User getUser(){
    return _user!;
  }

  void logout(BuildContext context){
    Navigator.of(context).pop();
  }
  String getUserName(){
    return getUser().name;
  }
  static UserManager getInstance(BuildContext context, {bool listen = false}){
    return Provider.of<UserManager>(context, listen: listen);
  }



  Set<String> getUserFavoritesIdea() {
    return getUser().favorites;
  }

  void addFavoriteIdea(Idea idea){
    getUser().favorites.add(idea.id);
    _serverCommunicator.addUserFavoriteIdea(getUserName(), idea.id);
    notifyListeners();
  }

  void removeFavoriteIdea(Idea idea){
    getUser().favorites.remove(idea.id);
    _serverCommunicator.removeUserFavoriteIdea(getUserName(), idea.id);
    notifyListeners();
  }

  bool isIdeaInUserFavorites(Idea idea) {
    return getUser().favorites.contains(idea.id);
  }
}