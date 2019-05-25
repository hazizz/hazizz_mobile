import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
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

  String _value = "1";

  static final double padding = 8;

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
                                    color: Colors.grey,
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
                                                    iconSize: 40,
                                                    hint: Text("asd"),
                                                    items: [
                                                    DropdownMenuItem(
                                                      value: "1",
                                                      child: Align(
                                                        alignment: FractionalOffset.bottomCenter,
                                                        child: Text(

                                                        "First",
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                    DropdownMenuItem(
                                                      value: "2",
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
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),                              child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            new Flexible(
                                                child: Text(_creator,
                                                  style: TextStyle(
                                                      fontSize: 18
                                                  ),)
                                            ),
                                          ],
                                        ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              new Flexible(
                                                  child: Text("2019.01.01",
                                                    style: TextStyle(
                                                        fontSize: 18
                                                    ),)
                                              ),
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