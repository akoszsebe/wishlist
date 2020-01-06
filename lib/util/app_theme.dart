import 'package:flutter/material.dart';

class AppTheme {
  static get darkTheme {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        accentColor: Colors.cyan[400],
        buttonColor: Colors.grey[900],
        textSelectionColor: Colors.cyan[200],
        backgroundColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        toggleableActiveColor: Colors.cyan[300],
        textTheme: originalTextTheme.copyWith(
            body1:
                originalBody1.copyWith(decorationColor: Colors.transparent)));
  }

  static get lightTheme {
    final primaryIconTheme = ThemeData.light().primaryIconTheme;
    final primaryTextTheme = ThemeData.light().primaryTextTheme;
    return ThemeData.light().copyWith(
      primaryColor: Colors.grey[100],
      accentColor: Colors.cyan[400],
      primaryTextTheme : primaryTextTheme.apply(bodyColor: Colors.grey[900]),
      scaffoldBackgroundColor: Colors.grey[100],
      primaryIconTheme: primaryIconTheme.copyWith(color: Colors.grey[900]),
    );
  }
}
