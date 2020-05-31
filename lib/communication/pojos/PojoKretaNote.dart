import 'package:json_annotation/json_annotation.dart';
import 'Pojo.dart';
part 'PojoKretaNote.g.dart';

@JsonSerializable()
class PojoKretaNote extends Pojo{

  final String type;
  final String title;
  final String content;
  final String teacher;
  final DateTime creationDate;

  PojoKretaNote({this.type, this.title, this.content, this.teacher, this.creationDate});

  factory PojoKretaNote.fromJson(Map<String, dynamic> json) =>
      _$PojoKretaNoteFromJson(json);

  Map<String, dynamic> toJson() => _$PojoKretaNoteToJson(this);
}