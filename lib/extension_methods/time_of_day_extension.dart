import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get hazizzFormat{
    String str_h = this.hour >= 10 ? this.hour.toString() : "0${this.hour}";
    String str_m = this.minute >= 10 ? this.minute.toString() : "0${this.minute}";
    return "$str_h:$str_m";
  }

  Duration compare(TimeOfDay other){
    int minutesDifference = other.inMinutes - this.inMinutes;
    Duration inDuration = Duration(minutes: minutesDifference);

    return inDuration;
  }

  int get inMinutes{
    return this.minute + this.hour * 60;
  }


  bool operator >=(dynamic other) {
    if (other is! TimeOfDay)
      return false;
    final TimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes;
    return inMinutes >= otherInMinutes;
  }

  bool operator >(dynamic other) {
    if (other is! TimeOfDay)
      return false;
    final TimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes;
    return inMinutes > otherInMinutes;
  }

  bool operator <=(dynamic other) {
    if (other is! TimeOfDay)
      return false;
    final TimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes;
    return inMinutes <= otherInMinutes;
  }

  bool operator <(dynamic other) {
    if (other is! TimeOfDay)
      return false;
    final TimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes;
    return inMinutes < otherInMinutes;
  }
  
}