import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  Color ripleColor = Colors.red;
  Color ripleColorGreen = Colors.green;
  @protected
  @override
  void initState() {
    super.initState();
    _con.init();
    //FlutterRingtonePlayer.playAlarm();
  }

  static const platform = const MethodChannel('samples.flutter.dev/battery');
  @protected
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        key: scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            Stack(alignment: Alignment.bottomCenter, children: <Widget>[
          Container(
            height: 210,
            child: SpinKitRipple(
              color: ripleColor,
              size: 210,
            ),
          ),
          Draggable(
            data: 5,
            child: buildFab(),
            feedback: buildFab(),
            childWhenDragging: Container(),
            onDragCompleted: () async {
              if (ripleColor == ripleColorGreen) {
                FlutterRingtonePlayer.stop();
                try {
                  print("exit"); 
                  await platform.invokeMethod('finishAndRemoveTask');
                } on PlatformException catch (e) {
                  print(e);
                }
              }
              setState(() {
                ripleColor = Colors.red;
              });
            },
          ),
        ]),
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
          SizedBox(height: 60),
          Container(
            height: 90.0,
            child: DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                print(candidateData);
                return Center(child: Icon(Icons.keyboard_arrow_up));
              },
              onWillAccept: (data) {
                print("will");
                setState(() {
                  ripleColor = ripleColorGreen;
                });
                return true;
              },
              onAccept: (data) {
                setState(() {
                  ripleColor = ripleColorGreen;
                });
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 230.0,
                child: DragTarget(
                  builder: (context, List<int> candidateData, rejectedData) {
                    print(candidateData);
                    return Center(child: Icon(Icons.keyboard_arrow_left));
                  },
                  onWillAccept: (data) {
                    print("will");
                    setState(() {
                      ripleColor = ripleColorGreen;
                    });
                    return true;
                  },
                  onAccept: (data) {
                    setState(() {
                      ripleColor = ripleColorGreen;
                    });
                  },
                ),
              ),
              Container(
                width: 100.0,
                height: 230.0,
                child: DragTarget(
                  builder: (context, List<int> candidateData, rejectedData) {
                    return Center(child: Icon(Icons.keyboard_arrow_right));
                  },
                  onWillAccept: (data) {
                    print("will");
                    setState(() {
                      ripleColor = ripleColorGreen;
                    });
                    return true;
                  },
                  onAccept: (data) {
                    setState(() {
                      ripleColor = ripleColorGreen;
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
    return Container(
        height: 210,
        width: 210,
        child: Center(
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
                        borderRadius: new BorderRadius.circular(70.0))))));
  }
}
