import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view/account.dart';
import 'package:e_store/view/auth/login_view.dart';
import 'package:e_store/view/auth/singup_view.dart';
import 'package:e_store/view/favorites_view.dart';
import 'package:e_store/view/notification_view.dart';
import 'package:e_store/view/product/product_details_view.dart';
import 'package:e_store/view/splash.dart';
import 'package:flutter/material.dart';

import '../../view/chat/chat_view.dart';
import '../../view/home/home_view.dart';

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeView:
        return MaterialPageRoute(builder: (_) => HomeView());

      case RoutesName.loginView:
        return MaterialPageRoute(builder: (_) => LoginView());

      case RoutesName.signUpView:
        return MaterialPageRoute(builder: (_) => SignUpView());

      case RoutesName.productDetailView:
        return MaterialPageRoute(
            builder: (_) => ProductDetailsView(docs: settings.arguments));

      case RoutesName.chatView:
        return MaterialPageRoute(builder: (_) => ChatView(productDocs: settings.arguments));
      case RoutesName.favoritesView:
        return MaterialPageRoute(builder: (_) => FavoritesView());
      case RoutesName.profileView:
        return MaterialPageRoute(builder: (_) => AccountView());
      case RoutesName.splashView:
        return MaterialPageRoute(builder: (_) => SplashView());
      case RoutesName.notificationView:
        return MaterialPageRoute(builder: (_) => NotificationView());

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
