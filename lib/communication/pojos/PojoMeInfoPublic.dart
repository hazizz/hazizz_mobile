import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
part 'PojoMeInfoPublic.g.dart';


@JsonSerializable()
class PojoMeInfoPublic extends Pojo {
  int id;
  String username;
  String displayName;

  PojoMeInfoPublic(this.id, this.username, this.displayName);

  factory PojoMeInfoPublic.fromJson(Map<String, dynamic> json) =>
      _$PojoMeInfoPublicFromJson(json);


}