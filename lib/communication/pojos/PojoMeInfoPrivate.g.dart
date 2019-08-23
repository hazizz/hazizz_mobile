// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoMeInfoPrivate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoMeInfoPrivate _$PojoMeInfoPrivateFromJson(Map<String, dynamic> json) {
  return PojoMeInfoPrivate(
      json['id'] as int,
      json['username'] as String,
      json['displayName'] as String,
      (json['permissions'] as List)?.map((e) => e as String)?.toList(),
      (json['groups'] as List)
          ?.map((e) =>
              e == null ? null : PojoGroup.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PojoMeInfoPrivateToJson(PojoMeInfoPrivate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'permissions': instance.permissions,
      'groups': instance.groups
    };
