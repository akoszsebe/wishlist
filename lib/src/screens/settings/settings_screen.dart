import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wishlist/util/shared_prefs.dart';
import 'package:wishlist/util/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var dropdownValue = 'en';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var data = EasyLocalizationProvider.of(context).data;
    if (data.savedLocale != null) dropdownValue = data.savedLocale.languageCode;
    print(dropdownValue);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr('settings')),
        elevation: 2,
        actions: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.brightness_3,
                color: themeProvider.isLightTheme
                    ? Colors.grey[400]
                    : Colors.yellow[600],
              ),
              Switch(
                value: themeProvider.isLightTheme,
                activeColor: Colors.grey[400],
                inactiveThumbColor: Colors.yellow[600],
                inactiveTrackColor: Colors.yellow[200],
                onChanged: (val) {
                  themeProvider.setThemeData = val;
                  SharedPrefs.setTheme(val);
                },
              ),
              Icon(
                Icons.wb_sunny,
                color: themeProvider.isLightTheme
                    ? Colors.yellow[600]
                    : Colors.grey[400],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
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
          ),
        ],
      ),
    );
  }
}
