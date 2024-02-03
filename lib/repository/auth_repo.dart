import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/provider/image_controller.dart';
import 'package:e_store/repository/notifications_repo.dart';
import 'package:e_store/repository/storage_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class AuthRepo {
  static final ValueNotifier<bool> btnLoading = ValueNotifier<bool>(false);
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final currentUserUid = _auth.currentUser!.uid;
  static NotificationRepo repo = NotificationRepo();

  static signOutUser() {
    _auth.signOut();
  }

  static signUpUser({
    required context,
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    btnLoading.value = true;
    final user = await _fireStore.collection('usernames').doc(username).get();
    if (user.exists) {
      Utils.showTopSnackbar(context, 'Username already taken!');
      btnLoading.value = false;
    } else {
      String profileImage = '';
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final XFile? image =
            Provider.of<ImageController>(context, listen: false).image;
        if (image != null) {
          profileImage = await StorageRepo.uploadItemToFirebaseStorage(
              context, 'images/profile/', image)!;
        }

        final newUser = _fireStore.collection('users').doc(value.user!.uid);
        final List<String> favorites = [];
        _fireStore
            .collection('usernames')
            .doc(username)
            .set({'username': username});
        repo.getDeviceToken().then((deviceToken) {
          newUser.set({
            'profileImage': profileImage.toString(),
            'username': username,
            'fullName': fullName,
            'email': email,
            'phone': phone,
            'password': password,
            'favorites': favorites,
            'fcmToken': deviceToken,
          }).then((value) async {
            await setUserDetails();
            btnLoading.value = false;
            Navigator.pushReplacementNamed(context, RoutesName.homeView);
            Utils.snackBarMessage(context, 'User Signed Up Successfully!');
          });
        });
      }).catchError((error, stackTrace) {
        btnLoading.value = false;
        Utils.showTopSnackbar(context, error.toString());
      });
    }
  }

  static logInUser({context, email, password}) {
    btnLoading.value = true;
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await setUserDetails();

      repo.getDeviceToken().then((deviceToken) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .update({
          'fcmToken': deviceToken,
        });
      });
      btnLoading.value = false;
      Navigator.pushReplacementNamed(context, RoutesName.homeView);
      Utils.snackBarMessage(context, "User Logged In Successfully!");
    }).catchError((error, stackTrace) {
      btnLoading.value = false;
      Utils.showTopSnackbar(context, error.message);
    });
  }

  static updateUserInfo({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    btnLoading.value = true;
    String profileImageUrl = "";

    final XFile? image =
        Provider.of<ImageController>(context, listen: false).image;
    if (image != null) {
      profileImageUrl = await StorageRepo.uploadItemToFirebaseStorage(
          context, 'images/profile/', image)!;
    }

    if (_auth.currentUser!.photoURL != null && profileImageUrl.isNotEmpty) {
      print('i am here');
      //delete image from firebase storage using it's url
    }

    if (profileImageUrl.isEmpty) {
      _fireStore.collection('users').doc(currentUserUid).update({
        'fullName': name,
        'email': email,
        'phone': phone,
        'password': password,
      }).then((value) async {
        await _auth.currentUser!.updateDisplayName(name);
        await _auth.currentUser!.updatePhotoURL(profileImageUrl);
        await _auth.currentUser!.updateEmail(email);
        await _auth.currentUser!.updatePassword(password);
        btnLoading.value = false;
        Utils.snackBarMessage(context, 'Saved changes successfully!');
        return Future<void>;
      });
    } else {
      _fireStore.collection('users').doc(currentUserUid).update({
        'profileImage': profileImageUrl,
        'fullName': name,
        'email': email,
        'phone': phone,
        'password': password,
      }).then((value) async {
        await _auth.currentUser!.updateEmail(email);
        await _auth.currentUser!.updatePassword(password);

        btnLoading.value = false;
        Utils.snackBarMessage(context, 'Saved changes successfully!');
        return Future<void>;
      });
    }
    btnLoading.value = false;
  }

  static setUserDetails() async {
    final currentUser =
        await _fireStore.collection('users').doc(currentUserUid).get();
    _auth.currentUser!.updateDisplayName(currentUser['fullName']);
    _auth.currentUser!.updatePhotoURL(currentUser['profileImage']);
  }

  static removeProfileImage(context) async {
    _auth.currentUser!.updatePhotoURL(null);
    final imageController =
        Provider.of<ImageController>(context, listen: false);
    imageController.resetImage();
    await _fireStore
        .collection('users')
        .doc(currentUserUid)
        .update({'profileImage': ''});
  }
}
