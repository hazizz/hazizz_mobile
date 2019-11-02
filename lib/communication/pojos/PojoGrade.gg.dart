// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGrade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGrade _$PojoGradeFromJson(Map<String, dynamic> json) {
  DateTime creationDate = DateTime.parse(json['creationDate'] as String);
  return PojoGrade(
      accountId: json['accountId'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      creationDate: json['creationDate'] == null
          ? null
          : DateTime(creationDate.year, creationDate.month, creationDate.day),
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      gradeType: json['gradeType'] as String,
      grade: json['grade'] as String,
      weight: json['weight'] as int);
   // ..color = json['color'];
}

Map<String, dynamic> _$PojoGradeToJson(PojoGrade instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'date': instance.date?.toIso8601String(),
      'creationDate': instance.creationDate?.toIso8601String(),
      'subject': instance.subject,
      'topic': instance.topic,
      'gradeType': instance.gradeType,
      'grade': instance.grade,
      'weight': instance.weight,
     // 'color': instance.color
    };
