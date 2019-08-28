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

@JsonSerializable()
class PojoGroupWithoutMe extends PojoGroup {
  int id;
  String name;
  String uniqueName;
  String groupType;
  int userCount;
  int userCountWithoutMe;

  PojoGroupWithoutMe(this.id, this.name, this.uniqueName, this.groupType, this.userCount, this.userCountWithoutMe) : super(id, name, uniqueName, groupType, userCount);

  factory PojoGroupWithoutMe.fromJson(Map<String, dynamic> json) =>
      _$PojoGroupWithoutMeFromJson(json);

  Map<String, dynamic> toJson() => _$PojoGroupWithoutMeToJson(this);

}