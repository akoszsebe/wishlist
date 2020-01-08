import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/App.dart';
import 'package:wishlist/util/shared_prefs.dart';
import 'package:wishlist/util/theme_provider.dart';

import 'src/App.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]).then((_) {
    SharedPrefs.getTheme().then((onValue) {
      runApp(EasyLocalization(
        child: ChangeNotifierProvider(
          create: (_) => ThemeProvider(isLightTheme: onValue),
          child: MVCApp(),
        ),
      ));
    });
  });
}
