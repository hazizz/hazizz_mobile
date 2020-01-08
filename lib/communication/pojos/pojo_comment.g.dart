// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pojo_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoComment _$PojoCommentFromJson(Map<String, dynamic> json) {
  return PojoComment(
    content: json['content'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    creator: json['creator'] == null
        ? null
        : PojoCreator.fromJson(json['creator'] as Map<String, dynamic>),
    hiddenChildren: json['hiddenChildren'] as bool,
    id: json['id'] as int,
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : PojoComment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PojoCommentToJson(PojoComment instance) =>
    <String, dynamic>{
      'content': instance.content,
      'creationDate': instance.creationDate?.toIso8601String(),
      'creator': instance.creator,
      'hiddenChildren': instance.hiddenChildren,
      'id': instance.id,
      'children': instance.children,
    };
