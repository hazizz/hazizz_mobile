import 'package:json_annotation/json_annotation.dart';

import '../Pojo.dart';
import '../PojoAssignation.dart';
import '../PojoCreator.dart';
import '../PojoGroup.dart';
import '../PojoSubject.dart';
import '../PojoType.dart';

part 'PojoTask.g.dart';

@JsonSerializable()
class PojoTask extends Pojo implements Comparable<PojoTask>{
  PojoTask({this.id, this.assignation, this.type, this.title, this.description,
    this.dueDate, this.creator, this.group, this.subject});

  int id;
  PojoAssignation assignation;
  PojoType type;
  String title;
  String description;
  DateTime dueDate;
  PojoCreator creator;
  PojoGroup group;
  PojoSubject subject;

  factory PojoTask.fromJson(Map<String, dynamic> json) =>
      _$PojoTaskFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTaskToJson(this);

  @override
  int compareTo(PojoTask other) {
    // TODO: implement compareTo
    int order = dueDate.compareTo(other.dueDate);
    return order;
  }
}

@JsonSerializable()
class PojoTaskDetailed extends PojoTask{// implements Comparable<PojoTaskDetailed>{
  PojoTaskDetailed({this.id, this.assignation, this.type, this.title, this.description,
  this.creationDate, this.lastUpdated, this.dueDate, this.creator, this.group, this.subject});

  int id;
  PojoAssignation assignation;
  PojoType type;
  String title;
  String description;
  DateTime creationDate; //: "2019-05-21T09:23:49+0000",
  DateTime lastUpdated; // "2019-05-21T09:23:49+0000",
  DateTime dueDate;
  PojoCreator creator;
  PojoGroup group;
  PojoSubject subject;

  factory PojoTaskDetailed.fromJson(Map<String, dynamic> json) =>
      _$PojoTaskDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTaskDetailedToJson(this);

  @override
  int compareTo(PojoTask other) {
    // TODO: implement compareTo
    int order = dueDate.compareTo(other.dueDate);
    return order;
  }
}