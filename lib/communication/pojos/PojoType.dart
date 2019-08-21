import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hazizz_theme.dart';
import 'Pojo.dart';

part 'PojoType.g.dart';

@JsonSerializable()
class PojoType implements Pojo {
  String name;
  int id;
  PojoType({this.name, this.id});

  factory PojoType.fromJson(Map<String, dynamic> json) =>
      _$PojoTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTypeToJson(this);

  static final List<PojoType> pojoTypes = [
    PojoType(
      name: "homework",
      id: 1
    ),
    PojoType(
        name: "assignment",
        id: 2
    ),
    PojoType(
        name: "test",
        id: 3
    ),
    PojoType(
        name: "oral test",
        id: 4
    )
  ];

  // Coloring
  static final HOMEWORK_ID = 1;
  static final ASSIGNMENT_ID = 2;
  static final TEST_ID = 3;
  static final ORAL_TEST_ID = 4;

  Color getColor(){
    if(id  == PojoType.HOMEWORK_ID){
      return HazizzTheme.homeworkColor;
    }
    if(id == PojoType.ASSIGNMENT_ID){
      return HazizzTheme.assignmentColor;
    }
    if(id  == PojoType.ORAL_TEST_ID){
      return HazizzTheme.oralTestColor;
    }
    if(id  == PojoType.TEST_ID){
      return HazizzTheme.testColor;
    }
  }





}
