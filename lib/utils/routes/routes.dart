import 'package:e_store/view/auth/login_view.dart';
import 'package:e_store/view/auth/singup_view.dart';
import 'package:e_store/view/chat/conversations_view.dart';
import 'package:e_store/view/product/product_details_view.dart';
import 'package:e_store/view/product/product_selling_form_view.dart';
import 'package:e_store/view/product/request_product_form_view.dart';
import 'package:flutter/material.dart';
import 'package:e_store/utils/routes/routes_name.dart';

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

      case RoutesName.productSellingFormView:
        return MaterialPageRoute(builder: (_) => ProductSellingFormView());

      case RoutesName.requestProductFormView:
        return MaterialPageRoute(builder: (_) => RequestProductFormView());

      case RoutesName.productDetailView:
        return MaterialPageRoute(
            builder: (_) => ProductDetailsView(docs: settings.arguments));

      case RoutesName.conversationsView:
        return MaterialPageRoute(builder: (_) => ConversationsView());

      case RoutesName.chatView:
        return MaterialPageRoute(builder: (_) => ChatView(productDocs: settings.arguments));

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
