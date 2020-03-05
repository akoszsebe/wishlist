import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'package:wishlist/src/util/platform_calls.dart' as PlatformCalls;

class AlarmController extends ControllerMVC {
  factory AlarmController() {
    if (_this == null) _this = AlarmController._();
    return _this;
  }
  static AlarmController _this;

  AlarmController._();

  static AlarmController get con => _this;
  DateTime now;

  void init() async {
    HardwareButtons.homeButtonEvents.listen((event) {
      FlutterRingtonePlayer.stop();
    });
    playAlarm();
    now = new DateTime.now();
    refresh();
  }

  void playAlarm() {
    FlutterRingtonePlayer.playAlarm();
  }

  Future<bool> willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      playAlarm();
    }
  }

  void scheduleAlarm(id, title) {
    var snoozeDate = DateTime.now();
    snoozeDate = DateTime(snoozeDate.year, snoozeDate.month, snoozeDate.day,
            snoozeDate.hour, snoozeDate.minute)
        .add(Duration(minutes: 5));
    PlatformCalls.scheduleAlarm(snoozeDate, id, title);
    exitApp();
  }

  void exitApp() {
    FlutterRingtonePlayer.stop();
    PlatformCalls.exitApp();
  }
}
