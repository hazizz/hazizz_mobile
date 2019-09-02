import 'dart:convert';

import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/converters/PojoConverter.dart';
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
  sh.setString(key, jsonEncode(data));
  sh.setString(key + "_time", DateTime.now().toString());
}

Future<DataCache> _load(String key) async {
  var sh = await SharedPreferences.getInstance();
  String str_data = sh.getString(key);
  String str_date = sh.getString(key + "_time");
  print("piskota11: $str_data");
  print("piskota12: $str_date");
  if(str_data != null && str_date != null){

    var json = jsonDecode(str_data);
    print("piskota20: $json");
    DateTime date = DateTime.parse(str_date);
    print("piskota21: $json");
    print("piskota22: $date");
    if(json != null && date != null){
      DataCache dataCache = DataCache(lastUpdated: date, json: json);
      print("piskota31: ${dataCache.data}");
      print("piskota32: ${dataCache.lastUpdated}");
      return dataCache;
    }
  }
  return null;
}


Future<DataCache> _loadList(String key) async {
  var sh = await SharedPreferences.getInstance();
  String str_data = sh.getString(key);
  String str_date = sh.getString(key + "_time");
  print("piskota11: $str_data");
  print("piskota12: $str_date");
  if(str_data != null && str_date != null){

  //  var json = jsonDecode(str_data);
    print("piskota20: $json");
    DateTime date = DateTime.parse(str_date);

    Iterable iter = json.decode(json.encode(json.decode(str_data)));
    print("didit");
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    print(myTasks);

    print("piskota21: $iter");
    print("piskota22: $date");
    if(iter != null && date != null){
      DataCache dataCache = DataCache.fromList(lastUpdated: date, iter: iter);
      print("piskota31: ${dataCache.data}");
      print("piskota32: ${dataCache.lastUpdated}");
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





void saveScheduleCache(PojoSchedules schedule){
 // List<String> asd = tasks[0].tags.map((e) => e == null ? null : e.name)?.toList();
  _save("scheduleCache", schedule.toJson());// tasks.map((e) => e == null ? null : e.toJson())?.toList());
}

Future<DataCache> loadScheduleCache() async {
  DataCache dataCache = await _load("scheduleCache");

  if(dataCache != null) {
    dataCache.setData(PojoSchedules.fromJson(dataCache.json));
  }
  return dataCache;
}


void saveGradesCache(PojoGrades grades){
  // List<String> asd = tasks[0].tags.map((e) => e == null ? null : e.name)?.toList();
  _save("gradesCache", grades.toJson());// tasks.map((e) => e == null ? null : e.toJson())?.toList());
}

Future<DataCache> loadGradesCache() async {
  DataCache dataCache = await _load("gradesCache");

  if(dataCache != null) {
    dataCache.setData(PojoGrades.fromJson(dataCache.json));
  }
  return dataCache;
}
