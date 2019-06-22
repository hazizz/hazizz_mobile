import 'package:flutter/material.dart';
import 'package:hazizz_mobile/pages/LoginPage.dart';
import 'package:hazizz_mobile/pages/kreta_login_page.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tab_hoster_page.dart';
import 'package:hazizz_mobile/pages/registration_page.dart';
import 'package:hazizz_mobile/pages/task_maker_page.dart';

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
      //  return MaterialPageRoute(builder: (_) => (title: "homepage"));
         return MaterialPageRoute(builder: (_) => MainTabHosterPage());
      case '/groups':
        return MaterialPageRoute(builder: (_) => MyHomePage(title: "homepage"));
      case '/group/{groupId}':
        return MaterialPageRoute(builder: (_) => MyHomePage(title: "homepage"));
      case '/createTask':
        return MaterialPageRoute(builder: (_) => TaskMakerPage.createMode(groupId: args));
      case '/editTask':
        return MaterialPageRoute(builder: (_) => TaskMakerPage.editMode(taskToEdit: args,));
      case '/kreta/login':
        return MaterialPageRoute(builder: (_) => KretaLoginPage());
      default:
        return _errorRoute();
    }
  }
}

