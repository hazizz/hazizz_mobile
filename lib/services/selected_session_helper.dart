

import 'package:dio/dio.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';

bool doesContainSelectedSession(List<PojoSession> sessions){
  if(sessions == null || sessions.isEmpty) return false;
  for(PojoSession s in sessions){
    if(SelectedSessionBloc().selectedSession.id == s.id){
      return true;
    }
  }
  return false;
}

List<PojoSession> getFailedSessionsFromHeader(Headers headers){
  List<PojoSession> failedSessions = [];

  headers.forEach((String key, List valueList){

    if(key == "failed-sessions"){
      if(valueList != null && valueList.isNotEmpty){
        for(String s in valueList){
          print("failed session2: ${s}");

          List<String> splited = s.split("_");
          PojoSession se = PojoSession(
              int.parse(splited[1]), null, splited[2], null, null, null
          );
          failedSessions.add(se);
        }
      }
    }
    if(key == "inactive-sessions"){
      if(valueList != null && valueList.isNotEmpty){
        for(String s in valueList){
          List<String> splited = s.split("_");
          PojoSession se = PojoSession(
              int.parse(splited[1]), null, splited[2], null, null, null
          );
          failedSessions.add(se);
        }
      }
    }
  });

  failedSessions.forEach((PojoSession s){
    print("failed session: ${s.username}");
  });

  return failedSessions;
}