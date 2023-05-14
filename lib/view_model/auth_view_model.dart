import 'package:flutter/material.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      Utils.flushBarMessage(context, 'Email is empty');
    } else if (password.isEmpty) {
      Utils.flushBarMessage(context, 'Password is empty');
    } else {
      logInBtnLoading.value = true;
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
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

  static signUpUser(
      {required context,
      required username,
      required fullName,
      required email,
      required phone,
      required password}) async {

    if (username.isEmpty) {
      Utils.flushBarMessage(context, 'Username is empty');
    } else if (fullName.isEmpty) {
      Utils.flushBarMessage(context, 'Full Name is empty');
    } else if (email.isEmpty) {
      Utils.flushBarMessage(context, 'Email is empty');
    } else if (phone.isEmpty) {
      Utils.flushBarMessage(context, 'Phone is empty');
    } else if (password.isEmpty) {
      Utils.flushBarMessage(context, 'Password is empty');
    }
    else {
      signUpBtnLoading.value = true;
      final user = await _fireStore.collection('usernames').doc(username).get();
      if (user.exists) {
        Utils.flushBarMessage(context, 'Username already exists');
        signUpBtnLoading.value = false;
      } else {
        _auth.createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          signUpBtnLoading.value = false;
          Navigator.pushReplacementNamed(context, RoutesName.homeView);
          final newUser = _fireStore.collection('users').doc(value.user!.uid);
          _fireStore.collection('usernames').doc(value.user!.uid).set({'username': username});
          await newUser.set({
            'username': username,
            'fullName': fullName,
            'email': email,
            'phone': phone,
            'password': password,
          }).then((value) => Utils.flushBarMessage(context, 'User Signed Up Successfully!'));
        }).catchError((error, stackTrace) {
          signUpBtnLoading.value = false;
          Utils.flushBarMessage(context, error.message);
        });
      }
    }
  }
}
