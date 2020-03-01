import 'package:flutter/services.dart';

const platform = const MethodChannel('samples.flutter.dev/battery');

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
