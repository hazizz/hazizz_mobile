// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoKretaProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoKretaProfile _$PojoKretaProfileFromJson(Map<String, dynamic> json) {
  return PojoKretaProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      schoolName: json['schoolName'] as String,
      formTeacher: json['formTeacher'] == null ? null :
      PojoKretaTeacherProfile.fromJson(json['formTeacher']  as Map<String, dynamic>)
  );
}

Map<String, dynamic> _$PojoKretaProfileToJson(PojoKretaProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'schoolName': instance.schoolName,
      'formTeacher': instance.formTeacher
    };
