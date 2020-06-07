// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoGrades.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoGrades _$PojoGradesFromJson(Map<String, dynamic> json) {
  return PojoGrades(json?.map(
        (k, e) => MapEntry(
        k,
        (e as List)
            ?.map((e) => e == null
            ? null
            : PojoGrade.fromJson(e as Map<String, dynamic>))
            ?.toList()),
  ));
}

Map<String, dynamic> _$PojoGradesToJson(PojoGrades instance) => instance.grades;