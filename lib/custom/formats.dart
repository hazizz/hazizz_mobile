import 'package:flutter/widgets.dart';

import '../hazizz_localizations.dart';

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