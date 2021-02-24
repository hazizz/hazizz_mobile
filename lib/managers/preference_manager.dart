import 'package:flutter/material.dart';
import 'package:mobile/enums/schedule_type_enum.dart';
import 'package:mobile/managers/server_url_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

class StartPageItem{
  final String name;
  final int index;
  StartPageItem(this.name, this.index);
}

class PreferenceManager{
  static const String _key_imageAutoLoad = "_key_imageAutoLoad";
  static const String _key_imageAutoDownload = "_key_imageAutoDownload";

  static const String _key_startPage = "key_startPage";

  static const String _key_gradeRectForm = "_key_gradeRectForm";

  static const String _key_enableAd = "_key_enableAd";


  static const String _key_enable_show_framerate = "_key_enable_show_framerate";
  static const String _key_enable_exception_catcher = "_key_enable_exception_catcher";

  static const String _key_schedule_type = "_key_schedule_type";


  static const int tasksPage = 0;
  static const int schedulePage = 1;
  static const int gradesPage = 2;
  
  static int startPageIndex = 0;
  static bool gradeRectForm = false;

  static bool imageAutoLoad = true;
  static bool imageAutoDownload = false;

  static bool enabledAd = false;

  static bool enabledShowFramerate = false;
  static bool enabledExceptionCatcher = false;


  static Future<void> loadAllPreferences() async {
    await ServerUrlManager.load();
    startPageIndex = await getStartPageIndex();
    gradeRectForm = await getGradeRectForm();
    imageAutoLoad = await getImageAutoLoad();
    imageAutoDownload = await getImageAutoDownload();
    enabledAd = await getEnabledAd();
    enabledShowFramerate = await getEnabledShowFramerate();
    enabledExceptionCatcher = await getEnabledExceptionCatcher();
  }

  static List<StartPageItem> getStartPages(BuildContext context){
    List<StartPageItem> pages = [StartPageItem(localize(context, key: "tasks"), 0),
      StartPageItem(localize(context, key: "schedule"), 1),
      StartPageItem(localize(context, key: "grades"), 2)
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

  static Future<bool> getEnabledExceptionCatcher()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool enable = prefs.getBool(_key_enable_exception_catcher);
    enabledExceptionCatcher = enable == null ? false : enable;
    return enabledExceptionCatcher;
  }
  static Future setEnabledExceptionCatcher(bool enable)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    enabledExceptionCatcher = enable;
    prefs.setBool(_key_enable_exception_catcher, enable);
  }

  static Future<ScheduleTypeEnum> getScheduleType()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = prefs.getString(_key_schedule_type);
    if(s == null || s == "kreta"){
      return ScheduleTypeEnum.KRETA;
    }else{
      return ScheduleTypeEnum.CUSTOM;
    }
  }
  static Future setScheduleType(ScheduleTypeEnum scheduleType)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(scheduleType == ScheduleTypeEnum.KRETA){
      prefs.setString(_key_schedule_type, "kreta");
    }else{
      prefs.setString(_key_schedule_type, "custom");
    }

  }
}