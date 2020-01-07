import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/App.dart';
import 'package:wishlist/util/theme_provider.dart';

import 'src/App.dart';

void main() {
  runApp(EasyLocalization(
    child: ChangeNotifierProvider(
      create: (_) => ThemeProvider(isLightTheme: false ),
      child: MVCApp(),
    ),
  ));
}
