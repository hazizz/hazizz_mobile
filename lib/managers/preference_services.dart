import 'package:flutter/material.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

class StartPageItem{
  final String name;
  final int index;
  StartPageItem(this.name, this.index);
}

class PreferenceService{


  static const String _key_imageAutoLoad = "_key_imageAutoLoad";
  static const String _key_imageAutoDownload = "_key_imageAutoDownload";

  static const String _key_startPage = "key_startPage";

  static const String _key_gradeRectForm = "_key_gradeRectForm";

  static const String _key_enableAd = "_key_enableAd";


  static const String _key_serverUrl = "_key_serverUrl";

  static const String _key_enable_show_framerate = "_key_enable_show_framerate";

  static const int tasksPage = 0;
  static const int schedulePage = 1;
  static const int gradesPage = 2;
  
  static int startPageIndex = 0;
  static bool gradeRectForm = false;

  static bool imageAutoLoad = true;
  static bool imageAutoDownload = false;

  static bool enabledAd = false;

  static String serverUrl = Constants.BASE_URL;

  static bool enabledShowFramerate = false;



  static Future<void> loadAllPreferences() async {
    serverUrl = await getServerUrl();
    startPageIndex = await getStartPageIndex();
    gradeRectForm = await getGradeRectForm();
    imageAutoLoad = await getImageAutoLoad();
    imageAutoDownload = await getImageAutoDownload();
    enabledAd = await getEnabledAd();
    enabledShowFramerate = await getEnabledShowFramerate();
  }


  static List<StartPageItem> getStartPages(BuildContext context){
    List<StartPageItem> pages = [StartPageItem(locText(context, key: "tasks"), 0),
      StartPageItem(locText(context, key: "schedule"), 1),
      StartPageItem(locText(context, key: "grades"), 2)
    ];
    return pages;
  }

  static Future<int> getStartPageIndex()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.get(_key_startPage);
    if(str != null){
      return int.parse(str);
    }
    return tasksPage;
  }
  static Future<void> setStartPageIndex(int startPage)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key_startPage, startPage.toString());
  }

  static Future<bool> getGradeRectForm()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool yes = prefs.get(_key_gradeRectForm);
    return yes == null ? false : yes;
  }
  static Future<void> setGradeRectForm(bool gradeRectForm)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key_gradeRectForm, gradeRectForm);
  }

  static Future<bool> getImageAutoLoad()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool yes = prefs.get(_key_imageAutoLoad);
    return yes == null ? true : yes;
  }
  static Future<void> setImageAutoLoad(bool autoLoadImages)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key_imageAutoLoad, autoLoadImages);
    imageAutoLoad = autoLoadImages;
  }

  static Future<bool> getEnabledAd()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool y = prefs.get(_key_enableAd);
    enabledAd = y == null ? true : y;
    return enabledAd;
  }
  static Future<void> setEnabledAd(bool enable)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key_enableAd, enable);
    enabledAd = enable;
  }

  static Future<bool> getImageAutoDownload()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool yes = prefs.get(_key_imageAutoDownload);
    return yes == null ? false : yes;
  }
  static Future<void> setImageAutoDownload(bool autoDownloadImages)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key_imageAutoDownload, autoDownloadImages);
    imageAutoDownload = autoDownloadImages;
  }


  static Future<String> getServerUrl()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.get(_key_serverUrl);
    if(str != null){
      serverUrl = str;
      return str;
    }
    serverUrl = Constants.BASE_URL;
    return Constants.BASE_URL;
  }
  static Future<String> setServerUrl(String url)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    serverUrl = url;
    prefs.setString(_key_serverUrl, url);
  }

  static Future<bool> getEnabledShowFramerate()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool enable = prefs.getBool(_key_enable_show_framerate);
    enabledShowFramerate = enable == null ? false : enable;
    return enabledShowFramerate;
  }
  static Future setEnabledShowFramerate(bool enable)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    enabledShowFramerate = enable;
    prefs.setBool(_key_enable_show_framerate, enable);
  }

}