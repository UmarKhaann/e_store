
import 'package:flutter/material.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final ValueNotifier<bool> logInBtnLoading = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> signUpBtnLoading = ValueNotifier<bool>(false);

  static signOutUser(){
    _auth.signOut();
  }

  static logInUser({context, email, password}) {
    if (email.isEmpty) {
      Utils.flushBarMessage(context, 'Email is empty');
    } else if (password.isEmpty) {
      Utils.flushBarMessage(context, 'Password is empty');
    } else {
      logInBtnLoading.value = true;
      _auth
          .signInWithEmailAndPassword(
          email: email, password: password)
          .then((value) {
        logInBtnLoading.value = false;
        Navigator.pushReplacementNamed(context, RoutesName.homeView);
        Utils.flushBarMessage(context, "User Logged In Successfully!");
      }).catchError((error, stackTrace) {
        logInBtnLoading.value = false;
        Utils.flushBarMessage(context, error.message);
      });
    }
  }

  static signUpUser({context, email, password, username}) {
    if (email.isEmpty) {
      Utils.flushBarMessage(context, 'Username is empty');
    } else if (password.isEmpty) {
      Utils.flushBarMessage(context, 'Email is empty');
    } else if (username.isEmpty) {
      Utils.flushBarMessage(context, 'Password is empty');
    } else {
      signUpBtnLoading.value = true;
      _auth
          .createUserWithEmailAndPassword(
          email: email, password: password)
          .then((value) {
        signUpBtnLoading.value = false;
        Navigator.pushReplacementNamed(context, RoutesName.homeView);
        Utils.flushBarMessage(context, 'User Signed Up Successfully!');
      }).catchError((error, stackTrace) {
        signUpBtnLoading.value = false;
        Utils.flushBarMessage(context, error.message);
      });
    }
  }
}