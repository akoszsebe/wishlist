import 'package:flutter/material.dart';

class AppTheme {
  static get darkTheme {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;
    final accentIconTheme = ThemeData.dark().accentIconTheme;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        primaryColorLight: Colors.grey[800],
        primaryColorDark: Colors.white,
        accentColor: Colors.cyan[600],
        buttonColor: Colors.grey[900],
        accentIconTheme: accentIconTheme.copyWith(color: Colors.white),
        textSelectionColor: Colors.cyan[200],
        cardColor: Colors.white.withOpacity(0.15),
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
      primaryColorDark: Colors.grey[800],
      accentColor: Colors.cyan[300],
      backgroundColor: Colors.white,
      textSelectionColor: Colors.cyan[200],
      cardColor: Colors.white.withOpacity(0.15),
      toggleableActiveColor: Colors.cyan[300],
      accentIconTheme: accentIconTheme.copyWith(color: Colors.grey[900]),
      primaryTextTheme: primaryTextTheme.apply(bodyColor: Colors.grey[900]),
      scaffoldBackgroundColor: Colors.white,
      primaryIconTheme: primaryIconTheme.copyWith(color: Colors.grey[900]),
    );
  }
}

class CardColors {
  Color color0 = Colors.grey[300];
  Color color1 = Colors.grey[100];
  Color color2 = Colors.grey[100];
  Color color3 = Colors.grey[100];
  Color color4 = Colors.grey[100];
  Color color5 = Colors.grey[100];
  Color color6 = Colors.grey[100];

  static Color colorSelector(category, CardColors cardColors) {
    switch (category) {
      case 1:
        return cardColors.color1;
      case 2:
        return cardColors.color2;
      case 3:
        return cardColors.color3;
      case 4:
        return cardColors.color4;
      case 5:
        return cardColors.color5;
      case 6:
        return cardColors.color6;
      default:
        return cardColors.color0;
    }
  }
}

class CardLightColors extends CardColors {
  Color color1 = Color(0xff4dd0e1);
  Color color2 = Color(0xff2196f3);
  Color color3 = Color(0xffb1d3c5);
  Color color4 = Color(0xfff6b99d);
  Color color5 = Color(0xffecd4d4);
  Color color6 = Color(0xffdeb3cf);
}

class CardDarkColors extends CardColors {
  Color color0 = Colors.grey[800];
  Color color1 = Color(0xff27B6D1);
  Color color2 = Color(0xff2196f3);
  Color color3 = Color(0xff81a295);
  Color color4 = Color(0xffc2896f);
  Color color5 = Color(0xffbaa3a3);
  Color color6 = Color(0xffac839e);
}
