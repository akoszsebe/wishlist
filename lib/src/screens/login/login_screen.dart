import 'package:easy_localization/easy_localization.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/alarm/alarm_screen.dart';
import 'package:wishlist/src/screens/login/login_controller.dart';
import 'package:wishlist/src/screens/todo/home_screen.dart';
import 'package:wishlist/src/util/alert_dialogs.dart';
import 'package:wishlist/src/util/theme_provider.dart';
import 'package:wishlist/src/widgets/buttons/googlesignin_button.dart';

class LoginScreen extends StatefulWidget {
  @protected
  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends StateMVC<LoginScreen> {
  _LoginScreenState() : super(LoginController()) {
    this._con = controller;
  }
  LoginController _con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _con.checkIfStartedForAlarm((alarm,alarmResult) {
      // Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) => AlarmScreen("title:Menjek enni",1434)));
      if (alarm) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => AlarmScreen(alarmResult.title,alarmResult.id)));
      } else {
        _con.checkLogin(() => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()))
            });
      }
    });
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(body: buildBody(themeProvider));
  }

  Widget buildBody(ThemeProvider themeProvider) {
    if (_con.logedIn == null) {
      return Center(child: CircularProgressIndicator());
    }
    print(_con.logedIn);
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context).tr("wellcome"),
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              )),
          Padding(
            padding: EdgeInsets.only(top: 60),
          ),
          GoogleSignInButton(
            onPressed: () {
              showLoaderDialog(context);
              _con.login((err) {
                if (err != null) {
                  Navigator.pop(context);
                  showFlushBar("Error", err);
                } else {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              });
            },
            darkMode: themeProvider.isLightTheme,
          ),
        ]));
  }

  void showFlushBar(String title, String message) {
    Flushbar(
      titleText: Text(title),
      messageText: Text(message),
      backgroundColor: Colors.red[300],
      icon: Icon(Icons.warning),
      duration: Duration(seconds: 5),
    )..show(context);
  }
}
