

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/ResponseHandler.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:hazizz_mobile/converters/PojoConverter.dart';


import '../RequestSender.dart';
import '../hazizz_theme.dart';

Future<List<PojoGroup>> _getGroupData()async{
  List<PojoGroup> data;
  Response response = await RequestSender().send(new GetMyGroups(
    rh: new ResponseHandler(
        onSuccessful: (dynamic data) async{
          data = data;          },
        onError: (PojoError pojoError){
          print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
        }
    ),
  ));
  return data;
}
void showDialogGroup(BuildContext context, Function(PojoGroup) onPicked, {List<PojoGroup> data}) async{
 // List<PojoGroup> data;
  List<PojoGroup> groups_data;
  if(data == null) {
    groups_data = await _getGroupData();
  }else{
    groups_data = data;
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
void showDialogSubject(BuildContext context, Function(PojoSubject) onPicked, {int groupId, List<PojoSubject> data}) async{
  List<PojoSubject> subjects_data;
  if(groupId != null) {
    subjects_data = await _getSubjectData(groupId);
  }else{
    subjects_data = data;
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


void showDialogTaskType(BuildContext context, Function(PojoType) onPicked) async{
  List<PojoType> data = PojoType.pojoTypes;

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
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                  onTap: (){
                    onPicked(data[index]);
                    Navigator.of(context).pop();

                  },
                  child: Text(data[index].name,
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

Future<bool> showDeleteDialog(context, {@required int taskId}) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 130.0,
                width: 200.0,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        // Container(height: 100.0),
                        Container(
                          height: 80.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: HazizzTheme.warningColor),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Are you sure you want to delete this task?",
                            style: TextStyle(

                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),

                      ],
                    ),
                    //  SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Center(
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: Colors.teal),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.transparent
                        ),
                        FlatButton(
                          child: Center(
                            child: Text(
                              'DELETE',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  color: HazizzTheme.warningColor),
                            ),
                          ),
                          onPressed: () async {

                            Response response = await RequestSender().getResponse(DeleteTask(taskId: taskId));
                            if(response.statusCode == 200){
                              Navigator.of(context).pop();
                            }

                            Navigator.of(context).pop();
                          },
                          color: Colors.transparent
                        ),
                      ],
                    )
                  ],
                )));
      });
}

Future<bool> showAddSubjectDialog(context, {@required int groupId}) {
  TextEditingController _subjectTextEditingController = TextEditingController();
  String errorText = null;
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 130.0,
                width: 200.0,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        // Container(height: 100.0),
                        Container(
                          height: 80.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Theme.of(context).primaryColor
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextField(
                            autofocus: true,
                            onChanged: (dynamic text) {
                              print("change: $text");
                            },
                            controller: _subjectTextEditingController,
                            textInputAction: TextInputAction.send,
                            decoration:
                            InputDecoration(labelText: "Subject", errorText: errorText),
                          )
                        ),

                      ],
                    ),
                    //  SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                            child: Center(
                              child: Text(
                                'CANCEL',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.teal),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.transparent
                        ),
                        FlatButton(
                            child: Center(
                              child: Text(
                                'ADD',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: HazizzTheme.warningColor
                                ),
                              ),
                            ),
                            onPressed: () async {
                              /*
                              Response response = await RequestSender().getResponse(DeleteTask(taskId: taskId));
                              if(response.statusCode == 200){
                                Navigator.of(context).pop();
                              }
                              */

                              Navigator.of(context).pop();
                            },
                            color: Colors.transparent
                        ),
                      ],
                    )
                  ],
                )));
      });
}


//TODO a good lookin dialog this is
/*Future<bool> showReview(context, review) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 150.0),
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.teal),
                        ),
                        Positioned(
                            top: 50.0,
                            left: 94.0,
                            child: Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                  image: DecorationImage(
                                      image:
                                      NetworkImage(review['reviewerPic']),
                                      fit: BoxFit.cover)),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          review['reviewMade'],
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    SizedBox(height: 15.0),
                    FlatButton(
                        child: Center(
                          child: Text(
                            'OKAY',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: Colors.teal),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.transparent
                    )
                  ],
                )));
      });
} */



