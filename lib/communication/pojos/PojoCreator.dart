import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoCreator.g.dart';

@JsonSerializable()
class PojoCreator implements Pojo {

  int id;
  String username;
  String displayName;
  String registrationDate;

  PojoCreator(this.id, this.username, this.displayName, this.registrationDate);

  factory PojoCreator.fromJson(Map<String, dynamic> json) =>
      _$PojoCreatorFromJson(json);

  Map<String, dynamic> toJson() => _$PojoCreatorToJson(this);

}
