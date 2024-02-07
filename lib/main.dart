import 'package:e_store/provider/image_controller.dart';
import 'package:e_store/provider/theme_provider.dart';
import 'package:e_store/provider/voice_duration.dart';
import 'package:e_store/res/components/theme.dart';
import 'package:e_store/shared_preference/dark_theme_data.dart';
import 'package:e_store/utils/routes/routes.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyD6C8laIjaBaoHqpq4DYD72Xi0dtmrllbQ',
        appId: '1:592110491539:web:efdb9b192676e40ccdba66',
        messagingSenderId: '592110491539',
        projectId: 'e-store-4ab54'),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyD6C8laIjaBaoHqpq4DYD72Xi0dtmrllbQ',
        appId: '1:592110491539:web:efdb9b192676e40ccdba66',
        messagingSenderId: '592110491539',
        projectId: 'e-store-4ab54'),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => VoiceDurationProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewModel())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Builder(
            builder: (BuildContext context) {
              DarkThemeData.getThemePreference()
                  .then((value) => themeProvider.setIsDarkTheme(value));
              return GestureDetector(
                onTap: FocusManager.instance.primaryFocus?.unfocus,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeProvider.isDarkTheme
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  title: 'E-Store',
                  theme: CustomTheme.lightTheme,
                  darkTheme: CustomTheme.darkTheme,
                  initialRoute: RoutesName.splashView,
                  onGenerateRoute: Routes.generateRoute,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
