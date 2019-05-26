import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/PojoType.dart';
import 'package:flutter_hazizz/communication/pojos/task/PojoTask.dart';
import 'package:flutter_hazizz/communication/requests/RequestCollection.dart';

import '../RequestSender.dart';

class EditTaskPage extends StatefulWidget {
  // This widget is the root of your application.
  int groupId;

  PojoTask pojoTask;
  int taskId;

  EditTaskPage({Key key, this.taskId}) : super(key: key);

  EditTaskPage.editMode({Key key, this.pojoTask}) : super(key: key){
    taskId = pojoTask.id;
  }

  EditTaskPage.createMode({Key key, this.groupId}) : super(key: key){
  }

  @override
  _EditTaskPage createState() => _EditTaskPage();
}

class _EditTaskPage extends State<EditTaskPage> {

  final TextEditingController _subjectTextEditingController = TextEditingController();
  final TextEditingController _groupTextEditingController = TextEditingController();
  final TextEditingController _creatorTextEditingController = TextEditingController();
  final TextEditingController _taskTypeTextEditingController = TextEditingController();
  final TextEditingController _deadlineTextEditingController = TextEditingController();


  final TextEditingController _descriptionTextEditingController = TextEditingController();
  final TextEditingController _titleTextEditingController = TextEditingController();

  String _subject = "";
  String _group = "";
  String _creator = "";
  String _type = "";
  String _deadline = "";
  String _description = "";
  String _title = "";


  static Color headerColor = Colors.red;
 // headerColor.alpha = 10;
  static Color formColor = Colors.blue;//headerColor.withAlpha(20); //Color.fromRGBO(headerColor.red, headerColor.green, headerColor.blue, 240);


  String _value = "1";

  static List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  static String _color = '';

  static final double padding = 8;

