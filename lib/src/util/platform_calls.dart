import 'package:flutter/services.dart';

const platform = const MethodChannel('samples.flutter.dev/alarm');

Future<void> scheduleAlarm(
    DateTime scheduledNotificationDateTime, int id, String title) async {
  try {
    await platform.invokeMethod('setAlarm', <String, dynamic>{
      'time': scheduledNotificationDateTime.millisecondsSinceEpoch,
      'id': id,
      'title': title,
    });
  } on PlatformException catch (e) {
    print(e);
  }
}

Future<void> cancelAlarm(int id) async {
  try {
    await platform.invokeMethod('cancelAlarm', <String, dynamic>{'id': id});
  } on PlatformException catch (e) {
    print(e);
  }
}

Future<void> checkDrawOwerOtherAppsPermisison() async {
  try {
    await platform.invokeMethod('checkDrawOwerOtherAppsPermisison');
  } on PlatformException catch (e) {
    print(e);
  }
}

Future<void> exitApp() async {
  try {
    await platform.invokeMethod('finishAndRemoveTask');
  } on PlatformException catch (e) {
    print(e);
  }
}

Future<void> turnOnScreen() async {
  try {
    await platform.invokeMethod('wakeUpScreen');
  } on PlatformException catch (e) {
    print(e);
  }
}

Future<String> getIntentParams() async {
  try {
    return await platform.invokeMethod('getIntentParams');
  } on PlatformException catch (e) {
    print(e);
    return null;
  }
}
