import 'dart:convert';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_cache.dart';

class CacheManager{
  static Future save(String key, dynamic data) async {
    var sh = await SharedPreferences.getInstance();
    bool a = await sh.setString(key, jsonEncode(data));
    bool s = await sh.setString(key + "_time", DateTime.now().toString());
    HazizzLogger.printLog("cache save was successful: ${a && s}");
  }

  static Future<CacheData> load(String key) async {
    var sh = await SharedPreferences.getInstance();
    String strData = sh.getString(key);
    String strDate = sh.getString(key + "_time");
    HazizzLogger.printLog("piskota11: $strData");
    HazizzLogger.printLog("piskota12: $strDate");
    if(strData != null && strDate != null){

      var json = jsonDecode(strData);
      HazizzLogger.printLog("piskota20: $json");
      DateTime date = DateTime.parse(strDate);
      HazizzLogger.printLog("piskota21: $json");
      HazizzLogger.printLog("piskota22: $date");
      if(json != null && date != null){
        CacheData dataCache = CacheData(lastUpdated: date, json: json);
        HazizzLogger.printLog("piskota31: ${dataCache.data}");
        HazizzLogger.printLog("piskota32: ${dataCache.lastUpdated}");
        return dataCache;
      }
    }
    return null;
  }

  static Future<CacheData> loadList(String key) async {
    var sh = await SharedPreferences.getInstance();
    String strData = sh.getString(key);
    String strDate = sh.getString(key + "_time");
    HazizzLogger.printLog("piskota11: $strData");
    HazizzLogger.printLog("piskota12: $strDate");
    if(strData != null && strDate != null){

      //  var json = jsonDecode(strData);
      HazizzLogger.printLog("piskota20: $json");
      DateTime date = DateTime.parse(strDate);

      final Iterable iter = json.decode(json.encode(json.decode(strData)));
      HazizzLogger.printLog("didit");
      List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
      HazizzLogger.printLog(myTasks.toString());

      HazizzLogger.printLog("piskota21: $iter");
      HazizzLogger.printLog("piskota22: $date");
      if(iter != null && date != null){
        CacheData dataCache = CacheData.fromList(lastUpdated: date, iter: iter);
        HazizzLogger.printLog("piskota31: ${dataCache.data}");
        HazizzLogger.printLog("piskota32: ${dataCache.lastUpdated}");
        return dataCache;
      }
    }
    return null;
  }

  static Future forgetCache(String key) async {
    var sh = await SharedPreferences.getInstance();
    await sh.remove(key);
    await sh.remove(key + "_time");
  }
}