  static final FormField groupFormField = new FormField(
    builder: (FormFieldState state) {
      return InputDecorator(

        decoration: InputDecoration(
          filled: true,
          fillColor: formColor,
          icon: const Icon(Icons.group),
          labelText: 'Group',
        ),
        isEmpty: _color == '',
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _color,
            isDense: true,
            onChanged: (_){},/*(String newValue) {
                                                    setState(() {
                                                      newContact.favoriteColor = newValue;
                                                      _color = newValue;
                                                      state.didChange(newValue);
                                                    });
                                                  },*/
            items: _colors.map((String value) {
              return new DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  static final FormField subjectFormField = new FormField(
    builder: (FormFieldState state) {
      return InputDecorator(

        decoration: InputDecoration(
          filled: true,
          fillColor: formColor,
          icon: const Icon(Icons.subject),
          labelText: 'Subject',
        ),
        isEmpty: _color == '',
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _color,
            isDense: true,
            onChanged: (_){},/*(String newValue) {
                                                    setState(() {
                                                      newContact.favoriteColor = newValue;
                                                      _color = newValue;
                                                      state.didChange(newValue);
                                                    });
                                                  },*/
            items: _colors.map((String value) {
              return new DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  static final FormField deadlineFormField = new FormField(

    builder: (FormFieldState state) {
      return InputDecorator(

        decoration: InputDecoration(
          filled: true,
          fillColor: formColor,
          icon: const Icon(Icons.date_range),
          labelText: 'Deadline',
        ),
        isEmpty: _color == '',
     //   child: Text(""),
      );
    },
  );

  static final ExpansionPanel expansionPanel = new ExpansionPanel(
      headerBuilder: null,
      body: null)
  ;


  static final AppBar appBar = AppBar(
  title: Text("Edit Task"),
  );

  List<PojoTask> task_data = List();

  void processData(PojoTask pojoTask){
    widget.pojoTask = pojoTask;
    setState(() {
      _subject = pojoTask.subject.name;
      _group = pojoTask.group.name;

      _creator = pojoTask.creator.displayName;

      _type = pojoTask.type.name;
      _deadline = pojoTask.dueDate.toString();
      _description = pojoTask.description;
      _title = pojoTask.title;
    });
  }

  // lényegében egy onCreate
  @override
  void initState() {
    getData();
    if(widget.pojoTask != null) {
      processData(widget.pojoTask);
    }

    headerColor = Colors.red;
    // headerColor.alpha = 10;
    formColor = Colors.grey.withAlpha(120);//headerColor.withOpacity(200); //Color.fromRGBO(headerColor.red, headerColor.green, headerColor.blue, 240);


    super.initState();
  }

  void getData() async{
    Response response = await RequestSender().send(new GetTaskByTaskId(
        p_taskId: widget.taskId,
        rh: new ResponseHandler(
            onSuccessful: (Response response) async{
              print("raw response is : ${response.data}" );

              PojoTaskDetailed pojoTask = PojoTaskDetailed.fromJson(jsonDecode(response.data));

              processData(pojoTask);

            },
            onError: (PojoError pojoError){
              print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
            }
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_task_edit",
        child: Scaffold(
           // resizeToAvoidBottomPadding: false,
            appBar: appBar,
            body:SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // valamiért 3* kell megszorozni a paddingot hogy jó legyen
                height: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,

                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Card(
                    elevation: 100,
                      child: new Container(
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: headerColor,
                                    //  width: 400,

                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              new Flexible(
                                                  child: DropdownButton<String>(

                                                    elevation: 50,
                                                 //   iconSize: 40,
                                                    hint: Text("asd"),
                                                    items: [
                                                    DropdownMenuItem(
                                                      value: PojoType.pojoTypes[0].id.toString(),
                                                      child: Align(
                                                        alignment: FractionalOffset.bottomCenter,
                                                        child: Text(

                                                          PojoType.pojoTypes[0].name,
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                    DropdownMenuItem(
                                                      value: PojoType.pojoTypes[1].id.toString(),
                                                      child: Align(
                                                        alignment: FractionalOffset.bottomCenter,
                                                        child: Text(
                                                        "Second",
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                        ),
                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _value = value;
                                                    });
                                                  },
                                                  value: _value,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.only(bottom: 4), child: groupFormField,),
                                            Padding(padding: EdgeInsets.only(bottom: 4), child: subjectFormField,),
                                            Padding(padding: EdgeInsets.only(bottom: 4), child: deadlineFormField,),

                                          ],
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //  flex: 1,
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                      //  crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only( left: 10,top: 5, right: 10),
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                new Flexible(
                                                  child: TextField(
                                                    enableInteractiveSelection: true,
                                                    maxLength: 20,
                                                    decoration: new InputDecoration.collapsed(
                                                        hintText: 'title',
                                                      hasFloatingPlaceholder: true,
                                                       border: OutlineInputBorder(
                                                         gapPadding: 20
                                                       )


                                                    ),
                                                    style: TextStyle(
                                                    fontSize: 30
                                                    ),
                                                  )
                                                )
                                              ],
                                            ),
                                          ),

                                        ]
                                  ),
                                  //  flex: 6,
                                      Padding(
                                        padding: const EdgeInsets.only( left: 20, right: 20, top: 4),
                                        child: TextField(
                                          decoration: new InputDecoration.collapsed(
                                              hintText: 'desctiption',
                                              border: OutlineInputBorder()
                                          ),
                                          maxLength: 240,
                                          maxLines: 10,
                                          minLines: 6,
                                          expands: false,
                                          style: TextStyle(
                                              fontSize: 20

                                          ),
                                        ),
                                      ),

                                  Expanded(
                                    child: Align(
                                        alignment: FractionalOffset.bottomCenter,
                                     child:
                                      MaterialButton(
                                        onPressed: (){

                                        },
                                        child: Text("Submit"),
                                      )
                                    ),
                                  )

                                ]
                            ),
                          ),
                    )
                  ),
              ),
            ),
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

/*new Flexible(
                    child: new Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      child: new TextField(
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ),*/


/*new Flexible(
                    child: new Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      child: new TextField(
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ),*/