import 'package:flutter/material.dart';

class AppTheme {
  static get theme {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        accentColor: Colors.cyan[400],
        buttonColor: Colors.grey[900],
        textSelectionColor: Colors.cyan[200],
        backgroundColor: Colors.grey[900],
        scaffoldBackgroundColor : Colors.grey[900],
        toggleableActiveColor: Colors.cyan[300],
        textTheme: originalTextTheme.copyWith(
            body1:
                originalBody1.copyWith(decorationColor: Colors.transparent)));
  }
}