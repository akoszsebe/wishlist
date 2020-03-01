import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/mvcapp.dart';
import 'package:wishlist/src/util/shared_prefs.dart';
import 'package:wishlist/src/util/theme_provider.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs.getTheme().then((onValue) {
    runApp(EasyLocalization(
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(isLightTheme: onValue),
        child: MVCApp(),
      ),
    ));
    
  });
}