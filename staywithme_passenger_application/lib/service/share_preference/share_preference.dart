import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<SharedPreferences> initSharedPreferenced() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  static Future<void> saveUserLoginInfo(
      String username, String email, String accessToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("userLoginInfo",
        [utf8.decode(username.runes.toList()), email, accessToken]);
  }

  static Future<Map<String, String>> getUserLoginInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> userLoginInfo =
        sharedPreferences.getStringList("userLoginInfo")!;
    Map<String, String> userLoginInfoMap = {
      "username": userLoginInfo[0],
      "email": userLoginInfo[1],
      "accessToken": userLoginInfo[2]
    };
    return userLoginInfoMap;
  }

  static Future<bool> isUserSignIn() async {
    SharedPreferences sharedPreferences = await initSharedPreferenced();
    bool isUserSignIn = sharedPreferences.containsKey("userLoginInfo");
    return isUserSignIn;
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences sharedPreferences = await initSharedPreferenced();
    sharedPreferences.remove("userLoginInfo");
  }
}
