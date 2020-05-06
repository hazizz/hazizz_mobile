import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/group_permissions_enum.dart';

import '../Pojo.dart';
import '../PojoAssignation.dart';
import '../PojoCreator.dart';
import '../PojoGroup.dart';
import '../PojoSubject.dart';
import '../PojoTag.dart';

part 'PojoTask.gg.dart';

//@JsonSerializable()
class PojoTask extends Pojo implements Comparable<PojoTask>{
  PojoTask({this.id, this.assignation, this.tags, this.title, this.description,
    this.dueDate, this.salt, this.creator, this.group, this.subject, this.completed, this.permission});

  int id;
  PojoAssignation assignation;
  List<PojoTag> tags;
  String title;
  String description;
  DateTime dueDate;
  String salt;
  PojoCreator creator;
  PojoGroup group;
  PojoSubject subject;
  bool completed;
  GroupPermissionsEnum permission;

  factory PojoTask.fromJson(Map<String, dynamic> json) =>
      _$PojoTaskFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTaskToJson(this);

  @override
  int compareTo(PojoTask other) {
    int order = dueDate.compareTo(other.dueDate);
    return order;
  }

  PojoTask copy(){
    return PojoTask(id: this.id, assignation: this.assignation, tags: this.tags, title: this.title, description: this.description,
       dueDate: this.dueDate, salt: this.salt, creator: this.creator, group: this.group, subject: this.subject, completed: this.completed, permission: this.permission);
  }


}

//@JsonSerializable()
class PojoTaskDetailed extends PojoTask{// implements Comparable<PojoTaskDetailed>{
  PojoTaskDetailed({this.id, this.assignation, this.tags, this.title, this.description,
  this.creationDate, this.lastUpdated, this.dueDate, this.salt, this.creator, this.group, this.subject, this.completed, this.permission});

  int id;
  PojoAssignation assignation;
  List<PojoTag> tags;
  String title;
  String description;
  DateTime creationDate; //: "2019-05-21T09:23:49+0000",
  DateTime lastUpdated; // "2019-05-21T09:23:49+0000",
  DateTime dueDate;
  String salt;
  PojoCreator creator;
  PojoGroup group;
  PojoSubject subject;
  bool completed;
  GroupPermissionsEnum permission;

  factory PojoTaskDetailed.fromJson(Map<String, dynamic> json) =>
      _$PojoTaskDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTaskDetailedToJson(this);

  @override
  int compareTo(PojoTask other) {
    int order = dueDate.compareTo(other.dueDate);
    return order;
  }
}