import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/repository/notifications_repo.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final NotificationRepo notificationRepo = NotificationRepo();

  @override
  void initState() {
    notificationRepo.requestNotificationsPermission();
    notificationRepo.forgroundMessage();
    notificationRepo.firebaseInit(context);
    notificationRepo.setupInteractMessage(context);

    if (currentUser == null) {
      Navigator.pushReplacementNamed(
        context,
        RoutesName.loginView,
      );
    } else {
      HomeRepo.getUserData(context);
      HomeRepo.getPosts(context).then((value) {
        Navigator.pushReplacementNamed(
          context,
          RoutesName.homeView,
        );
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}
