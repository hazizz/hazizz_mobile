// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoKretaNote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoKretaNote _$PojoKretaNoteFromJson(Map<String, dynamic> json) {
  return PojoKretaNote(
    type: json['type'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    teacher: json['teacher'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
  );
}

Map<String, dynamic> _$PojoKretaNoteToJson(PojoKretaNote instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'teacher': instance.teacher,
      'creationDate': instance.creationDate?.toIso8601String(),
    };
