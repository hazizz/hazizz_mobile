import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'Pojo.dart';

part 'PojoKretaTeacherProfile.g.dart';

@JsonSerializable()
class PojoKretaTeacherProfile extends Pojo {

  int id;
  String name;
  String email;

  PojoKretaTeacherProfile({this.id, this.name, this.email});


  factory PojoKretaTeacherProfile.fromJson(Map<String, dynamic> json){
    PojoKretaTeacherProfile profile = _$PojoKretaTeacherProfileFromJson(json);
    return profile;
  }

  Map<String, dynamic> toJson() => _$PojoKretaTeacherProfileToJson(this);


}