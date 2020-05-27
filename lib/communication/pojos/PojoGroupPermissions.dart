import 'package:json_annotation/json_annotation.dart';
import 'Pojo.dart';
import 'PojoUser.dart';

part 'PojoGroupPermissions.g.dart';

@JsonSerializable()
class PojoGroupPermissions implements Pojo {

  List<PojoUser> owner;
  List<PojoUser> moderator;
  List<PojoUser> user;
  List<PojoUser> null_permission;

  PojoGroupPermissions({this.owner, this.moderator, this.user, this.null_permission});

  factory PojoGroupPermissions.fromJson(Map<String, dynamic> json) =>
      _$PojoGroupPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PojoGroupPermissionsToJson(this);

}
