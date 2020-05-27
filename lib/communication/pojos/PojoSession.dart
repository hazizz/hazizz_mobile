import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'Pojo.dart';
part 'PojoSession.g.dart';

@JsonSerializable()
class PojoSession extends Pojo{
  int id;
  String status;
  String username;
  String url;
  String schoolName;
  String password;

  String getLocalizedStatus(BuildContext context)
    => ("session_status_" + status.toLowerCase()).localize(context).toUpperCase();

  PojoSession(this.id, this.status, this.username, this.url, this.schoolName, this.password);

  factory PojoSession.fromJson(Map<String, dynamic> json) =>
      _$PojoSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PojoSessionToJson(this);

}