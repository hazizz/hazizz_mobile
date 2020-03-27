import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

String add0(int n){
  if(n < 10){
    return "0$n";
  }
  return n.toString();
}

String dateTimeToLastUpdatedFormat(BuildContext context, DateTime dateTime){

  int month = dateTime.month;

  int day = dateTime.day;
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  String str_hour = hour.toString();
  String str_minute = minute.toString();
  String str_day = day.toString();
  String str_month = month.toString();
  if(month < 10){
    str_month = "0$str_month";
  }
  if(day < 10){
    str_day = "0$str_day";
  }
  if(hour < 10){
    str_hour = "0$str_hour";
  }
  if(minute < 10){
    str_minute = "0$str_minute";
  }

  return locText(context, key: "last_updated") + ": " + "${dateTime.year.toString()}.$str_month.$str_day $str_hour:$str_minute";
}



String toHazizzFormat(TimeOfDay timeOfDay){
  String str_h = timeOfDay.hour >= 10 ? timeOfDay.hour.toString() : "0${timeOfDay.hour}";
  String str_m = timeOfDay.minute >= 10 ? timeOfDay.minute.toString() : "0${timeOfDay.minute}";

  return "$str_h:$str_m";
}

String hazizzRequestDateFormat(DateTime dateTime){
  return DateFormat("yyyy-MM-dd").format(dateTime);
}

String dateTimeToMonthDay(DateTime d){
  return DateFormat("MM.dd").format(d);
}

String hazizzShowDateFormat(DateTime d){
  return DateFormat("yyyy.MM.dd").format(d);
}

String hazizzShowDateAndTimeFormat(DateTime d){
  return DateFormat("yyyy.MM.dd HH:mm").format(d.add(DateTime.now().timeZoneOffset));
}