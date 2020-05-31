import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/Pojo.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'app_state_restorer.g.dart';


@JsonSerializable()
class TaskMakerAppState implements Pojo{
  final PojoTask pojoTask;
  final TaskMakerMode taskMakerMode;
  final List<String> imagePaths;

  TaskMakerAppState({@required this.pojoTask, @required this.taskMakerMode, this.imagePaths});

  @override
  factory TaskMakerAppState.fromJson(Map<String, dynamic> json) =>
      _$TaskMakerAppStateFromJson(json);

  Map<String, dynamic> toJson() => _$TaskMakerAppStateToJson(this);

}

class AppStateRestorer{

  static const String _key_task_state = "_key_task_state";
  static const String _key_task_state_should_reload = "_key_task_state_should_reload";

  static Future<void> saveTaskState(TaskMakerAppState taskMakerAppState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setShouldReloadTaskMaker(true);
    await prefs.setString(_key_task_state, jsonEncode(taskMakerAppState));
  }
  static Future<TaskMakerAppState> loadTaskState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedTaskMakerAppState = prefs.getString(_key_task_state);
    setShouldReloadTaskMaker(false);
    if(encodedTaskMakerAppState == null) return null;
    return TaskMakerAppState.fromJson(jsonDecode(encodedTaskMakerAppState));
  }
  static Future<bool> getShouldReloadTaskMaker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key_task_state_should_reload) ?? false;
  }

  static Future setShouldReloadTaskMaker(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key_task_state_should_reload, value);
  }

}