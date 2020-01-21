import 'package:flutter/services.dart';

const platform = const MethodChannel('samples.flutter.dev/battery');

Future<void> scheduleNotification(
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
