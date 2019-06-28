
import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
import 'PojoGroup.dart';

part 'PojoMeInfo.g.dart';

@JsonSerializable()
class PojoMeInfo extends Pojo{

  final int id;
  final String username, displayName;
  final List<String> permissions;
  final List<PojoGroup> groups;


  PojoMeInfo(this.id, this.username, this.displayName, this.permissions, this.groups);

  factory PojoMeInfo.fromJson(Map<String, dynamic> json) =>
      _$PojoMeInfoFromJson(json);
}