import 'dart:convert';

import 'package:albarq_tools/data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final auth = AuthManager();

class AuthManager {
  static Profile? currentUser;

  Future<void> logout() async {
    Repository.refreshApiClient();
    currentUser = Profile();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    Repository.http().logout();
  }

  Future<Profile?> getCurrentUser() async {
    if (currentUser != null) {
      if (kDebugMode) {
        print("---------------------------------------------------");
        print("--------------  USER ALREADY LOGGED ---------------");
        print("---------------------------------------------------");
      }
      return currentUser!;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('current_user')) {
      var s = prefs.get('current_user');
      currentUser = Profile.fromJson(json.decode(s.toString()));
      if (kDebugMode) {
        print("---------------------------------------------------------");
        print("-------------- found user in SharedPrefs! ---------------");
        print("---------------------------------------------------------");
      }
    } else if (kDebugMode) {
      print("----------------------------------------------");
      print("--------------  NO USER LOGGED ---------------");
      print("---------------------------------------------");
    }
    return currentUser;
  }

  void setCurrentUser(Profile user) async {
    currentUser = user;
    Repository.refreshApiClient();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(user.toJson()));
    } catch (e) {
      // print(CustomTrace(StackTrace.current, message: e.toString()).toString());
      throw Exception(e);
    }
  }
}
