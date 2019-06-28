<<<<<<< HEAD
import 'package:mobile/hazizz_date.dart';
=======
import 'package:hazizz_mobile/hazizz_date.dart';
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc
import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoClass.g.dart';

@JsonSerializable()
class PojoClass extends Pojo{
  DateTime date;
  Duration startOfClass;
  Duration endOfClass;
  int periodNumber;
  bool cancelled;
  bool standIn;
  String subject;
  String className;
  String teacher;
  String room;
  String topic;

  PojoClass({this.date, this.startOfClass, this.endOfClass, this.periodNumber,
      this.cancelled, this.standIn, this.subject, this.className, this.teacher,
      this.room, this.topic});

  factory PojoClass.fromJson(Map<String, dynamic> json){
    PojoClass pojoClass = _$PojoClassFromJson(json);
    pojoClass.className = "Matek";
    return pojoClass;
  }

}