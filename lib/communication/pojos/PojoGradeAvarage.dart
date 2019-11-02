import 'dart:core';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:mobile/theme/hazizz_theme.dart';
import 'Pojo.dart';

part 'PojoGradeAvarage.g.dart';

@JsonSerializable()
class PojoGradeAvarage extends Pojo {

  String subject;
  double grade;
  double classGrade;
  double difference;

  PojoGradeAvarage({this.subject, this.grade, this.classGrade, this.difference});


  factory PojoGradeAvarage.fromJson(Map<String, dynamic> json){
    PojoGradeAvarage pojoGradeAvarage = _$PojoGradeAvarageFromJson(json);
    //   pojoGrade.grade = "3";
    return pojoGradeAvarage;
  }

  Map<String, dynamic> toJson() => _$PojoGradeAvarageToJson(this);


}