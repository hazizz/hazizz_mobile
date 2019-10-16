import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoError.g.dart';

@JsonSerializable()
class PojoError extends Pojo{
  PojoError({
    this.time,
    this.errorCode,
    this.title,
    this.message,
    this.url,
  });

  final String time;
  final int errorCode;
  final String title;
  final String message;
  final String url;

  factory PojoError.fromJson(Map<String, dynamic> json) =>
      _$PojoErrorFromJson(json);

  Map<String, dynamic> toJson() => _$PojoErrorToJson(this);

}