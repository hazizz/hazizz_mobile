import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'Pojo.dart';

part 'PojoTag.g.dart';

@JsonSerializable()
class PojoTag implements Pojo{

  String name;

  //Color color;

  PojoTag({this.name});

  bool get isDefault{
    return defaultTags.contains(this);
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
    }/* else if(name == defaultTags[4].name){
      return HazizzTheme.kreta_homeworkColor;
    }
    */
    else if(name == "Thera"){
      return HazizzTheme.kreta_homeworkColor;
    }
    return HazizzTheme.blue;
  }

  String getDisplayName(BuildContext context){
    if(name == defaultTags[0].name){
      return localize(context, key: "taskType_1");
    } else if(name == defaultTags[1].name){
      return localize(context, key: "taskType_2");
    } else if(name == defaultTags[2].name){
      return localize(context, key: "taskType_3");
    } else if(name == defaultTags[3].name){
      return localize(context, key: "taskType_4");
    }/*else if(name == defaultTags[4].name){
      return locText(context, key: "taskType_5");
    }
    */
    return name;
  }

  Future<String> getDisplayNameAsync() async {
    if(name == defaultTags[0].name){
      return await localizeWithoutContext(key: "taskType_1");
    } else if(name == defaultTags[1].name){
      return await localizeWithoutContext(key: "taskType_2");
    } else if(name == defaultTags[2].name){
      return await localizeWithoutContext(key: "taskType_3");
    } else if(name == defaultTags[3].name){
      return await localizeWithoutContext( key: "taskType_4");
    }/*else if(name == defaultTags[4].name){
      return await locTextContextless( key: "taskType_5");
    }*/
    return name;
  }

  static final List<PojoTag> defaultTags = [
    PojoTag(name: "_HOMEWORK"),
    PojoTag(name: "_ASSIGNMENT"),
    PojoTag(name: "_TEST"),
    PojoTag(name: "_ORAL_TEST"),
 //   PojoTag(name: "_KRETA_HOMEWORK"),
  ];

  factory PojoTag.fromJson(Map<String, dynamic> json) =>
      _$PojoTagFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTagToJson(this);
}
