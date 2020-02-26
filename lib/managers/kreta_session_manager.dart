
import 'dart:convert';


import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/storage/cache_manager.dart';

class KretaSessionManager {

  static const String _keySession = "key_session";
  static const String _keySessions = "key_sessions";

  static const String _key_rememberPassword= "key_remember_session_password";

  static PojoSession selectedSession;

  SharedPreferences prefs;

  static Future<bool> hasSelectedSession() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String session = prefs.getString(_keySession);
    return !(session == null || session == "");
  }

  static Future<bool> isRememberPassword() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool a = prefs.getBool(_key_rememberPassword);
    return a == null ?  true : a;
  }

  static Future<void> setRememberPassword(bool a) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key_rememberPassword, a);
  }

  static Future<void> loadSelectedSession() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedSession = prefs.getString(_keySession);
    if(encodedSession != null) {
      Map jsonSession = json.decode(encodedSession);
      if(jsonSession != null) {
        selectedSession = PojoSession.fromJson(jsonSession);
      }
      return null;
    }
    return null;
  }


  static Future<PojoSession> getSelectedSession() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedSession = prefs.getString(_keySession);
    HazizzLogger.printLog("cached session1 is not null: ${encodedSession != null}");
    if(encodedSession != null) {
      Map jsonSession = json.decode(encodedSession);
      HazizzLogger.printLog("cached session2 is not null: ${jsonSession != null}");

      if(jsonSession != null) {

        PojoSession s = PojoSession.fromJson(jsonSession);
        HazizzLogger.printLog("cached session3 status, id: ${s.status}, ${s.id}");

        return s;
      }
      return null;
    }
    return null;
  }

  static Future<void> setSelectedSession(PojoSession session) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map jsonSession = session.toJson();
    bool success = await prefs.setString(_keySession, jsonEncode(jsonSession));
    if(success){
      selectedSession = session;
    }
  }

  static Future<List<PojoSession>> getSessions() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedSessions = prefs.getString(_keySessions);
    if(encodedSessions == null) return null;
    Iterable iter = json.decode(encodedSessions);
    if(iter == null) return null;
    List<PojoSession> sessions = iter.map<PojoSession>((json) => PojoSession.fromJson(json)).toList();

    return sessions;
  }

  static Future<void> setSessions(List<PojoSession> sessions) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map> jsonSessions = sessions.map((e) => e == null ? null : e.toJson())?.toList();
    await prefs.setString(_keySessions, jsonEncode(jsonSessions));
  }
}