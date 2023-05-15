import 'package:e_store/provider/imageProvider.dart';
import 'package:e_store/res/components/themes.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        title: 'E-Store',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        initialRoute:
        currentUser == null ? RoutesName.loginView : RoutesName.homeView,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
