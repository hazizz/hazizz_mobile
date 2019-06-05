import 'package:dio/dio.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/task/PojoTask.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
import 'package:flutter_hazizz/converters/PojoConverter.dart';
import 'package:rxdart/rxdart.dart';

import '../RequestSender.dart';

/*
class TasksBloc {
  final BehaviorSubject<List<PojoTask>> _subject_myTasks = BehaviorSubject<List<PojoTask>>();

  void fetchMyTasks() async {
    Response response = await RequestSender().send(new GetTasksFromMe(
        rh: new ResponseHandler(
          onSuccessful: (Response response) async{
            print("raw response is : ${response.data}" );
            Iterable iter = getIterable(response.data);
            List<PojoTask> _myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
            _myTasks.sort();
            _subject_myTasks.sink.add(_myTasks);
          },
          onError: (PojoError pojoError){
            print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
          }
        )
      )
    );
  }

  dispose() {
    _subject_myTasks.close();
  }

  BehaviorSubject<List<PojoTask>> get subject => _subject_myTasks;
}

final tasksBloc = TasksBloc();

class TaskBloc {
  final BehaviorSubject<List<PojoTask>> _subject_task = BehaviorSubject<List<PojoTask>>();

  void fetchTask() async {
    Response response = await RequestSender().send(new GetTasksFromMe(
        rh: new ResponseHandler(
            onSuccessful: (Response response) async{
              print("raw response is : ${response.data}" );
              Iterable iter = getIterable(response.data);
              List<PojoTask> _myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
              _myTasks.sort();
              _subject_task.sink.add(_myTasks);
            },
            onError: (PojoError pojoError){
              print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
            }
        )));
  }

  dispose() {
    _subject_task.close();
  }

  BehaviorSubject<List<PojoTask>> get subject => _subject_task;
}

*/