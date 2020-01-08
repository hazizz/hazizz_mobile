// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoTokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoTokens _$PojoTokensFromJson(Map<String, dynamic> json) {
  return PojoTokens(
    access_token: json['access_token'] as String,
    refresh_token: json['refresh_token'] as String,
  );
}

Map<String, dynamic> _$PojoTokensToJson(PojoTokens instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'refresh_token': instance.refresh_token,
    };
