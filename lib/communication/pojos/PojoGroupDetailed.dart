import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
import 'PojoUser.dart';
part 'PojoGroupDetailed.g.dart';


@JsonSerializable()
class PojoGroupDetailed extends Pojo {
  int id;
  String name;
  String groupType;
  List<PojoUser> users;
  DateTime creationDate;
  DateTime lastUpdated;

  PojoGroupDetailed(this.id, this.name, this.groupType,
      this.users, this.creationDate, this.lastUpdated);

  factory PojoGroupDetailed.fromJson(Map<String, dynamic> json) =>
      _$PojoGroupDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$PojoGroupDetailedToJson(this);

}