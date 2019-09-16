import 'package:json_annotation/json_annotation.dart';

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

  PojoSession(this.id, this.status, this.username, this.url, this.schoolName, this.password);

  factory PojoSession.fromJson(Map<String, dynamic> json) =>
      _$PojoSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PojoSessionToJson(this);

}