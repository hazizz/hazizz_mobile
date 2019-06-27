import 'package:flutter/material.dart';
import 'package:hazizz_mobile/pages/LoginPage.dart';
import 'package:hazizz_mobile/pages/group_pages/group_tab_hoster_page.dart';
import 'package:hazizz_mobile/pages/kreta_login_page.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tab_hoster_page.dart';
import 'package:hazizz_mobile/pages/my_groups_page.dart';
import 'package:hazizz_mobile/pages/registration_page.dart';
import 'package:hazizz_mobile/pages/task_maker_page.dart';

import 'main.dart';

class RouteGenerator{
  static Route<dynamic> _errorRoute(String errorLog) {
    print(errorLog);
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(errorLog),
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
        return MaterialPageRoute(builder: (_) => MyGroupsPage());
      case '/group/groupId':
                //      Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));

        return MaterialPageRoute(builder: (_) => GroupTabHosterPage(group: args));
      case '/createTask':
        return MaterialPageRoute(builder: (_) => TaskMakerPage.createMode(groupId: args));
      case '/editTask':
        return MaterialPageRoute(builder: (_) => TaskMakerPage.editMode(taskToEdit: args,));
      case '/kreta/login':
        return MaterialPageRoute(builder: (_) => KretaLoginPage());
      default:
        String errorLog = "log: route: ${settings.name}, args: ${settings.arguments}";
        return _errorRoute(errorLog);
    }
  }
}

