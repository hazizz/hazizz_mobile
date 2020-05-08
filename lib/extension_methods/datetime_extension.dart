import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/custom/hazizz_localizations.dart';

extension DateTimeExtension on DateTime {

  DateTime operator -(Duration other) {
    return this.subtract(other);
  }

  DateTime operator +(Duration other) {
    return this.add(other);
  }

  String get hazizzRequestDateFormat => DateFormat("yyyy-MM-dd").format(this);

  String get dateTimeToMonthDay => DateFormat("MM.dd").format(this);

  String get hazizzShowDateFormat => DateFormat("yyyy.MM.dd").format(this);

  String get hazizzShowDateAndTimeFormat => DateFormat("yyyy.MM.dd HH:mm").format(this.add(DateTime.now().timeZoneOffset));

  String dateTimeToLastUpdatedFormatLocalized(BuildContext context){
    int month = this.month;

    int day = this.day;
    int hour = this.hour;
    int minute = this.minute;

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

    return locText(context, key: "last_updated") + ": " + "${this.year}.$str_month.$str_day $str_hour:$str_minute";
  }


  bool isAfterTimeOfDay({@required TimeOfDay timeOfDay}){
    if(timeOfDay == null) return false;

    Duration mainDuration = Duration(hours: this.hour, minutes: this.minute, seconds: this.second);

    int mainInSec = mainDuration.inSeconds;
    int compareInSec = timeOfDay.hour * 60 * 60 + timeOfDay.minute * 60;

    return compareInSec > mainInSec;
  }

  bool isBeforeTimeOfDay({@required TimeOfDay timeOfDay}){
    if(timeOfDay == null) return false;

    Duration mainDuration = Duration(hours: this.hour, minutes: this.minute, seconds: this.second);

    int mainInSec = mainDuration.inSeconds;
    int compareInSec = timeOfDay.hour * 60 * 60 + timeOfDay.minute * 60;

    return compareInSec < mainInSec;
  }



}


