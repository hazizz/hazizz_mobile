

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/PojoGroup.dart';
import 'package:flutter_hazizz/communication/pojos/PojoSubject.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
import 'package:flutter_hazizz/converters/PojoConverter.dart';

import '../RequestSender.dart';

Future<List<PojoGroup>> _getGroupData()async{
  List<PojoGroup> myGroups_data;
  Response response = await RequestSender().send(new GetMyGroups(
    rh: new ResponseHandler(
        onSuccessful: (dynamic data) async{
          myGroups_data = data;          },
        onError: (PojoError pojoError){
          print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
        }
    ),
  ));
  return myGroups_data;
}
void showDialogGroup(BuildContext context, Function(PojoGroup) onPicked, {List<PojoGroup> myGroups_data}) async{
 // List<PojoGroup> myGroups_data;
  List<PojoGroup> groups_data;
  if(myGroups_data == null) {
    groups_data = await _getGroupData();
  }else{
    groups_data = myGroups_data;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
       // title: new Text("Alert Dialog title"),
        content: Container(
          height: 800,
          width: 800,
          child: ListView.builder(
              itemCount: groups_data.length,
              itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      onPicked(groups_data[index]);

                    },
                    child: Text(groups_data[index].name,
                      style: TextStyle(
                        fontSize: 26
                      ),
                    )

                  );
                },
          ),
        ),

        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<List<PojoSubject>> _getSubjectData(int groupId)async{
  List<PojoSubject> subjects_data;
  Response response = await RequestSender().send(new GetSubjects(
      rh: new ResponseHandler(
          onSuccessful: (dynamic data) async{
            subjects_data = data;
          },
          onError: (PojoError pojoError){
            print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
          }
      ),
      groupId: groupId
  ));
  return subjects_data;
}
void showDialogSubject(BuildContext context, Function(PojoSubject) onPicked, {int groupId, List<PojoSubject> subjects}) async{
  List<PojoSubject> subjects_data;
  if(groupId != null) {
    subjects_data = await _getSubjectData(groupId);
  }else{
    subjects_data = subjects;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        // title: new Text("Alert Dialog title"),
        content: Container(
          height: 800,
          width: 800,
          child: ListView.builder(
            itemCount: subjects_data.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                  onTap: (){
                    onPicked(subjects_data[index]);
                    Navigator.of(context).pop();

                  },
                  child: Text(subjects_data[index].name,
                    style: TextStyle(
                        fontSize: 26
                    ),
                  )
              );
            },
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



