// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoTask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PojoTask _$PojoTaskFromJson(Map<String, dynamic> json) {

  print("piskota00000: ${json["group"] }");
  return PojoTask(
      id: json['id'] as int,
      assignation: json['assignation'] == null
          ? null
          : PojoAssignation.fromJson(
          json['assignation'] as Map<String, dynamic>),
      tags: (json['tags'] as List)
          ?.map((e) => e == null ? null : PojoTag(name: e))?.toList(),
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      creator: json['creator'] == null
          ? null
          : PojoCreator.fromJson(json['creator'] as Map<String, dynamic>),
      group: json['group'] == null
          ? null
          : PojoGroup.fromJson(json['group'] as Map<String, dynamic>),
      subject: json['subject'] == null
          ? null
          : PojoSubject.fromJson(json['subject'] as Map<String, dynamic>),
      completed: json['completed'] as bool);
}

Map<String, dynamic> _$PojoTaskToJson(PojoTask instance) => <String, dynamic>{
  'id': instance.id,
  'assignation': instance.assignation,
  'tags': instance.tags.map((e) => e == null ? null : e.name)?.toList(),
  'title': instance.title,
  'description': instance.description,
  'dueDate': instance.dueDate?.toIso8601String(),
  'creator': instance.creator,
  'group': instance.group,
  'subject': instance.subject,
  'completed': instance.completed
};

PojoTaskDetailed _$PojoTaskDetailedFromJson(Map<String, dynamic> json) {
  return PojoTaskDetailed(
      id: json['id'] as int,
      assignation: json['assignation'] == null
          ? null
          : PojoAssignation.fromJson(
          json['assignation'] as Map<String, dynamic>),
      tags: (json['tags'] as List)
          ?.map((e) => e == null ? null : PojoTag(name: e))?.toList(),
      title: json['title'] as String,
      description: json['description'] as String,
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      creator: json['creator'] == null
          ? null
          : PojoCreator.fromJson(json['creator'] as Map<String, dynamic>),
      group: json['group'] == null
          ? null
          : PojoGroup.fromJson(json['group'] as Map<String, dynamic>),
      subject: json['subject'] == null
          ? null
          : PojoSubject.fromJson(json['subject'] as Map<String, dynamic>))
    ..completed =json['completed'] as bool;
}

Map<String, dynamic> _$PojoTaskDetailedToJson(PojoTaskDetailed instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'id': instance.id,
      'assignation': instance.assignation,
      'tags': instance.tags,
      'title': instance.title,
      'description': instance.description,
      'creationDate': instance.creationDate?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'creator': instance.creator,
      'group': instance.group,
      'subject': instance.subject
    };