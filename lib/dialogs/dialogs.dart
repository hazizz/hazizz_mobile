


import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoType.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/school_dialog.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';


import '../request_sender.dart';
import '../hazizz_date.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';
import '../hazizz_theme.dart';



class HazizzDialog extends Dialog{

  static final double buttonBarHeight = 50.0;

  Container header, content;

  Row actionButtons;

  double height, width;

  HazizzDialog({this.header, this.content, this.actionButtons,@required this.height,@required this.width}){
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
            height: height + buttonBarHeight,
            width: width,
            decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: <Widget>[
                Container(
                  //  height: 64.0,
                  width: width*2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                   //   color: Theme.of(context).primaryColor
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      child: Center(child: header),
                  ),
                ),

                Builder(
                    builder: (BuildContext context){
                      if(content != null){
                        return content;
                      }
                      return Container();
                    }
                ),
                Spacer(),

                //  SizedBox(height: 20.0),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    actionButtons,
                  ],
                )
              ],
            )
    ));
  }
}

























void showDialogGroup(BuildContext context, Function(PojoGroup) onPicked, {List<PojoGroup> data}) async{
 // List<PojoGroup> data;
  List<PojoGroup> groups_data;
  if(data == null) {
    HazizzResponse response = await RequestSender().getResponse(new GetMyGroups());

    if(response.isSuccessful){
      groups_data = response.convertedData;
    }
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


void showDialogSubject(BuildContext context, Function(PojoSubject) onPicked, {int groupId, List<PojoSubject> data}) async{
  List<PojoSubject> subjects_data;
  if(groupId != null) {

    HazizzResponse response = await RequestSender().getResponse(new GetSubjects(groupId: groupId));

    if(response.isSuccessful){
      subjects_data = response.convertedData;
    }
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

Future<bool> showDeleteDialog(context, {@required int taskId}) async {

  double height = 80;
  double width = 200;

  bool success = false;

  bool pressed = false;

  HazizzDialog hazizzDialog = new HazizzDialog(
      header:
      Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            color: HazizzTheme.warningColor),
        child: Padding(
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
      ),
      content:
      Container(),
      actionButtons:
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
                if(!pressed) {
                  pressed = true;
                  HazizzResponse response = await RequestSender().getResponse(
                      DeleteTask(taskId: taskId));
                  if(response.isSuccessful) {
                    success = true;
                  }
                  Navigator.of(context).pop();
                  pressed = false;
                }
              },
              color: Colors.transparent
          ),
        ],
      )
      ,height: height,width: width);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return hazizzDialog;
    }
  );
  return success;


  /*
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

                            HazizzResponse response = await RequestSender().getResponse(DeleteTask(taskId: taskId));
                            if(response.isSuccessful){
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
  */
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


