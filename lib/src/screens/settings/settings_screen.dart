import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wishlist/util/shared_prefs.dart';
import 'package:wishlist/util/theme_provider.dart';
import 'package:wishlist/util/theme_switch.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  var dropdownValue = 'en';
  bool enableCoolStuff = false;
  bool initialized = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  Animation<Color> background;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (!initialized) {
      if (themeProvider.isLightTheme) {
        setBackgroundColor(
            Theme.of(context).primaryColorDark, Theme.of(context).primaryColor);
      } else {
        setBackgroundColor(
            Theme.of(context).primaryColor, Theme.of(context).primaryColorDark);
      }
      initialized = true;
    }
    enableCoolStuff = !themeProvider.isLightTheme;
    var data = EasyLocalizationProvider.of(context).data;
    if (data.savedLocale != null) dropdownValue = data.savedLocale.languageCode;
    print(dropdownValue);

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: background.value,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(AppLocalizations.of(context).tr('settings')),
              elevation: 0,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: buidThemeSwitch(() => {
                          setState(() {
                            if (enableCoolStuff) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                            themeProvider.setThemeData = enableCoolStuff;
                            SharedPrefs.setTheme(enableCoolStuff);
                          }),
                        })),
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
                if (enableCoolStuff)
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Image(
                          image: AssetImage('resources/images/rabbit_n.png'))),
              ],
            ),
          );
        });
  }

  buidThemeSwitch(callback) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.translucent,
      child: ThemeSwitch(checked: enableCoolStuff),
    );
  }

  void setBackgroundColor(Color primaryColor, Color primaryColorDark) {
    background = ColorTween(
      begin: primaryColor,
      end: primaryColorDark,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }
}
