import 'package:e_store/provider/imageProvider.dart';
import 'package:e_store/provider/themeChangerProvider.dart';
import 'package:e_store/res/components/themes.dart';
import 'package:e_store/shared_preference/dark_theme_data.dart';
import 'package:e_store/utils/routes/routes.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyD6C8laIjaBaoHqpq4DYD72Xi0dtmrllbQ',
        appId: '1:592110491539:web:efdb9b192676e40ccdba66',
        messagingSenderId: '592110491539',
        projectId: 'e-store-4ab54'),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageProviderFromGallery()),
        ChangeNotifierProvider(create: (_) => ThemeChangerProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final provider = Provider.of<ThemeChangerProvider>(context, listen: false);
          DarkThemeData.getThemePreference().then((value) => provider.setIsDarkTheme(value));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: Provider.of<ThemeChangerProvider>(context).isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            title: 'E-Store',
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            initialRoute: currentUser == null
                ? RoutesName.loginView
                : RoutesName.homeView,
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
