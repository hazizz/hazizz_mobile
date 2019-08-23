import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hazizz_localizations.dart';
import '../../hazizz_theme.dart';
import 'Pojo.dart';

part 'PojoTag.g.dart';

@JsonSerializable()
class PojoTag implements Pojo{

  String name;

  //Color color;

  PojoTag({this.name}){
  }

  String getName(){
    return name;
  }

  Color getColor(){
    if(name == defaultTags[0].name){
      return HazizzTheme.homeworkColor;
    } else if(name == defaultTags[1].name){
      return  HazizzTheme.assignmentColor;
    } else if(name == defaultTags[2].name){
      return HazizzTheme.testColor;
    } else if(name == defaultTags[3].name){
      return HazizzTheme.oralTestColor;
    }
    return HazizzTheme.blue;
  }

  String getDisplayName(BuildContext context){
    if(name == defaultTags[0].name){
      return locText(context, key: "taskType_1");
    } else if(name == defaultTags[1].name){
      return locText(context, key: "taskType_2");
    } else if(name == defaultTags[2].name){
      return locText(context, key: "taskType_3");
    } else if(name == defaultTags[3].name){
      return locText(context, key: "taskType_4");
    }
    return name;
  }

  static final List<PojoTag> defaultTags = [
    PojoTag(name: "_HOMEWORK"),
    PojoTag(name: "_ASSIGNMENT"),
    PojoTag(name: "_TEST"),
    PojoTag(name: "_ORAL_TEST"),
  ];

  factory PojoTag.fromJson(Map<String, dynamic> json) =>
      _$PojoTagFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTagToJson(this);
}
