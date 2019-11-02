// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoKretaTeacherProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoKretaTeacherProfile _$PojoKretaTeacherProfileFromJson(
    Map<String, dynamic> json) {
  return PojoKretaTeacherProfile(
      id: json['id'] as int, name: json['name'] as String)
    ..email = json['email'] as String;
}

Map<String, dynamic> _$PojoKretaTeacherProfileToJson(
        PojoKretaTeacherProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email
    };
