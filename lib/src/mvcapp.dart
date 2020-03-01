import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/login/account_screen.dart';
import 'package:wishlist/src/screens/login/login_screen.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/src/screens/todo/home_screen.dart';
import 'package:wishlist/src/util/app_routes.dart';
import 'package:wishlist/src/util/theme_provider.dart';

class MVCApp extends AppMVC {
  MVCApp({Key key}) : super(con: _todocontroller, key: key);

  /// An external reference to the Controller if you wish. -gp
  static final TodoController _todocontroller = TodoController();

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'wishlist',
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
      supportedLocales: [Locale('en', 'US'), Locale('hu', 'HU')],
      locale: data.savedLocale,
      routes: {
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.changeTheme: (context) => AccountScreen(),
      },
    );
  }
}
