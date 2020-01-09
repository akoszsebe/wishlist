import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishlist/src/datamodels/user_model.dart';
import 'dart:convert';

class SharedPrefs {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _theme = "theme";
  static final String _userData = "userdata";

  static Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_theme) ?? false;
  }

  static Future<bool> setTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_theme, value);
  }

  static Future<UserModel> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdataJson = prefs.getString(_userData);
    if (userdataJson != null) {
      return UserModel.fromJson(json.decode(userdataJson));
    }
    return null;
  }

  static Future<bool> setUserData(UserModel value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userData, json.encode(value.toJson()));
  }
}
