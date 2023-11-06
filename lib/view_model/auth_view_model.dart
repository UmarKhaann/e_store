import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class AuthViewModel {
  static final ValueNotifier<bool> logInBtnLoading = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> signUpBtnLoading =
      ValueNotifier<bool>(false);

  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static signOutUser() {
    _auth.signOut();
  }

  static logInUser({context, email, password}) {
    if (email.isEmpty) {
      Utils.snackBarMessage(context, 'Email is empty');
    } else if (password.isEmpty) {
      Utils.snackBarMessage(context, 'Password is empty');
    } else {
      logInBtnLoading.value = true;
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        logInBtnLoading.value = false;
        Navigator.pushReplacementNamed(context, RoutesName.homeView);
        Utils.snackBarMessage(context, "User Logged In Successfully!");
      }).catchError((error, stackTrace) {
        logInBtnLoading.value = false;
        Utils.snackBarMessage(context, error.message);
      });
    }
  }

  static signUpUser(
      {required context,
      required username,
      required fullName,
      required email,
      required phone,
      required password}) async {
    if (username.isEmpty) {
      Utils.snackBarMessage(context, 'Username is empty');
    } else if (fullName.isEmpty) {
      Utils.snackBarMessage(context, 'Full Name is empty');
    } else if (email.isEmpty) {
      Utils.snackBarMessage(context, 'Email is empty');
    } else if (phone.isEmpty) {
      Utils.snackBarMessage(context, 'Phone is empty');
    } else if (password.isEmpty) {
      Utils.snackBarMessage(context, 'Password is empty');
    } else {
      signUpBtnLoading.value = true;
      final user = await _fireStore.collection('usernames').doc(username).get();
      if (user.exists) {
        Utils.snackBarMessage(context, 'Username already taken!');
        signUpBtnLoading.value = false;
      } else {
        _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          signUpBtnLoading.value = false;
          Navigator.pushReplacementNamed(context, RoutesName.homeView);
          final newUser = _fireStore.collection('users').doc(value.user!.uid);
          _fireStore
              .collection('usernames')
              .doc(username)
              .set({'username': username});
          await newUser.set({
            'username': username,
            'fullName': fullName,
            'email': email,
            'phone': phone,
            'password': password,
          }).then((value) =>
              Utils.snackBarMessage(context, 'User Signed Up Successfully!'));
        }).catchError((error, stackTrace) {
          signUpBtnLoading.value = false;
          Utils.snackBarMessage(context, error.message);
        });
      }
    }
  }
}
