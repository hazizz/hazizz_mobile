// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoMeInfoPublic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoMeInfoPublic _$PojoMeInfoPublicFromJson(Map<String, dynamic> json) {

  print("log: pojomeinfo: id: ${json['id']}");
  print("log: pojomeinfo: use: ${json['username']}");

  print("log: pojomeinfo: disp: ${json['displayName']}");


  return PojoMeInfoPublic(
      json['id'] as int, json['username'] as String, json['displayName'] as String);
}

Map<String, dynamic> _$PojoMeInfoPublicToJson(PojoMeInfoPublic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.username,
      'displayName': instance.displayName
    };
