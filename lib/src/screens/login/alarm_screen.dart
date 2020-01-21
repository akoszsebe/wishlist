import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/login/login_controller.dart';
import 'package:wishlist/util/theme_provider.dart';
import 'package:wishlist/util/alarm_manager.dart';

class AlarmScreen extends StatefulWidget {
  final String title;
  final int id;

  AlarmScreen(this.title, this.id);
  @protected
  @override
  createState() => _AlarmScreenState(title, id);
}

class _AlarmScreenState extends StateMVC<AlarmScreen> {
  String title = "";
  int id;

  _AlarmScreenState(this.title, this.id) : super(LoginController()) {
    this._con = controller;
  }
  LoginController _con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Color ripleColor = Colors.red;
  Color ripleColorGreen = Colors.green;
  @protected
  @override
  void initState() {
    super.initState();
    now = new DateTime.now();
    _con.init();
    FlutterRingtonePlayer.playAlarm();
  }

  DateTime now;
  @protected
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(key: scaffoldKey, body: buildBody(themeProvider));
  }

  bool accepted = false;
  Widget buildBody(ThemeProvider themeProvider) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.grey[900], Theme.of(context).accentColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Stack(alignment: Alignment.center, children: <Widget>[
            Container(
              height: 210,
              child: SpinKitRipple(
                color: Colors.grey,
                size: 210,
              ),
            ),
            RotationTransition(
              turns: new AlwaysStoppedAnimation(330 / 360),
              child: Icon(
                Icons.notifications_active,
                size: 50,
                color: Colors.grey[100],
              ),
            )
          ]),
          Column(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: DateFormat("HH:mm").format(now),
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat(" a").format(now),
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ButtonTheme(
                  height: 40,
                  buttonColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: FlatButton.icon(
                      icon: Icon(
                        Icons.notifications_paused,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Snooze",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {
                        var snoozeDate = DateTime.now();
                        snoozeDate = DateTime(
                                snoozeDate.year,
                                snoozeDate.month,
                                snoozeDate.day,
                                snoozeDate.hour,
                                snoozeDate.minute)
                            .add(Duration(minutes: 5));
                        scheduleNotification(snoozeDate, id, title);
                        exitApp();
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(70.0)))),
              ButtonTheme(
                  height: 40,
                  buttonColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: FlatButton(
                      child: Text(
                        "Dismiss",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {
                        exitApp();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(70.0))))
            ],
          )
        ],
      ),
    );
  }

  Future<void> exitApp() async {
    FlutterRingtonePlayer.stop();
    try {
      print("exit");
      await platform.invokeMethod('finishAndRemoveTask');
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
