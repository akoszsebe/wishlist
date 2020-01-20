import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/login/login_controller.dart';
import 'package:wishlist/util/theme_provider.dart';

class AlarmScreen extends StatefulWidget {
  String title;

  AlarmScreen(this.title);
  @protected
  @override
  createState() => _AlarmScreenState(title);
}

class _AlarmScreenState extends StateMVC<AlarmScreen> {
  String title = "";

  _AlarmScreenState(this.title) : super(LoginController()) {
    this._con = controller;
  }
  LoginController _con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  @override
  void initState() {
    super.initState();
    _con.init();
    FlutterRingtonePlayer.playAlarm();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: buildBody(themeProvider),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: ButtonTheme(
            height: 140,
            minWidth: 140,
              child: RaisedButton(
                  child: Text("Stop",style: TextStyle(
                fontSize: 20,
              ),),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(70.0))))),
    );
  }

  Widget buildBody(ThemeProvider themeProvider) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Alarm',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              title.split(':')[1],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
