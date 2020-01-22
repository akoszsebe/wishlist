import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/util/theme_provider.dart';
import 'package:wishlist/src/screens/alarm/alarm_controller.dart';

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

  _AlarmScreenState(this.title, this.id) : super(AlarmController()) {
    this._con = controller;
  }
  AlarmController _con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  @override
  void initState() {
    super.initState();
    _con.init();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
        onWillPop: _con.willPopCallback,
        child: Scaffold(key: scaffoldKey, body: buildBody(themeProvider)));
  }

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
              turns: AlwaysStoppedAnimation(330 / 360), 
              child:
             Image(image: AssetImage('resources/images/icons_alarm.png'),color: Colors.grey[100], height: 60,) 
            )
          ]),
          Column(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: DateFormat("HH:mm").format(_con.now),
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat(" a").format(_con.now),
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
          Text("Snooze time is 5 miutes",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ButtonTheme(
                  height: 40,
                  buttonColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: FlatButton.icon(
                      icon:Image(image: AssetImage('resources/images/icons_snooze.png'),color: Colors.white,height: 20,) , 
                      label: Text(
                        "Snooze",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {
                        _con.scheduleAlarm(id, title);
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
                        _con.exitApp();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(70.0))))
            ],
          ),
        ],
      ),
    );
  }
}
