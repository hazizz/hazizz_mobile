import 'package:meta/meta.dart';
import 'dart:convert';

class PojoTokens {
  final String token;
  final String refresh;
  final dynamic scopes;
  final dynamic state;
  final int expiresIn;
  final String refreshToken;
  final String accessToken;

  PojoTokens({
    @required this.token,
    @required this.refresh,
    @required this.scopes,
    @required this.state,
    @required this.expiresIn,
    @required this.refreshToken,
    @required this.accessToken,
  });

  factory PojoTokens.fromRawJson(String str) => PojoTokens.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PojoTokens.fromJson(Map<String, dynamic> json) => PojoTokens(
    token: json["token"],
    refresh: json["refresh"],
    scopes: json["scopes"],
    state: json["state"],
    expiresIn: json["expires_in"],
    refreshToken: json["refresh_token"],
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "refresh": refresh,
    "scopes": scopes,
    "state": state,
    "expires_in": expiresIn,
    "refresh_token": refreshToken,
    "access_token": accessToken,
  };
}
