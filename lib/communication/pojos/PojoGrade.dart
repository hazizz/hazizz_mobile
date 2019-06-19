import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoGrade.g.dart';

@JsonSerializable()
class PojoGrade extends Pojo {

  DateTime date;
  DateTime creationDate;
  String subject;
  String topic;
  String gradeType;
  String grade;
  String weight;

  PojoGrade({this.date, this.creationDate, this.subject, this.topic,
      this.gradeType, this.grade, this.weight});

  factory PojoGrade.fromJson(Map<String, dynamic> json) =>
      _$PojoGradeFromJson(json);
}