import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _theme = "theme";

  static Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_theme) ?? false;
  }

   static Future<bool> setTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_theme, value);
  }

}