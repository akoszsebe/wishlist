import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/datamodels/user_model.dart';
import 'package:wishlist/util/shared_prefs.dart';

class LoginController extends ControllerMVC {
  factory LoginController() {
    if (_this == null) _this = LoginController._();
    return _this;
  }
  static LoginController _this;

  LoginController._();

  static LoginController get con => _this;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
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

  void login(Function(String) callback) async {
    try {
      //
      await _googleSignIn.signIn();
      await SharedPrefs.setUserData(UserModel(
          displayName: _googleSignIn.currentUser.displayName,
          photoUrl: _googleSignIn.currentUser.photoUrl,
          email: _googleSignIn.currentUser.email));
      callback(null);
    } catch (err) {
      print(err);
      callback(err.message);
    }
  }

  void logout() {
    _googleSignIn.signOut();
     SharedPrefs.setUserData(null);
  }
}
