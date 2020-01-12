import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';


class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  Function(String,String) _listener;

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        if (_listener != null) {
          _listener(message["data"]["title"],message["data"]["body"]);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        if (_listener != null) {
          print('not null');
          _listener(message["data"]["title"],message["data"]["body"]);
        } else print('not null');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        if (_listener != null) {
          _listener(message["data"]["title"],message["data"]["body"]);
        }
      },
    );
  }

  void addListener(Function(String,String) listener) {
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