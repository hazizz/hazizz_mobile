// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGrade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGrade _$PojoGradeFromJson(Map<String, dynamic> json) {
  return PojoGrade(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      gradeType: json['gradeType'] as String,
      grade: json['grade'] as String,
      weight: json['weight'] as String);
}

Map<String, dynamic> _$PojoGradeToJson(PojoGrade instance) => <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'creationDate': instance.creationDate?.toIso8601String(),
      'subject': instance.subject,
      'topic': instance.topic,
      'gradeType': instance.gradeType,
      'grade': instance.grade,
      'weight': instance.weight
    };
