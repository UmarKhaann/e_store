import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/provider/image_provider.dart';
import 'package:e_store/repository/storage_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class AuthRepo {
  static final ValueNotifier<bool> logInBtnLoading = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> signUpBtnLoading =
      ValueNotifier<bool>(false);
  static final ValueNotifier<bool> updateBtnLoading =
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
      required String username,
      required String fullName,
      required String email,
      required String phone,
      required String password}) async {
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
          final profileImage = await StorageRepo.uploadItemToFirebaseStorage(
              context, 'images/profile/');
          signUpBtnLoading.value = false;
          final newUser = _fireStore.collection('users').doc(value.user!.uid);
          final List<String> favorites = [];
          _fireStore
              .collection('usernames')
              .doc(username)
              .set({'username': username});
          newUser.set({
            'profileImage': profileImage.toString(),
            'username': username,
            'fullName': fullName,
            'email': email, 
            'phone': phone,
            'password': password,
            'favorites': favorites
          }).then((value) =>
              Navigator.pushReplacementNamed(context, RoutesName.homeView));
              Utils.snackBarMessage(context, 'User Signed Up Successfully!');
        }).catchError((error, stackTrace) {
          signUpBtnLoading.value = false;
          Utils.snackBarMessage(context, error.toString());
        });
      }
    }
  }

  static updateUserInfo(
      {required BuildContext context,
      required String profileImage,
      required String name,
      required String email,
      required String phone,
      required String password}) async {
    updateBtnLoading.value = true;
    final provider =
        Provider.of<ImageProviderFromGallery>(context, listen: false);
    final profileImageUrl = await StorageRepo.uploadItemToFirebaseStorage(
        context, 'images/profile/');
    final uid = _auth.currentUser!.uid;
    await _auth.currentUser!.updateEmail(email);
    await _auth.currentUser!.updatePassword(password);
    _fireStore.collection('users').doc(uid).update({
      'profileImage':
          profileImageUrl!.isEmpty ? provider.image : profileImageUrl,
      'fullName': name,
      'email': email,
      'phone': phone,
      'password': password,
    }).then((value) {
      updateBtnLoading.value = false;
      Utils.snackBarMessage(context, 'Saved changes successfully!');
      return Future<void>;
    });
  }
}
