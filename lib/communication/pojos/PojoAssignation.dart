import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoAssignation.g.dart';

@JsonSerializable()
class PojoAssignation  implements Pojo {
  String name;
  int id;

  PojoAssignation({this.name, this.id});

  @override
  factory PojoAssignation.fromJson(Map<String, dynamic> json) =>
      _$PojoAssignationFromJson(json);

  Map<String, dynamic> toJson() => _$PojoAssignationToJson(this);

}