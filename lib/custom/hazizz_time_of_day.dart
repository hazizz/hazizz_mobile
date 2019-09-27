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

    String str_h = hour >= 10 ? hour.toString() : "0$hour";
    String str_m = minute >= 10 ? minute.toString() : "0$minute";


    return "$str_h:$str_m";
  }


  Duration compare(HazizzTimeOfDay other){

    int minutesDifference = other.inMinutes() - this.inMinutes();
    Duration inDuration = Duration(minutes: minutesDifference);

    return inDuration;
  }


//  factory HazizzTimeOfDay.now() { return TimeOfDay.now(); }

  static now() {
    var t = TimeOfDay.now(); 
    
    return HazizzTimeOfDay(hour: t.hour, minute: t.minute);
    
    
  }


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