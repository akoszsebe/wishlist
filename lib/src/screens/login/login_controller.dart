import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/datamodels/user_model.dart';
import 'package:wishlist/src/datamodels/alarm_model.dart';
import 'package:wishlist/src/networking/providers/notification_api_provider.dart';
import 'package:wishlist/src/networking/providers/user_api_provider.dart';
import 'package:wishlist/src/repository/session_repository.dart';
import 'package:wishlist/util/shared_prefs.dart';

class LoginController extends ControllerMVC {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  factory LoginController() {
    if (_this == null) _this = LoginController._();
    return _this;
  }
  static LoginController _this;

  LoginController._();

  static LoginController get con => _this;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final NotificationApiProvider notificationApiProvider =
      NotificationApiProvider();
  final UserApiProvider userApiProvider = UserApiProvider();
  bool logedIn;
  UserModel userData;

  void init() async {
    userData = await SharedPrefs.getUserData();
    refresh();
  }

  void checkLogin(VoidCallback callback) async {
    logedIn = await _googleSignIn.isSignedIn();
    if (logedIn == true) {
      callback();
      return;
    }
    refresh();
  }

  void checkIfStartedForAlarm(Function(bool,AlarmModel) callback) async {
    try {
      final String result = await platform.invokeMethod('getIntentParams');
      var alarmResult= AlarmModel.fromJson(jsonDecode(result));
      print(alarmResult.toJson());
      if (alarmResult.alarm == "alarm") {
        turnOnScreen();
        callback(true, alarmResult);
      } else
        callback(false, alarmResult);
    } on PlatformException catch (e) {
      print(e.message);
      callback(false, null);
    }
    refresh();
  }

  void turnOnScreen() async {
    const platform = const MethodChannel('samples.flutter.dev/battery');
    try {
      await platform.invokeMethod('wakeUpScreen');
    } on PlatformException catch (e) { print(e);}
  }

  void login(Function(String) callback) async {
    try {
      //
      await _googleSignIn.signIn();
      var user = UserModel(
          displayName: _googleSignIn.currentUser.displayName,
          photoUrl: _googleSignIn.currentUser.photoUrl,
          userId: _googleSignIn.currentUser.email);
      await SharedPrefs.setUserData(user);
      await registerUser(user);
      callback(null);
    } catch (err) {
      print(err);
      callback(err.message);
    }
  }

  void logout() {
    _googleSignIn.signOut();
    unregisterFromPushNotifications(SessionRepository().getFirebaseDeviceId());
    SessionRepository().clear();
    SharedPrefs.setUserData(null);
  }

  Future<void> unregisterFromPushNotifications(String token) async {
    await notificationApiProvider
        .unregisterFromPushNotification(token)
        .catchError((error) {
      throw error;
    }).then((onValue) => {});
  }

  Future<void> registerUser(UserModel user) async {
    await userApiProvider.registerUser(user).catchError((error) {
      throw error;
    });
  }
}
