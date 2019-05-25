// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoError.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoError _$PojoErrorFromJson(Map<String, dynamic> json) {
  return PojoError(
      time: json['time'] as String,
      errorCode: json['errorCode'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      url: json['url'] as String);
}

Map<String, dynamic> _$PojoErrorToJson(PojoError instance) => <String, dynamic>{
      'time': instance.time,
      'errorCode': instance.errorCode,
      'title': instance.title,
      'message': instance.message,
      'url': instance.url
    };
