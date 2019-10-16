import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoKretaAvarage.g.dart';

@JsonSerializable()
class PojoKretaAvarage extends Pojo{

  final String type;
  final String title;
  final String content;
  final String teacher;
  final DateTime creationDate;

  PojoKretaAvarage({this.type, this.title, this.content, this.teacher, this.creationDate});

  factory PojoKretaAvarage.fromJson(Map<String, dynamic> json) =>
      _$PojoKretaAvarageFromJson(json);

  Map<String, dynamic> toJson() => _$PojoKretaAvarageToJson(this);

}