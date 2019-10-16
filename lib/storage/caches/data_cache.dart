import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCache{

  DateTime lastUpdated;
  var json;

  dynamic data;

  Iterable iter;

  DataCache({ this.lastUpdated, this.json});

  DataCache.fromList({ this.lastUpdated, this.iter});

  setDataList(dynamic data){
    this.data = data;
  }

  setData(dynamic data){
    this.data = data;
  }
}

Future _save(String key, dynamic data) async {
  var sh = await SharedPreferences.getInstance();
  bool a = await sh.setString(key, jsonEncode(data));
  bool s = await sh.setString(key + "_time", DateTime.now().toString());
  HazizzLogger.printLog("cache save was successful: ${a && s}");
}

Future<DataCache> _load(String key) async {
  var sh = await SharedPreferences.getInstance();
  String str_data = sh.getString(key);
  String str_date = sh.getString(key + "_time");
  HazizzLogger.printLog("piskota11: $str_data");
  HazizzLogger.printLog("piskota12: $str_date");
  if(str_data != null && str_date != null){

    var json = jsonDecode(str_data);
    HazizzLogger.printLog("piskota20: $json");
    DateTime date = DateTime.parse(str_date);
    HazizzLogger.printLog("piskota21: $json");
    HazizzLogger.printLog("piskota22: $date");
    if(json != null && date != null){
      DataCache dataCache = DataCache(lastUpdated: date, json: json);
      HazizzLogger.printLog("piskota31: ${dataCache.data}");
      HazizzLogger.printLog("piskota32: ${dataCache.lastUpdated}");
      return dataCache;
    }
  }
  return null;
}


Future<DataCache> _loadList(String key) async {
  var sh = await SharedPreferences.getInstance();
  String str_data = sh.getString(key);
  String str_date = sh.getString(key + "_time");
  HazizzLogger.printLog("piskota11: $str_data");
  HazizzLogger.printLog("piskota12: $str_date");
  if(str_data != null && str_date != null){

  //  var json = jsonDecode(str_data);
    HazizzLogger.printLog("piskota20: $json");
    DateTime date = DateTime.parse(str_date);

    Iterable iter = json.decode(json.encode(json.decode(str_data)));
    HazizzLogger.printLog("didit");
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    HazizzLogger.printLog(myTasks.toString());

    HazizzLogger.printLog("piskota21: $iter");
    HazizzLogger.printLog("piskota22: $date");
    if(iter != null && date != null){
      DataCache dataCache = DataCache.fromList(lastUpdated: date, iter: iter);
      HazizzLogger.printLog("piskota31: ${dataCache.data}");
      HazizzLogger.printLog("piskota32: ${dataCache.lastUpdated}");
      return dataCache;
    }
  }
  return null;
}


void saveTasksCache(List<PojoTask> tasks){
  _save("tasksCache", tasks.map((e) => e == null ? null : e.toJson())?.toList());
}

Future<DataCache> loadTasksCache() async {
  DataCache dataCache = await _loadList("tasksCache");

  if(dataCache != null) {
    dataCache.setDataList(
        dataCache.iter.map<PojoTask>((json) => PojoTask.fromJson(json))
            .toList());
  }
  return dataCache;
}

void saveScheduleCache(PojoSchedules schedule, {@required int year, @required int weekNumber}){
 // List<String> asd = tasks[0].tags.map((e) => e == null ? null : e.name)?.toList();
  _save("${year}_${weekNumber}_scheduleCache", schedule.toJson());// tasks.map((e) => e == null ? null : e.toJson())?.toList());
}

Future<DataCache> loadScheduleCache({@required int year, @required int weekNumber}) async {
  DataCache dataCache = await _load("${year}_${weekNumber}_scheduleCache");

  if(dataCache != null) {
    dataCache.setData(PojoSchedules.fromJson(dataCache.json));
  }
  return dataCache;
}


void saveGradesCache(PojoGrades grades){
  _save("gradesCache", grades.toJson());
}

Future<DataCache> loadGradesCache() async {
  DataCache dataCache = await _load("gradesCache");

  if(dataCache != null) {
    dataCache.setData(PojoGrades.fromJson(dataCache.json));
  }
  return dataCache;
}

Future forgetScheduleCache() async {
  var sh = await SharedPreferences.getInstance();
  bool a = await sh.remove("scheduleCache");
  bool s = await sh.remove("scheduleCache" + "_time");
}

Future forgetGradesCache() async {
  var sh = await SharedPreferences.getInstance();
  bool a = await sh.remove("gradesCache");
  bool s = await sh.remove("gradesCache" + "_time");
}

Future forgetTasksCache() async {
  var sh = await SharedPreferences.getInstance();
  bool a = await sh.remove("tasksCache");
  bool s = await sh.remove("tasksCache" + "_time");
}