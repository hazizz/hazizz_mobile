// GENERATED CODE - DO NOT MODIFY BY HAND
/*
part of 'PojoTheraHealth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoTheraHealth _$PojoTheraHealthFromJson(Map<String, dynamic> json) {
  return PojoTheraHealth(
    json['status'] as String,
    json['details'] == null
        ? null
        : PojoTheraHealth.fromJson(json['details'] as Map<String, dynamic>),
    json['kretaRequestsInLastHour'] as int,
    (json['kretaSuccessRate'] as num)?.toDouble(),
  )..theraHealthManager = json['theraHealthManager'] == null
      ? null
      : PojoTheraHealth.fromJson(
          json['theraHealthManager'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PojoTheraHealthToJson(PojoTheraHealth instance) =>
    <String, dynamic>{
      'status': instance.status,
      'details': instance.details,
      'theraHealthManager': instance.theraHealthManager,
      'kretaRequestsInLastHour': instance.kretaRequestsInLastHour,
      'kretaSuccessRate': instance.kretaSuccessRate,
    };


*/