// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGroupDetailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGroupDetailed _$PojoGroupDetailedFromJson(Map<String, dynamic> json) {
  return PojoGroupDetailed(
    json['id'] as int,
    json['name'] as String,
    json['groupType'] as String,
    (json['users'] as List)
        ?.map((e) =>
            e == null ? null : PojoUser.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    json['lastUpdated'] == null
        ? null
        : DateTime.parse(json['lastUpdated'] as String),
  );
}

Map<String, dynamic> _$PojoGroupDetailedToJson(PojoGroupDetailed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'groupType': instance.groupType,
      'users': instance.users,
      'creationDate': instance.creationDate?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
