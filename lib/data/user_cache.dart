import 'dart:convert';
import 'dart:html' as html;
import 'package:encrypt/encrypt.dart' as encrypt;

class UserCacheData{
  final String userName;
  final String password;

  UserCacheData({required this.userName, required this.password});
}

class UserCache {
  late encrypt.Encrypter encrypter;

  UserCache(){
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

  void cacheUser(UserCacheData data) {
    html.window.localStorage["USERNAME"] = _encryptData(data.userName);
    html.window.localStorage["PASSWORD"] = _encryptData(data.password);

  }

  UserCacheData? getCachedUser(){
    var name = html.window.localStorage["USERNAME"];
    var password = html.window.localStorage["PASSWORD"];
    if (name != null && password != null){
      return UserCacheData(userName: _decryptData(name), password: _decryptData(password));
    }
    return null;

  }


  void removeCachedUser() {
    html.window.localStorage.remove("USERNAME");
    html.window.localStorage.remove("PASSWORD");
  }
}
