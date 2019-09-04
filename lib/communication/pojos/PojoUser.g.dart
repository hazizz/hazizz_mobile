// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoUser _$PojoUserFromJson(Map<String, dynamic> json) {
  return PojoUser(
      id: json['id'] as int,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      registrationDate: json['registrationDate'] == null
          ? null
          : DateTime.parse(json['registrationDate'] as String));
}

Map<String, dynamic> _$PojoUserToJson(PojoUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'registrationDate': instance.registrationDate?.toIso8601String()
    };
