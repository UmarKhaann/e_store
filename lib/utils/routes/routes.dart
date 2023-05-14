import 'package:e_store/view/auth/login_view.dart';
import 'package:e_store/view/auth/singup_view.dart';
import 'package:flutter/material.dart';
import 'package:e_store/utils/routes/routes_name.dart';

import '../../view/home_view.dart';

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeView:
        return MaterialPageRoute(builder: (_) => HomeView());

      case RoutesName.loginView:
        return MaterialPageRoute(builder: (_) => LoginView());

      case RoutesName.signUpView:
        return MaterialPageRoute(builder: (_) => SignUpView());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
