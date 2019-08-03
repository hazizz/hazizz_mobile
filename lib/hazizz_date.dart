import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';



String hazizzShowDateFormat(DateTime dateTime){
  return DateFormat("yyyy.MM.dd").format(dateTime);
}

String hazizzShowDateAndTimeFormat(DateTime dateTime){
  return DateFormat("yyyy.MM.dd HH:mm").format(dateTime.add(DateTime.now().timeZoneOffset));
}


String hazizzRequestDateFormat(DateTime dateTime){
  return DateFormat("yyyy-MM-dd").format(dateTime);
}

String hazizzTimeOfDayToShow(TimeOfDay timeOfDay){
  if(timeOfDay != null) {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }
  return "ERROR FORMATING";
}

DateTime timeOfDayToDateTime(TimeOfDay timeOfDay){
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
}




Duration hazizzParseDuration(String hhmmss){
  List<String> timeList = hhmmss.split(":");
  List<int> timeListFinal = List();
  for(String time in timeList){
    String t = time.replaceFirst(RegExp('0'), "");
    int a = int.parse(t);
    timeListFinal.add(a);
  }
  Duration duration = Duration(hours: timeListFinal[0],microseconds: timeListFinal[1],seconds: timeListFinal[2]);
  return duration;
}


bool hazizzIsAfterHHMMSS({@required DateTime mainTime, @required TimeOfDay compareTime}){
  Duration mainDuration = Duration(hours: mainTime.hour, minutes: mainTime.minute, seconds: mainTime.second);

  int mainInSec = mainDuration.inSeconds;
  int compareInSec = compareTime.hour * 60 * 60 + compareTime.minute * 60;

  return compareInSec > mainInSec;
}

bool hazizzIsBeforeHHMMSS({@required DateTime mainTime, @required TimeOfDay compareTime}){
  Duration mainDuration = Duration(hours: mainTime.hour, minutes: mainTime.minute, seconds: mainTime.second);

  int mainInSec = mainDuration.inSeconds;
  int compareInSec = compareTime.hour * 60 * 60 + compareTime.minute * 60;

  return compareInSec < mainInSec;
}
