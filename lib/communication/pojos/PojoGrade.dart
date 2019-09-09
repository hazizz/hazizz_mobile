

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hazizz_theme.dart';
import 'Pojo.dart';

part 'PojoGrade.gg.dart';

//@JsonSerializable()
class PojoGrade extends Pojo implements Comparable {

  DateTime date;
  DateTime creationDate;
  String subject;
  String topic;
  String gradeType;
  String grade;
  int weight;

  /*
  DateTime creationDate;
  String gradeType;
  */

  Color color;

  PojoGrade({this.date, this.creationDate, this.subject, this.topic,
      this.gradeType, this.grade, this.weight}){
  //  grade = "5";
    _setColor();
  }

  _setColor(){
    if(grade == "5"){
      color = HazizzTheme.grade5Color;
    }else if(grade == "4"){
      color = HazizzTheme.grade4Color;
    }else if(grade == "3"){
      color = HazizzTheme.grade3Color;
    }else if(grade == "2"){
      color = HazizzTheme.grade2Color;
    }else if(grade == "1"){
      color = HazizzTheme.grade1Color;
    }else{
      color = HazizzTheme.gradeNeutralColor;
    }
  }

  factory PojoGrade.fromJson(Map<String, dynamic> json){
    PojoGrade pojoGrade = _$PojoGradeFromJson(json);
 //   pojoGrade.grade = "3";
    pojoGrade._setColor();
    return pojoGrade;
  }


  Map<String, dynamic> toJson() => _$PojoGradeToJson(this);

  @override
  int compareTo(other) {
    if(other is PojoGrade){
      int a = this.date.compareTo(other.date);
      return a;
    }
    return null;
  }
}