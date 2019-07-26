import 'package:flutter/material.dart';

class HazizzTimeOfDay extends TimeOfDay{



  HazizzTimeOfDay({@required hour, @required minute}) : super(hour: hour, minute: minute){

  }

  HazizzTimeOfDay fromMinutes(int minutes){
    int hour = minutes ~/ 60;
    int minute = minutes % 60;

    return HazizzTimeOfDay(hour: hour, minute: minute);
  }

  int inMinutes(){
    return this.minute + this.hour * 60;
  }

  String toHazizzFormat(){
    return "$hour:$minute";

  }


  factory HazizzTimeOfDay.now() { return TimeOfDay.now(); }


  @override
  bool operator >=(dynamic other) {
    if (other is! HazizzTimeOfDay)
      return false;
    final HazizzTimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes();
    return inMinutes() >= otherInMinutes;
  }

  @override
  bool operator >(dynamic other) {
    if (other is! HazizzTimeOfDay)
      return false;
    final HazizzTimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes();
    return inMinutes() > otherInMinutes;
  }

  @override
  bool operator <=(dynamic other) {
    if (other is! HazizzTimeOfDay)
      return false;
    final HazizzTimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes();
    return inMinutes() <= otherInMinutes;
  }

  @override
  bool operator <(dynamic other) {
    if (other is! HazizzTimeOfDay)
      return false;
    final HazizzTimeOfDay typedOther = other;
    final otherInMinutes = typedOther.inMinutes();
    return inMinutes() < otherInMinutes;
  }


}