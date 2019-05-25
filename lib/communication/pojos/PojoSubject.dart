import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
part 'PojoSubject.g.dart';

@JsonSerializable()
class  PojoSubject implements Pojo {

  int id;
  String name;

  PojoSubject(this.id, this.name);

  factory PojoSubject.fromJson(Map<String, dynamic> json) =>
      _$PojoSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$PojoSubjectToJson(this);

}