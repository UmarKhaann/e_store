import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/provider/themeChangerProvider.dart';
import 'package:e_store/shared_preference/dark_theme_data.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_alert_box.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final data =
        _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: FutureBuilder(
              future: data,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final data = snapshot.data!.data();
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data!['fullName']}',
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          FittedBox(child: Text('${_auth.currentUser!.email}')),
                          FittedBox(child: Text('${data['phone']}')),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.home_outlined),
                SizedBox(
                  width: 10,
                ),
                Text('Home'),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, RoutesName.homeView);
            },
          ),
          Consumer<ThemeChangerProvider>(
              builder: (context, themeChangerProvider, child) {
            return SwitchListTile(
                thumbIcon: MaterialStateProperty.all(Icon(
                    themeChangerProvider.isDarkTheme
                        ? Icons.dark_mode
                        : Icons.light_mode)),
                thumbColor: MaterialStateProperty.all(Theme.of(context).canvasColor),
                title: Row(
                  children: [
                    Icon(themeChangerProvider.isDarkTheme
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Dark Mode'),
                  ],
                ),
                value: (themeChangerProvider.isDarkTheme),
                inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveTrackColor: Theme.of(context).canvasColor,
                activeColor: Theme.of(context).iconTheme.color,
                onChanged: (value) {
                  themeChangerProvider.setIsDarkTheme(value);
                  DarkThemeData.setThemePreference(value);
                });
          }),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(
                  width: 10,
                ),
                Text('Log Out'),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context, builder: (_) => CustomAlertBox(
                title: 'Log Out',
                content: 'Are you sure you want to log out?',
                yesOnPressed: () async {
                  Navigator.pushReplacementNamed(context, RoutesName.loginView);
                  await _auth.signOut().then((value) => Utils.flushBarMessage(context, 'Logged Out Successfully'));
                },
                noOnPressed: () {
                  Navigator.pop(context);
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
