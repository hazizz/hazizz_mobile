import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoClass.g.dart';

@JsonSerializable()
class PojoClass extends Pojo{
  DateTime date;
  String startOfClass;
  String endOfClass;
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

  factory PojoClass.fromJson(Map<String, dynamic> json) =>
      _$PojoClassFromJson(json);

}