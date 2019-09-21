import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoComplient.g.dart';

@JsonSerializable()
class PojoComplient  implements Pojo {

  int id;
  String username;
  String displayName;

  PojoComplient({this.id, this.username, this.displayName});

  @override
  factory PojoComplient.fromJson(Map<String, dynamic> json) =>
      _$PojoComplientFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PojoComplientToJson(this);

}