import 'package:json_annotation/json_annotation.dart';

part 'PojoTokens.g.dart';

@JsonSerializable()
class PojoTokens{
  PojoTokens({
    this.access_token,
    this.refresh_token
  });

  final String access_token;
  final String refresh_token;

  factory PojoTokens.fromJson(Map<String, dynamic> json) =>
      _$PojoTokensFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTokensToJson(this);

}