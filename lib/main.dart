import 'package:device_apps/device_apps.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/app.dart';
import 'package:wishlist/util/shared_prefs.dart';
import 'package:wishlist/util/theme_provider.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  SharedPrefs.getTheme().then((onValue) {
    runApp(EasyLocalization(
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(isLightTheme: onValue),
        child: MVCApp(),
      ),
    ));
  });
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print("Native called background task: $task"); //simpleTask will be emitted here.
    FlutterRingtonePlayer.playRingtone(looping: false, volume: 0.1, asAlarm: true);
    //await Future.delayed(Duration(seconds: 5));
    //FlutterRingtonePlayer.stop();
    print("Native after background task: $task");
    //DeviceApps.openApp('com.example.wishlist/com.example.wishlist.MainActivity');
    return Future.value(true);
  });
}
