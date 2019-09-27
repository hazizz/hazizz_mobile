import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

class StartPageItem{
  final String name;
  final int index;
  StartPageItem(this.name, this.index);
}

class StartPageService{

  static const String _key = "key_startPage";

  static const int tasksPage = 0;
  static const int schedulePage = 1;
  static const int gradesPage = 2;

  static List<StartPageItem> getStartPages(BuildContext context){
    List<StartPageItem> pages = [StartPageItem(locText(context, key: "tasks"), 0),
      StartPageItem(locText(context, key: "schedule"), 1),
      StartPageItem(locText(context, key: "grades"), 2)
    ];
    return pages;
  }

  static Future<int> getStartPageIndex()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.get(_key);
    if(str != null){
      return int.parse(str);
    }
    return tasksPage;
  }
  static Future<void> setStartPageIndex(int startPage)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, startPage.toString());
  }
}