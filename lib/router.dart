import 'package:flutter/material.dart';
import 'package:malnudetect/screens/login_screen.dart';
import 'package:malnudetect/screens/signup_screen.dart';

Route<dynamic> genarateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());

    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("This route does not exist"),
          ),
        ),
      );
  }
}
