// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGroupPermissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGroupPermissions _$PojoGroupPermissionsFromJson(Map<String, dynamic> json) {
  return PojoGroupPermissions(
      OWNER: (json['OWNER'] as List)
          ?.map((e) =>
              e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      MODERATOR: (json['MODERATOR'] as List)
          ?.map((e) =>
              e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      USER: (json['USER'] as List)
          ?.map((e) =>
              e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      NULL: (json['NULL'] as List)
          ?.map((e) =>
              e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PojoGroupPermissionsToJson(
        PojoGroupPermissions instance) =>
    <String, dynamic>{
      'OWNER': instance.OWNER,
      'MODERATOR': instance.MODERATOR,
      'USER': instance.USER,
      'NULL': instance.NULL
    };
