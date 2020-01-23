import 'package:flutter/material.dart';

class AppTheme {
  static get darkTheme {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;
    final accentIconTheme = ThemeData.dark().accentIconTheme;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        primaryColorLight: Colors.grey[800],
        accentColor: Colors.cyan[600],
        buttonColor: Colors.grey[900],
        accentIconTheme: accentIconTheme.copyWith(color: Colors.white),
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
    final accentIconTheme = ThemeData.dark().accentIconTheme;
    return ThemeData.light().copyWith(
      primaryColor: Colors.white,
      primaryColorLight: Colors.white,
      accentColor: Colors.cyan[300],
      backgroundColor: Colors.white,
      textSelectionColor: Colors.cyan[200],
      cardColor: Colors.grey[200],
      toggleableActiveColor: Colors.cyan[300],
      accentIconTheme: accentIconTheme.copyWith(color: Colors.grey[900]),
      primaryTextTheme: primaryTextTheme.apply(bodyColor: Colors.grey[900]),
      scaffoldBackgroundColor: Colors.white,
      primaryIconTheme: primaryIconTheme.copyWith(color: Colors.grey[900]),
    );
  }
}

class CardColors{
  Color color1 = Colors.grey[100];
  Color color2 = Colors.grey[100];
  Color color3 = Colors.grey[100];
}

class CardLightColors extends CardColors{
  Color color1 = Color(0xff4dd0e1);//Colors.grey[300];
  Color color2 = Color(0xff2196f3);//Colors.orange[200];
  Color color3 = Color(0xff7986cb);//Colors.red[200];
}

class CardDarkColors extends CardColors{
  Color color1 = Color(0xff27B6D1);//Colors.grey[800];
  Color color2 = Color(0xff516EEC);
  Color color3 = Color(0xff334CA9);
}
