import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'Pojo.dart';

part 'PojoClass.gg.dart';

// removing so it wont recreate
//@JsonSerializable()
class PojoClass extends Pojo{
  String accountId;
  DateTime date;
  TimeOfDay startOfClass;
  TimeOfDay endOfClass;
  int periodNumber;
  bool cancelled;
  bool standIn;
  String subject;
  String className;
  String teacher;
  String room;
  String topic;

  PojoClass({this.accountId, this.date, this.startOfClass, this.endOfClass, this.periodNumber,
      this.cancelled, this.standIn, this.subject, this.className, this.teacher,
      this.room, this.topic});

  factory PojoClass.fromJson(Map<String, dynamic> json){
    PojoClass pojoClass = _$PojoClassFromJson(json);
   // pojoClass.className = "MatekMatekMatek";
    return pojoClass;
  }

  Map<String, dynamic> toJson() => _$PojoClassToJson(this);

}