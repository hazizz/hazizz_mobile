// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoSubject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoSubject _$PojoSubjectFromJson(Map<String, dynamic> json) {
  return PojoSubject(
      json['id'] as int,
      json['name'] as String,
      json['subscriberOnly'] as bool,
      json['manager'] == null
          ? null
          : PojoComplient.fromJson(json['manager'] as Map<String, dynamic>),
      json['subscribed'] as bool);
}

Map<String, dynamic> _$PojoSubjectToJson(PojoSubject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subscriberOnly': instance.subscriberOnly,
      'manager': instance.manager,
      'subscribed': instance.subscribed
    };
