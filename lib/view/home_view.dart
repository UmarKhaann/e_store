import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/utils/utils.dart';
import 'package:e_store/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
          leading: const SizedBox(),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  AuthViewModel.signOutUser();
                  Navigator.pushReplacementNamed(context, RoutesName.loginView);
                  Utils.flushBarMessage(
                      context, 'User logged out successfully');
                },
                child: const Text('Log Out')),
            const SizedBox(width: 10,)
          ],
        ),
        body: const Center(
          child: Text("This is home page"),
        ));
  }
}
