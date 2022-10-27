import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/main.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/screens/cancel_confirm_order_screen.dart';
import 'package:store_app/screens/home_screen.dart';
import 'package:store_app/screens/landing_screen.dart';
import 'package:store_app/screens/login_screen.dart';
import 'package:store_app/screens/new_product_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LandingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => App());
      case '/new-product':
        return MaterialPageRoute(builder: (_) => NewProductScreen());
      case '/cancel-order':
        return MaterialPageRoute(builder: (_) => CancelConfirmOrderScreen());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
