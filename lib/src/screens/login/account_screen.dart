import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wishlist/src/screens/login/login_controller.dart';
import 'package:wishlist/src/screens/login/login_screen.dart';
import 'package:wishlist/util/shared_prefs.dart';
import 'package:wishlist/util/theme_provider.dart';
import 'package:wishlist/util/theme_switch.dart';
import 'package:wishlist/util/widgets.dart';

class AccountScreen extends StatefulWidget {
  @protected
  @override
  createState() => _AccountScreenState();
}

class _AccountScreenState extends StateMVC<AccountScreen>
    with SingleTickerProviderStateMixin {
  _AccountScreenState() : super(LoginController()) {
    this._con = controller;
  }
  LoginController _con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var dropdownValue = 'en';
  bool enableCoolStuff = false;
  bool initialized = false;
  AnimationController _animationController;
  Animation<Color> background;

  @protected
  @override
  void initState() {
    super.initState();
    _con.init();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @protected
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
    return Scaffold(body: buildBody(themeProvider, data));
  }

  Widget buildBody(ThemeProvider themeProvider, easyLocalizationState) {
    final userData = _con.userData;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: userData == null
              ? CircularProgressIndicator()
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  userData.displayName,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  userData.userId,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w400),
                                ),
                                buildButton(
                                    AppLocalizations.of(context)
                                        .tr('profile.sign_out'), () {
                                  _con.logout();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }), ModalRoute.withName('/'));
                                }, Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColorDark)
                              ],
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                userData.photoUrl,
                              ),
                              radius: 40,
                              backgroundColor: Colors.transparent,
                            ),
                          ],
                        )),
                    SizedBox(height: 40),
                    ListTile(
                      title: Text(AppLocalizations.of(context).tr('language')),
                      trailing: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.keyboard_arrow_down),
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
                            easyLocalizationState
                                .changeLocale(Locale(dropdownValue));
                            dropdownValue = newValue;
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
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 16, right: 16),
                        child: Container(
                          height: 1,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                        )),
                    ListTile(
                        title: Text(AppLocalizations.of(context).tr('theme')),
                        trailing: Container(
                            width: 54,
                            child: buidThemeSwitch(() {
                              if (enableCoolStuff) {
                                _animationController.forward();
                              } else {
                                _animationController.reverse();
                              }
                              themeProvider.setThemeData = enableCoolStuff;
                              SharedPrefs.setTheme(enableCoolStuff);
                            }))),
                    Padding(
                        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                        child: Container(
                          height: 1,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                        )),
                  ],
                ),
        ),
      ),
    );
  }

  void setBackgroundColor(Color primaryColor, Color primaryColorDark) {
    background = ColorTween(
      begin: primaryColor,
      end: primaryColorDark,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  buidThemeSwitch(callback) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.translucent,
      child: ThemeSwitch(checked: enableCoolStuff),
    );
  }
}
