import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'Pojo.dart';

part 'PojoGrade.gg.dart';

//@JsonSerializable()
class PojoGrade extends Pojo implements Comparable {

  final String accountId;
  final DateTime date;
  final DateTime creationDate;
  final String subject;
  final String topic;
  final GradeTypeEnum gradeType;
  final String grade;
  final int weight;

  bool isNew = false;

  Color color;

  PojoGrade({this.accountId, this.date, this.creationDate, this.subject,
    this.topic, this.gradeType, this.grade, this.weight}){
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
      int a = this.creationDate.compareTo(other.creationDate);
      return a;
    }
    return null;
  }

  int compareToByCreationDate(other) {
    if(other is PojoGrade){
      int a = this.creationDate.compareTo(other.creationDate);
      return a;
    }
    return null;
  }

  int compareToByDate(other) {
    if(other is PojoGrade){
      int a = this.date.compareTo(other.date);
      return a;
    }
    return null;
  }

  bool operator == (dynamic other){
    if(other is PojoGrade) {
      return (other.gradeType == gradeType &&
          other.grade == grade &&
          other.subject == subject &&
          other.accountId == accountId &&
          other.date == date &&
          other.topic == topic &&
          other.weight == weight &&
          other.creationDate == creationDate
      );
    }
    return false;
  }

}