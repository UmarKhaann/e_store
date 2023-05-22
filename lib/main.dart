import 'package:e_store/provider/imageProvider.dart';
import 'package:e_store/provider/themeChangerProvider.dart';
import 'package:e_store/res/components/themes.dart';
import 'package:e_store/shared_preference/dark_theme_data.dart';
import 'package:e_store/utils/routes/routes.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
