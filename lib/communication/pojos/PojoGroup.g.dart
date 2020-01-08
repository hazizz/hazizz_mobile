// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGroup _$PojoGroupFromJson(Map<String, dynamic> json) {
  return PojoGroup(
    json['id'] as int,
    json['name'] as String,
    json['uniqueName'] as String,
    json['groupType'] as String,
    json['userCount'] as int,
  );
}

Map<String, dynamic> _$PojoGroupToJson(PojoGroup instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uniqueName': instance.uniqueName,
      'groupType': instance.groupType,
      'userCount': instance.userCount,
    };

PojoGroupWithoutMe _$PojoGroupWithoutMeFromJson(Map<String, dynamic> json) {
  return PojoGroupWithoutMe(
    json['id'] as int,
    json['name'] as String,
    json['uniqueName'] as String,
    json['groupType'] as String,
    json['userCount'] as int,
    json['userCountWithoutMe'] as int,
  );
}

Map<String, dynamic> _$PojoGroupWithoutMeToJson(PojoGroupWithoutMe instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uniqueName': instance.uniqueName,
      'groupType': instance.groupType,
      'userCount': instance.userCount,
      'userCountWithoutMe': instance.userCountWithoutMe,
    };
