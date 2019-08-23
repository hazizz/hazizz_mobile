// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoMeInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoMeInfo _$PojoMeInfoFromJson(Map<String, dynamic> json) {
  return PojoMeInfo(json['id'] as int, json['username'] as String,
      json['displayName'] as String);
}

Map<String, dynamic> _$PojoMeInfoToJson(PojoMeInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName
    };
