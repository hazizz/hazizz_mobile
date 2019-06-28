// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoSession.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoSession _$PojoSessionFromJson(Map<String, dynamic> json) {
  return PojoSession(json['id'] as int, json['status'] as String,
      json['username'] as String, json['url'] as String);
}

Map<String, dynamic> _$PojoSessionToJson(PojoSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'username': instance.username,
      'url': instance.url
    };