Future<void> showGradeDialog(context, {@required PojoGrade grade}) {
  Widget space = SizedBox(height: 5);

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        print("grade: ${grade.grade}");

        /*
        Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                width: 1000,
                height: 310.0,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        // Container(height: 100.0),
                        Container(
                          height: 64.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Theme.of(context).primaryColor
                          ),
                        ),
                        Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircleAvatar(
                                child: Column(
                                    children: [
                                      Text(
                                        grade.grade == null ? "" : grade.grade,
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black
                                        ),
                                      ),
                                      Text(
                                        grade.weight == null ? "100%" : "${grade.weight}%",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black
                                        ),
                                      ),
                                    ]
                                ),
                                backgroundColor: grade.color,
                                radius: 40,
                              )
                          ),
                        ),

                      ],
                    ),
                    //  SizedBox(height: 20.0),

                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                          children:
                          [

                            Center(child: Text(grade.subject == null ? "" : (grade.subject), style: TextStyle(fontSize: 20)) ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("topic: ", style: TextStyle(fontSize: 20)),
                                Text(grade.topic == null ? "" : (grade.topic), style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            space,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: <Widget>[
                                Text("grade type: ", style: TextStyle(fontSize: 20)),
                                Text(grade.gradeType == null ? "" : grade.gradeType, style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("date: ", style: TextStyle(fontSize: 20),),
                                Text(grade.date == null ? "" : hazizzShowDateFormat(grade.date), style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[

                              ],
                            ),
                          ]
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FlatButton(
                                child: Center(
                                  child: Text('OK',
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
                          ),
                        ]
                    ),
                  ],
                )));
        */

         return HazizzDialog(
            header: Container(
              color: Theme.of(context).dialogBackgroundColor,
              height: 98,
              child: Stack(
                children: <Widget>[
                 //  Container(color: Theme.of(context).dialogBackgroundColor,),
                  Container(
                    height: 62.0,
                      color: Theme.of(context).primaryColor

                    //  width: 50,
                      /*
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Theme.of(context).primaryColor
                    ),
                    */
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 4),
                        child: CircleAvatar(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  grade.grade == null ? "5" : grade.grade,
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white
                                  ),
                                ),

                                Text(
                                  grade.weight == null ? "100%" : "${grade.weight}%",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                  ),
                                ),

                              ]
                          ),
                          backgroundColor: grade.color,
                          radius: 50,
                        )
                    ),
                  ),
                ],
              ),
            ),
            content: Container(child:  Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  children:
                  [

                    Center(child: Text(grade.subject == null ? "" : (grade.subject), style: TextStyle(fontSize: 20)) ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("topic: ", style: TextStyle(fontSize: 20)),
                        Text(grade.topic == null ? "" : (grade.topic), style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    space,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        Text("grade type: ", style: TextStyle(fontSize: 20)),
                        Text(grade.gradeType == null ? "" : grade.gradeType, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    space,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("date: ", style: TextStyle(fontSize: 20),),
                        Text(grade.date == null ? "" : hazizzShowDateFormat(grade.date), style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    space,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                      ],
                    ),
                  ]
              ),
            ),),
            actionButtons: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FlatButton(
                        child: Center(
                          child: Text('OK',
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
                  ),
                ]
            ),
            height: 220,
            width: 200);


        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                width: 1000,
                height: 310.0,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        // Container(height: 100.0),
                        Container(
                          height: 64.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Theme.of(context).primaryColor
                          ),
                        ),
                        Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircleAvatar(
                                child: Column(
                                  children: [
                                    Text(
                                      grade.grade == null ? "" : grade.grade,
                                      style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.black
                                      ),
                                    ),
                                    Text(
                                      grade.weight == null ? "100%" : "${grade.weight}%",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black
                                      ),
                                    ),
                                  ]
                                ),
                                backgroundColor: grade.color,
                                radius: 40,
                              )
                          ),
                        ),

                      ],
                    ),
                    //  SizedBox(height: 20.0),

                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children:
                        [

                          Center(child: Text(grade.subject == null ? "" : (grade.subject), style: TextStyle(fontSize: 20)) ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("topic: ", style: TextStyle(fontSize: 20)),
                              Text(grade.topic == null ? "" : (grade.topic), style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          space,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Text("grade type: ", style: TextStyle(fontSize: 20)),
                              Text(grade.gradeType == null ? "" : grade.gradeType, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          space,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("date: ", style: TextStyle(fontSize: 20),),
                              Text(grade.date == null ? "" : hazizzShowDateFormat(grade.date), style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          space,
                          Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                          ],
                        ),
                        ]
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FlatButton(
                            child: Center(
                              child: Text('OK',
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
                        ),
                      ]
                    ),
                  ],
                )));
      });
}

Future<bool> showInviteDialog(context, {@required int groupId}) async {
  HazizzResponse hazizzResponse = await RequestSender().getResponse(GetGroupInviteLink(groupId: groupId));
  String inviteLink = "Waiting...";
  if(hazizzResponse.isSuccessful){
    inviteLink = hazizzResponse.convertedData;
  }else{
    return false;
  }

  HazizzDialog h = HazizzDialog(
    header:
      Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(inviteLink),
          )
      ),
      content: Container(),
      actionButtons:
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
              'SHARE',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  color: HazizzTheme.warningColor
              ),
            ),
          ),
          onPressed: () {
            print("share");

            Share.share('check out my website $inviteLink');
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
          color: Colors.transparent
      ),
    ],
  ) ,height: 130,width: 200);

  return showDialog(context: context, barrierDismissible: true,
      builder: (BuildContext context) {
        return h;
      }
  );

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
                            child: Text(inviteLink)
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
                                'SHARE',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: HazizzTheme.warningColor
                                ),
                              ),
                            ),
                            onPressed: () {
                              print("share");

                              Share.share('check out my website $inviteLink');
                             // Navigator.of(context).pop();
                             // Navigator.of(context).pop();
                            },
                            color: Colors.transparent
                        ),
                      ],
                    )
                  ],
                )));
      });
}



