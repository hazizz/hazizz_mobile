import 'package:json_annotation/json_annotation.dart';

part 'PojoTokens.g.dart';

@JsonSerializable()
class PojoTokens{
  PojoTokens({
    this.token,
    this.refresh
  });

  final String token;
  final String refresh;

  factory PojoTokens.fromJson(Map<String, dynamic> json) =>
      _$PojoTokensFromJson(json);


}