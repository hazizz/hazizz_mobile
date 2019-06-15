import 'package:flutter/material.dart';
import 'package:hazizz_mobile/pages/LoginPage.dart';
import 'package:hazizz_mobile/pages/registration_page.dart';

import 'main.dart';

class RouteGenerator{
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

  static Route generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'registration':
        return MaterialPageRoute(builder: (_) => RegistrationPage());
      case 'intro':
        return MaterialPageRoute(builder: (_) => RegistrationPage());
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage(title: "homepage"));
      case '/groups':
        return MaterialPageRoute(builder: (_) => MyHomePage(title: "homepage"));
      case '/group/{groupId}':
        return MaterialPageRoute(builder: (_) => MyHomePage(title: "homepage"));
      case '/editTask':
        return MaterialPageRoute(builder: (_) => MyHomePage(title: "homepage"));
      default:
        return _errorRoute();
    }
  }
}

