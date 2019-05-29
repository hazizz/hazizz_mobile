import 'package:dio/dio.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/task/PojoTask.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
import 'package:flutter_hazizz/converters/PojoConverter.dart';
import 'package:rxdart/rxdart.dart';

import '../../RequestSender.dart';

abstract class RequestBloc {
 // final BehaviorSubject<List<PojoTask>> _subject_myTasks = BehaviorSubject<List<PojoTask>>();
  BehaviorSubject _subject;
  ResponseHandler rh;
  Request request;

  void fetch() async {
   // Response response = await RequestSender().send(new GetTasksFromMe(rh: rh));
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject get subject => _subject;
}


class MyTasksBloc extends RequestBloc{
  MyTasksBloc(ResponseHandler rh) {
    _subject = BehaviorSubject<List<PojoTask>>();
    this.rh = rh;
    rh.addToBlocFunc((dynamic data){
      _subject.sink.add(data);
    });
    this.request = new GetTasksFromMe(rh: rh);
  }

  @override
  void fetch() {
    sendRequest(request);
    super.fetch();
  }

  void fetchMyTasks(ResponseHandler rh) async {
    Response response = await RequestSender().send(new GetTasksFromMe(rh: rh));
  }

}