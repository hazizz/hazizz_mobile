import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoType.g.dart';

@JsonSerializable()
class PojoType  implements Pojo {
  String name;
  int id;
  PojoType({this.name, this.id});

  factory PojoType.fromJson(Map<String, dynamic> json) =>
      _$PojoTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTypeToJson(this);

}
