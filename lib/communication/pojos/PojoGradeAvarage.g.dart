// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGradeAvarage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGradeAvarage _$PojoGradeAvarageFromJson(Map<String, dynamic> json) {
  return PojoGradeAvarage(
    subject: json['subject'] as String,
    grade: (json['grade'] as num)?.toDouble(),
    classGrade: (json['classGrade'] as num)?.toDouble(),
    difference: (json['difference'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PojoGradeAvarageToJson(PojoGradeAvarage instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'grade': instance.grade,
      'classGrade': instance.classGrade,
      'difference': instance.difference,
    };
