// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoAlertSettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoAlertSettings _$PojoAlertSettingsFromJson(Map<String, dynamic> json) {
  return PojoAlertSettings(
    alarmTime: json['alarmTime'] as String,
    mondayEnabled: json['mondayEnabled'] as bool,
    tuesdayEnabled: json['tuesdayEnabled'] as bool,
    wednesdayEnabled: json['wednesdayEnabled'] as bool,
    thursdayEnabled: json['thursdayEnabled'] as bool,
    fridayEnabled: json['fridayEnabled'] as bool,
    saturdayEnabled: json['saturdayEnabled'] as bool,
    sundayEnabled: json['sundayEnabled'] as bool,
  );
}

Map<String, dynamic> _$PojoAlertSettingsToJson(PojoAlertSettings instance) =>
    <String, dynamic>{
      'alarmTime': instance.alarmTime,
      'mondayEnabled': instance.mondayEnabled,
      'tuesdayEnabled': instance.tuesdayEnabled,
      'wednesdayEnabled': instance.wednesdayEnabled,
      'thursdayEnabled': instance.thursdayEnabled,
      'fridayEnabled': instance.fridayEnabled,
      'saturdayEnabled': instance.saturdayEnabled,
      'sundayEnabled': instance.sundayEnabled,
    };
