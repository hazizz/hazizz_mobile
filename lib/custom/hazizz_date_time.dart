import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HazizzDateTime extends DateTime{

  HazizzDateTime(int year,
      [int month = 1,
        int day = 1,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0])
      : super(year, month, day, hour, minute, second, millisecond,
      microsecond);


  static fromToday(int hour, int minute){
    final d = HazizzDateTime.now();
    return HazizzDateTime(d.year, d.month, d.day, hour, minute);
  }

  static fromTimeOfDay(TimeOfDay t){
    final d = HazizzDateTime.now();
    return HazizzDateTime(d.year, d.month, d.day, t.hour, t.minute);
  }


  String hazizzShowDateFormat(){
    return DateFormat("yyyy.MM.dd").format(this);
  }

  String hazizzShowDateAndTimeFormat(){
    return DateFormat("yyyy.MM.dd HH:mm").format(this.add(DateTime.now().timeZoneOffset));
  }

  static HazizzDateTime now(){
    var d = DateTime.now();
    return HazizzDateTime(d.year, d.month, d.day, d.hour, d.minute, d.second, d.millisecond, d.microsecond);
    
  }

  static HazizzDateTime parse(String formattedString){
    HazizzDateTime d = DateTime.parse(formattedString);
    return d;
  }

  @override
  bool operator >=(dynamic other) {
    if (other is! DateTime)
      return false;
    final DateTime typedOther = other;
    final otherInMicrosecond = typedOther.millisecondsSinceEpoch;
    return this.millisecondsSinceEpoch >= otherInMicrosecond;
  }

  @override
  bool operator >(dynamic other) {
    if (other is! DateTime)
      return false;
    final DateTime typedOther = other;
    final otherInMicrosecond = typedOther.millisecondsSinceEpoch;
    return this.millisecondsSinceEpoch > otherInMicrosecond;
  }

  @override
  bool operator <=(dynamic other) {
    if (other is! DateTime)
      return false;
    final DateTime typedOther = other;
    final otherInMicrosecond = typedOther.millisecondsSinceEpoch;
    return this.millisecondsSinceEpoch <= otherInMicrosecond;
  }

  @override
  bool operator <(dynamic other) {
    if (other is! DateTime)
      return false;
    final HazizzDateTime typedOther = other;
    final otherInMicrosecond = typedOther.millisecondsSinceEpoch;
    return this.millisecondsSinceEpoch < otherInMicrosecond;
  }
}