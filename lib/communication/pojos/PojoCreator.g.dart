// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoCreator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoCreator _$PojoCreatorFromJson(Map<String, dynamic> json) {
  return PojoCreator(
    json['id'] as int,
    json['username'] as String,
    json['displayName'] as String,
    json['registrationDate'] == null
        ? null
        : DateTime.parse(json['registrationDate'] as String),
  );
}

Map<String, dynamic> _$PojoCreatorToJson(PojoCreator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'registrationDate': instance.registrationDate?.toIso8601String(),
    };
