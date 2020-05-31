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

  String daysDifference(BuildContext context){
   // int daysDifference = DateTime.now().difference(this).inDays;
    int daysDiff = this.difference(DateTime.now().subtract(Duration(days: 1))).inDays;

    String day;
    if(daysDiff == 0){
      day = localize(context, key: "today");
    }else if(daysDiff == 1){
      day = localize(context, key: "tomorrow");
    }else if(daysDiff == -1){
      day = localize(context, key: "yesterday");
    }else if(daysDiff < 0){
      day = localize(context, key: "days_ago", args: [daysDiff.abs().toString()]);
    }else{
      day = localize(context, key: "days_later", args: [daysDiff.toString()]);
    }

    return day;
  }

  String weekdayLocalize(BuildContext context){
    // int daysDifference = DateTime.now().difference(this).inDays;

    return "days_${this.weekday-1}".localize(context);
  }


  String dateTimeToLastUpdatedFormatLocalized(BuildContext context){
    int month = this.month;

    int day = this.day;
    int hour = this.hour;
    int minute = this.minute;

    String strHour = hour.toString();
    String strMinute = minute.toString();
    String strDay = day.toString();
    String strMonth = month.toString();
    if(month < 10){
      strMonth = "0$strMonth";
    }
    if(day < 10){
      strDay = "0$strDay";
    }
    if(hour < 10){
      strHour = "0$strHour";
    }
    if(minute < 10){
      strMinute = "0$strMinute";
    }
    return localize(context, key: "last_updated") + ": " + "${this.year}.$strMonth.$strDay $strHour:$strMinute";
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

  bool operator >=(dynamic other) {
    if (other is! DateTime) return false;
    return this.millisecondsSinceEpoch >= other.millisecondsSinceEpoch;
  }

  bool operator >(dynamic other) {
    if (other is! DateTime) return false;
    return this.millisecondsSinceEpoch > other.millisecondsSinceEpoch;
  }

  bool operator <=(dynamic other) {
    if (other is! DateTime) return false;
    return this.millisecondsSinceEpoch <= other.millisecondsSinceEpoch;
  }

  bool operator <(dynamic other) {
    if (other is! DateTime) return false;
    return this.millisecondsSinceEpoch < other.millisecondsSinceEpoch;
  }
}