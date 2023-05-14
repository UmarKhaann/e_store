import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/utils/utils.dart';
import 'package:e_store/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final userData =
        fireStore.collection('users').doc(_auth.currentUser!.uid).get();
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
            child: FutureBuilder(
                future: userData,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  return !snapshot.data!.exists
                      ? const CircularProgressIndicator(color: Colors.black,)
                      : FittedBox(child: Text(snapshot.data!['fullName']));
                })),

        actions: [
          TextButton(
              onPressed: () {
                AuthViewModel.signOutUser();
                Navigator.pushReplacementNamed(context, RoutesName.loginView);
                Utils.flushBarMessage(context, 'User logged out successfully');
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.black),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          const Expanded(
              child: Center(
            child: Text('Home Screen'),
          )),
          Hero(
            tag: 'btn',
            child: CustomButton(
                text: "Sell",
                onPressed: () {
                  Navigator.pushNamed(
                      context, RoutesName.productSellingFormView);
                }),
          ),
          const Divider()
        ],
      ),
    );
  }
}
