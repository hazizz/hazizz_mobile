// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoSchedules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoSchedules _$PojoSchedulesFromJson(Map<String, dynamic> json) {
  return PojoSchedules((json)?.map(
        (k, e) => MapEntry(
        k,
        (e as List)
            ?.map((e) => e == null
            ? null
            : PojoClass.fromJson(e as Map<String, dynamic>))
            ?.toList()),
  ));
}

Map<String, dynamic> _$PojoSchedulesToJson(PojoSchedules instance) => instance.classes;
