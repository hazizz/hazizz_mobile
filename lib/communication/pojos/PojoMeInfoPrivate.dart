
import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
import 'PojoGroup.dart';

part 'PojoMeInfoPrivate.g.dart';

@JsonSerializable()
class PojoMeInfoPrivate extends Pojo{

  final int id;
  final String username, displayName;
  final List<String> permissions;
  final List<PojoGroup> groups;


  PojoMeInfoPrivate(this.id, this.username, this.displayName, this.permissions, this.groups);

  factory PojoMeInfoPrivate.fromJson(Map<String, dynamic> json) =>
      _$PojoMeInfoPrivateFromJson(json);
}