// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGroupPermissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGroupPermissions _$PojoGroupPermissionsFromJson(Map<String, dynamic> json) {
  return PojoGroupPermissions(
    owner: (json['OWNER'] as List)
        ?.map((e) =>
            e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    moderator: (json['MODERATOR'] as List)
        ?.map((e) =>
            e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    user: (json['USER'] as List)
        ?.map((e) =>
            e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    nullPermission: (json['NULL'] as List)
        ?.map((e) =>
            e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PojoGroupPermissionsToJson(
        PojoGroupPermissions instance) =>
    <String, dynamic>{
      'OWNER': instance.owner,
      'MODERATOR': instance.moderator,
      'USER': instance.user,
      'NULL': instance.nullPermission,
    };
