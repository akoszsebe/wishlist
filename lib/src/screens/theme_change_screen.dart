import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wishlist/util/theme_provider.dart';

class ThemeChangerScreen extends StatefulWidget {
  ThemeChangerScreen({Key key}) : super(key: key);

  @override
  _ThemeChangerScreenState createState() => _ThemeChangerScreenState();
}

class _ThemeChangerScreenState extends State<ThemeChangerScreen> {
  var dropdownValue = 'en';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var data = EasyLocalizationProvider.of(context).data;
    dropdownValue = data.savedLocale.languageCode;
    print(dropdownValue);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr('settings')),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                Text(themeProvider.isLightTheme
                    ? AppLocalizations.of(context).tr('light')
                    : AppLocalizations.of(context).tr('dark')),
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
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                Text(AppLocalizations.of(context).tr('language')),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Theme.of(context).accentColor),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).accentColor,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      print(newValue);
                      dropdownValue = newValue;
                      data.changeLocale(Locale(dropdownValue));
                    });
                  },
                  items: <Tuple2<String, String>>[
                    Tuple2('English', 'en'),
                    Tuple2('Magyar', 'hu')
                  ].map<DropdownMenuItem<String>>(
                      (Tuple2<String, String> value) {
                    return DropdownMenuItem<String>(
                      value: value.item2,
                      child: Text(value.item1),
                    );
                  }).toList(),
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
            children: <Widget>[
              Icon(Icons.accessibility_new),
              Icon(Icons.account_balance),
              Icon(Icons.account_box)
            ],
          )
        ],
      ),
    );
  }
}
