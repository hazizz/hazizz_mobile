import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'Pojo.dart';

part 'PojoGradeAvarage.g.dart';

@JsonSerializable()
class PojoGradeAverage extends Pojo {

  String subject;
  double grade;
  double classGrade;
  double difference;

  PojoGradeAverage({this.subject, this.grade, this.classGrade, this.difference});


  factory PojoGradeAverage.fromJson(Map<String, dynamic> json){
    PojoGradeAverage pojoGradeAvarage = _$PojoGradeAvarageFromJson(json);
    //   pojoGrade.grade = "3";
    return pojoGradeAvarage;
  }

  Map<String, dynamic> toJson() => _$PojoGradeAvarageToJson(this);


}