void showSchoolsDialog(BuildContext context, {@required Function({String key, String value}) onPicked, @required Map data}) async{
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return SchoolDialog(onPicked: onPicked, data: data);
    },
  );
}

Future<void> showClassDialog(context, {@required PojoClass pojoClass}) {
  Widget space = SizedBox(height: 5);

  HazizzDialog hazizzDialog = HazizzDialog(
    header:
    Container(
      color: Theme.of(context).primaryColor,
      child: Row(children: <Widget>[
        Container(
          color: Theme.of(context).primaryColorDark,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 2),
            child: Text("${pojoClass.periodNumber}.", style: TextStyle(fontSize: 40)),
          )
        ),
        Expanded(
          child: Container(

            child: AutoSizeText("${pojoClass.className}",
              style: TextStyle(fontSize: 40),
              maxLines: 1,
              maxFontSize: 40,
              minFontSize: 20,
            ),
          ),
        )
      ],),
    ),
    content:
    Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Builder(builder: (BuildContext context){

          List<Widget> rows = List();

          void addToColumn(Widget widget){
            if(rows.length != 0){
             // rows.add(Spacer());
            }
            rows.add(widget);
          }

          addToColumn(Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Text(hazizzTimeOfDayToShow(pojoClass.startOfClass), style: TextStyle(fontSize: 22)),
              Text("-", style: TextStyle(fontSize: 22)),
              Text(hazizzTimeOfDayToShow(pojoClass.startOfClass), style: TextStyle(fontSize: 22)),
            ],
          ));
          addToColumn(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("subject: ", style: TextStyle(fontSize: 20)),
              Expanded(
                  child: Text(pojoClass.subject == null ? "" : (pojoClass.subject),
                      style: TextStyle(fontSize: 20))),
            ],
          ));
          addToColumn(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Text("class: ", style: TextStyle(fontSize: 20)),
              Expanded(child: Text(pojoClass.room == null ? "" : pojoClass.room, style: TextStyle(fontSize: 20))),
            ],
          ),);
          addToColumn(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Text("teacher: ", style: TextStyle(fontSize: 20)),
              Expanded(child: Text(pojoClass.teacher == null ? "" : pojoClass.teacher, style: TextStyle(fontSize: 20))),
            ],
          ),);
          addToColumn(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Text("room: ", style: TextStyle(fontSize: 20)),
              Expanded(child: Text(pojoClass.room == null ? "" : pojoClass.room, style: TextStyle(fontSize: 20))),
            ],
          ),);


          if(pojoClass.topic != null){
            addToColumn(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Text("topic: ", style: TextStyle(fontSize: 20)),
                Expanded(child: Text(pojoClass.topic, style: TextStyle(fontSize: 20))),
              ],
            ));
          }
          if(pojoClass.cancelled != null){
            addToColumn(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Text("${locText(context, key: "thera_canceled")}:", style: TextStyle(fontSize: 20)),
              ],
            ));
          }
          if(pojoClass.standIn != null){
            addToColumn(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Text("${locText(context, key: "thera_standin")}:", style: TextStyle(fontSize: 20)),
              ],
            ));
          }

          return Column(children: rows,);


        }
        )
      ),
    ),
      actionButtons:
      Row(
        children: <Widget>[
          FlatButton(
            child: Text("CLOSE"),
            onPressed: (){
              Navigator.pop(context) ;
            },
          )
        ],
      ),
      height: 230, width: 300);

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return hazizzDialog;
      });
}


Future<bool> showClassDialo2g(context, {@required PojoClass pojoClass}) async {
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
                            child: Column(
                              children: <Widget>[
                                Text(pojoClass.periodNumber.toString()),
                                Text(pojoClass.className)
                              ],
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
                                'SHARE',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: HazizzTheme.warningColor
                                ),
                              ),
                            ),
                            onPressed: () {
                              print("share");

                              Share.share('check out my website inviteLink');
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
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



