import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
part 'PojoMeInfo.g.dart';


@JsonSerializable()
class PojoMeInfo extends Pojo {
  int id;
  String username;
  String displayName;

  PojoMeInfo(this.id, this.username, this.displayName);

  factory PojoMeInfo.fromJson(Map<String, dynamic> json) =>
      _$PojoMeInfoFromJson(json);


}