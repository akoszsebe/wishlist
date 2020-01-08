import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/src/screens/todo/home_screen.dart';
import 'package:wishlist/src/screens/settings/settings_screen.dart';
import 'package:wishlist/util/app_routes.dart';
import 'package:wishlist/util/theme_provider.dart';

class MVCApp extends AppMVC {
  MVCApp({Key key}) : super(con: _controller, key: key);

  /// An external reference to the Controller if you wish. -gp
  static final TodoController _controller = TodoController();

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mvc example',
      theme: themeProvider.getThemeData,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        //app-specific localization
        EasylocaLizationDelegate(
          locale: data.locale,
          path: 'resources/langs',
        ),
      ],
      supportedLocales: [Locale('en','US'), Locale('hu','HU')],
      locale: data.savedLocale,
      routes: {
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.changeTheme: (context) => SettingsScreen(),
      },
    );
  }
}
