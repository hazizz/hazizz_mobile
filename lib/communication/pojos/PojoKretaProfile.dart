import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'Pojo.dart';
import 'PojoKretaTeacherProfile.dart';

part 'PojoKretaProfile.g.dart';

@JsonSerializable()
class PojoKretaProfile extends Pojo {

  int id;
  String name;
  String schoolName;
  PojoKretaTeacherProfile formTeacher;


  PojoKretaProfile({this.id, this.name, this.schoolName, this.formTeacher});


  factory PojoKretaProfile.fromJson(Map<String, dynamic> json){
    PojoKretaProfile pojoKretaProfile = _$PojoKretaProfileFromJson(json);
    //   pojoGrade.grade = "3";
    return pojoKretaProfile;
  }

  Map<String, dynamic> toJson() => _$PojoKretaProfileToJson(this);
}