import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/task/PojoTask.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
import 'package:flutter_hazizz/converters/PojoConverter.dart';
import 'package:flutter_hazizz/listItems/TaskHeaderItemWidget.dart';
import 'package:flutter_hazizz/listItems/TaskItemWidget.dart';

import 'package:sticky_headers/sticky_headers.dart';

import '../RequestSender.dart';

class TaskPage extends StatefulWidget {
  // This widget is the root of your application.
  TaskPage({Key key}) : super(key: key);

  @override
  _TaskPage createState() => _TaskPage();
}

class _TaskPage extends State<TaskPage> with SingleTickerProviderStateMixin{

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final HashedTextEditingController _passwordTextEditingController = HashedTextEditingController();

  List<PojoTask> task_data = List();

  // lényegében egy onCreate
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async{
    Response response = await RequestSender().send(new GetTasksFromMe(
      rh: new ResponseHandler(
        onSuccessful: (Response response) async{
          print("raw response is : ${response.data}" );
          this.setState((){
            Iterable iter = getIterable(response.data);
           // Iterable parsed = jsonDecode(response.data).cast<Map<String, dynamic>>();
            task_data =  iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
            task_data.sort();
          });
        },
        onError: (PojoError pojoError){
          print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
        }
      )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:new RefreshIndicator(
        child:new ListView.builder(
          itemCount: task_data.length,
          itemBuilder: (BuildContext context, int index){

            if(index == 0 || task_data[index].dueDate.difference(task_data[index-1].dueDate).inDays > 0){
              return new StickyHeader(
                header: TaskHeaderItemWidget(dateTime: task_data[index].dueDate),
                content: TaskItemWidget(pojoTask: task_data[index],
                  /*
                  subject: task_data[index].subject == null ? null : task_data[index].subject.name,
                  title: task_data[index].title,
                  desription: task_data[index].description,
                  creatorName: task_data[index].creator.displayName,
                  */
                ),
              );
            }else{
              return
                TaskItemWidget(pojoTask: task_data[index],
              );
            }
          }
        ),
        onRefresh: ()async => await getData()
      )
    );
  }

  Future<Null> _handleRefresh() async{
    await getData();

    var now = new DateTime.now();
    var berlinWallFell = new DateTime.utc(1989, 11, 9);
    var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");  // 8:18pm



  }
}
