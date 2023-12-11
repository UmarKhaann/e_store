import 'package:e_store/provider/theme_provider.dart';
import 'package:e_store/res/components/custom_alert_dialog.dart';
import 'package:e_store/shared_preference/dark_theme_data.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/utils/utils.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  SettingsTab({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.profileView);
            },
            leading: const Icon(Icons.person),
            title: const Text('Account'),
          ),
          Consumer<ThemeProvider>(
              builder: (context, themeChangerProvider, child) {
            return SwitchListTile(
                thumbIcon: MaterialStateProperty.all(Icon(
                  themeChangerProvider.isDarkTheme
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.black,
                )),
                thumbColor: MaterialStateProperty.all(Colors.white),
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
            leading: const Icon(Icons.info_outline),
            title: const Text('Log Out'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => CustomAlertDialog(
                    onPressed: () async {
                          await _auth.signOut().then((value) {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RoutesName.loginView, (route) => false);

                            Utils.snackBarMessage(
                                context, 'Logged Out Successfully');
                            final homeViewModel = Provider.of<HomeViewModel>(
                                context,
                                listen: false);
                            homeViewModel.setCurrentIndex(0);
                          });
                        },
                  buttonTitle: 'Yes',
                  ));
            },
          ),
        ],
      ),
    );
  }
}
