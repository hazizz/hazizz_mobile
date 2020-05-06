import 'package:meta/meta.dart';
import 'dart:convert';

class PojoMyDetailedInfo {
  final int id;
  final String username;
  final String emailAddress;
  final String googleEmailAddress;
  final int facebookId;
  final String lastUpdated;
  final DateTime registrationDate;
  final bool locked;
  final bool disabled;
  final bool expired;

  PojoMyDetailedInfo({
    @required this.id,
    @required this.username,
    @required this.emailAddress,
    @required this.googleEmailAddress,
    @required this.facebookId,
    @required this.lastUpdated,
    @required this.registrationDate,
    @required this.locked,
    @required this.disabled,
    @required this.expired,
  });

  factory PojoMyDetailedInfo.fromRawJson(String str) => PojoMyDetailedInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PojoMyDetailedInfo.fromJson(Map<String, dynamic> json) => PojoMyDetailedInfo(
    id: json["id"],
    username: json["username"],
    emailAddress: json["emailAddress"],
    googleEmailAddress: json["googleEmailAddress"],
    facebookId: json["facebookId"],
    lastUpdated: json["lastUpdated"],
    registrationDate: DateTime.parse(json["registrationDate"]),
    locked: json["locked"],
    disabled: json["disabled"],
    expired: json["expired"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "emailAddress": emailAddress,
    "googleEmailAddress": googleEmailAddress,
    "facebookId": facebookId,
    "lastUpdated": lastUpdated,
    "registrationDate": "${registrationDate.year.toString().padLeft(4, '0')}-${registrationDate.month.toString().padLeft(2, '0')}-${registrationDate.day.toString().padLeft(2, '0')}",
    "locked": locked,
    "disabled": disabled,
    "expired": expired,
  };
}
