import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
import 'PojoCreator.dart';

part 'pojo_comment.g.dart';

@JsonSerializable()
class PojoComment  implements Pojo {
  String content;
  DateTime creationDate;
  PojoCreator creator;
  bool hiddenChildren;
  int id;
  List<PojoComment> children;

  PojoComment({this.content, this.creationDate, this.creator, this.hiddenChildren, this.id, this.children});

  @override
  factory PojoComment.fromJson(Map<String, dynamic> json) =>
      _$PojoCommentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PojoCommentToJson(this);
}