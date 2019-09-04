import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/custom/hazizz_date_time.dart';

import 'Pojo.dart';
import 'PojoUser.dart';

part 'PojoGroupPermissions.g.dart';

@JsonSerializable()
class PojoGroupPermissions implements Pojo {

  List<PojoUser> OWNER;
  List<PojoUser> MODERATOR;
  List<PojoUser> USER;
  List<PojoUser> NULL;

  PojoGroupPermissions({this.OWNER, this.MODERATOR, this.USER, this.NULL});

  factory PojoGroupPermissions.fromJson(Map<String, dynamic> json) =>
      _$PojoGroupPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PojoGroupPermissionsToJson(this);

}
