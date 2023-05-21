import 'package:e_store/provider/themeChangerProvider.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_alert_box.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'E-Store',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, RoutesName.homeView);
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              showDialog(
                  context: context, builder: (_) => const CustomAlertBox());
            },
          ),
          Consumer<ThemeChangerProvider>(
            builder: (context, themeChangerProvider, child){
              return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: (themeChangerProvider.isDarkTheme),
                  inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                  inactiveTrackColor: Theme.of(context).canvasColor,
                  activeColor: Theme.of(context).iconTheme.color,
                  onChanged: (value){
                    themeChangerProvider.setIsDarkTheme(!themeChangerProvider.isDarkTheme);
                    themeChangerProvider.setThemeMode(themeChangerProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light);
                  });
    }
          ),
        ],
      ),
    );
  }
}
