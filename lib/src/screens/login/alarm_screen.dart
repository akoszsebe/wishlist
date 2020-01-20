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

  Color barColor1 = Colors.transparent;
  Color barColor2 = Colors.transparent;
  @protected
  @override
  void initState() {
    super.initState();
    _con.init();
    FlutterRingtonePlayer.playAlarm();
  }

  static const platform = const MethodChannel('samples.flutter.dev/battery');
  @protected
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        key: scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Draggable(
          data: 5,
          axis: Axis.horizontal,
          child: buildFab(),
          feedback: buildFab(),
          childWhenDragging: Container(),
          onDragCompleted: () async {
            print("vege");
            FlutterRingtonePlayer.stop();
            try {
              await platform.invokeMethod('finishAndRemoveTask');
            } on PlatformException catch (e) {}
          },
        ),
        body: buildBody(themeProvider));
  }

  bool accepted = false;
  Widget buildBody(ThemeProvider themeProvider) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
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
          SizedBox(height: 200),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 250.0,
                color: barColor1,
                child: DragTarget(
                  builder: (context, List<int> candidateData, rejectedData) {
                    print(candidateData);
                    return Center(
                        child: Text(
                      "<",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ));
                  },
                  onWillAccept: (data) {
                    print("will");
                    setState(() {
                      barColor1 = Colors.red;
                    });
                    return true;
                  },
                  onAccept: (data) {
                    setState(() {
                      barColor1 = Colors.red;
                    });
                  },
                ),
              ),
              Container(
                width: 100.0,
                height: 250.0,
                color: barColor2,
                child: DragTarget(
                  builder: (context, List<int> candidateData, rejectedData) {
                    return Center(
                        child: Text(
                      ">",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ));
                  },
                  onWillAccept: (data) {
                    print("will");
                    setState(() {
                      barColor2 = Colors.red;
                    });
                    return true;
                  },
                  onAccept: (data) {
                    setState(() {
                      barColor2 = Colors.red;
                    });
                  },
                ),
              )
            ],
          )
        ],
      ),
      // ),
    );
  }

  buildFab() {
    return Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: ButtonTheme(
            height: 100,
            minWidth: 100,
            child: RaisedButton(
                child: Text(
                  "Stop",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(70.0)))));
  }
}
