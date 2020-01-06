  
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/util/theme_provider.dart';

class ThemeChangerScreen extends StatefulWidget {
  ThemeChangerScreen({Key key}) : super(key: key);

  @override
  _ThemeChangerScreenState createState() => _ThemeChangerScreenState();
}

class _ThemeChangerScreenState extends State<ThemeChangerScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).tr('settings')),),
      body: ListView(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(horizontal: 8),),
                Text(themeProvider.isLightTheme? 'Light': 'Dark'),
                Switch(
                  value: themeProvider.isLightTheme,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (val) {
                    themeProvider.setThemeData = val;
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer."),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.accessibility_new), Icon(Icons.account_balance), Icon(Icons.account_box)],
          )
        ],
      ),
    );
  }
}