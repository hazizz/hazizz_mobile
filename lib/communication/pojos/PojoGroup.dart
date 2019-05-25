import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
part 'PojoGroup.g.dart';


@JsonSerializable()
class PojoGroup extends Pojo {
  int id;
  String name;
  String uniqueName;
  String groupType;
  int userCount;

  PojoGroup(this.id, this.name, this.uniqueName, this.groupType,
      this.userCount);

  factory PojoGroup.fromJson(Map<String, dynamic> json) =>
      _$PojoGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PojoGroupToJson(this);

}