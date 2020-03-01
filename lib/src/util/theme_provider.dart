import 'package:flutter/material.dart';
import 'package:wishlist/src/util/style/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme = false;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? AppTheme.lightTheme : AppTheme.darkTheme;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }
}