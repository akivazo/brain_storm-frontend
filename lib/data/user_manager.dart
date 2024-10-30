import 'package:provider/provider.dart';

import 'server_communicator.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'data_models.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:io';

class UserManager extends ChangeNotifier {
  User? user;
  final serverCommunicator = ServerCommunicator();
  late encrypt.Encrypter encrypter;

  UserManager(){
    final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows2');
    // Create an Encrypter with AES algorithm
    encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  String _encryptData(String plainText) {
    final iv = encrypt.IV.fromLength(16); //
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return jsonEncode({
      'iv': base64Encode(iv.bytes), // Convert IV to a base64 string
      'data': encrypted.base64, // The encrypted data in Base64 format
    });
  }


  String _decryptData(String encryptedData) {
    final Map<String, dynamic> encryptedJson = jsonDecode(encryptedData);
    final iv = encrypt.IV.fromBase64(encryptedJson['iv']);

    final decrypted = encrypter.decrypt64(encryptedJson['data'], iv: iv);

    return decrypted;
  }



  void _setUser(User user){
    this.user = user;
    notifyListeners();
  }

  void _cacheUser(User user) async {
    html.window.localStorage["USERNAME"] = _encryptData(user.name);
    html.window.localStorage["PASSWORD"] = _encryptData(user.password);
  }

  Future<bool> _loginFromCache() async {
    var name = html.window.localStorage["USERNAME"];
    var password = html.window.localStorage["PASSWORD"];
    if (name != null && password != null){
      return await loginUser(_decryptData(name), _decryptData(password));
    }

    return false;

  }
  void removeCachedUser() {
    html.window.localStorage.remove("USERNAME");
    html.window.localStorage.remove("PASSWORD");
  }

  Future<bool> isUserLoggedIn() async {
    if (user == null){
      return await _loginFromCache();
    }
    return true;
  }

  Future<bool> loginUser(String name, String password) async {
    User? user = await serverCommunicator.fetchUser(name, password);
    if (user == null){
      return false;
    }
    _cacheUser(user);
    _setUser(user);
    return true;
  }

  void logoutUser(){
    if (user != null){
      removeCachedUser();
      user == null;
    }

  }

  void registerUser(String name, String password, String email, List<Tag> tags) async {
    User user = await serverCommunicator.createUser(name, password, email, tags);
    _setUser(user);
  }

  Future<bool> isUsernameUsed(String name){
    return serverCommunicator.isUsernameUsed(name);
  }
}