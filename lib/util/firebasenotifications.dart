import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wishlist/src/datamodels/push_notification_model.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  Function(PushNotificationModel) _listener;

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        var data = PushNotificationModel.fromJsonNullable(message);
        print(data);
        if (_listener != null) {
          _listener(data);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        var data = PushNotificationModel.fromJsonNullable(message);
        if (_listener != null) {
          print('not null');
           _listener(data);
        } else
          print('not null');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        var data = PushNotificationModel.fromJsonNullable(message);
        if (_listener != null) {
          _listener(data);
        }
      },
    );
  }

  void addListener(Function(PushNotificationModel) listener) {
    _listener = listener;
  }

  Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
