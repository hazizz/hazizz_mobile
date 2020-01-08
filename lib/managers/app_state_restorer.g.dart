// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_restorer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskMakerAppState _$TaskMakerAppStateFromJson(Map<String, dynamic> json) {
  return TaskMakerAppState(
    pojoTask: json['pojoTask'] == null
        ? null
        : PojoTask.fromJson(json['pojoTask'] as Map<String, dynamic>),
    taskMakerMode:
        _$enumDecodeNullable(_$TaskMakerModeEnumMap, json['taskMakerMode']),
    imagePaths: (json['imagePaths'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TaskMakerAppStateToJson(TaskMakerAppState instance) =>
    <String, dynamic>{
      'pojoTask': instance.pojoTask,
      'taskMakerMode': _$TaskMakerModeEnumMap[instance.taskMakerMode],
      'imagePaths': instance.imagePaths,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TaskMakerModeEnumMap = {
  TaskMakerMode.create: 'create',
  TaskMakerMode.edit: 'edit',
};
