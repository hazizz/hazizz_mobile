import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:hazizz_mobile/blocs/VariableBloc.dart';
import 'package:hazizz_mobile/blocs/date_time_picker_bloc.dart';
import 'package:hazizz_mobile/blocs/edit_task_bloc2.dart';
import 'package:hazizz_mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:hazizz_mobile/blocs/item_list_picker_bloc/item_list_picker_group_bloc.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:expandable/expandable.dart';
import 'package:hazizz_mobile/dialogs/dialogs.dart';
=======
import 'package:flutter_hazizz/blocs/VariableBloc.dart';
import 'package:flutter_hazizz/blocs/date_time_picker_bloc.dart';
import 'package:flutter_hazizz/blocs/edit_task_bloc2.dart';
import 'package:flutter_hazizz/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:flutter_hazizz/blocs/item_list_picker_bloc/item_list_picker_group_bloc.dart';
import 'package:flutter_hazizz/communication/pojos/PojoGroup.dart';
import 'package:flutter_hazizz/communication/pojos/PojoSubject.dart';
import 'package:flutter_hazizz/communication/pojos/PojoType.dart';
import 'package:flutter_hazizz/communication/pojos/task/PojoTask.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter_hazizz/dialogs/dialogs.dart';
>>>>>>> 697a6e3b071e12017449a7ca76eb8a9feb3f5ba0

class EditTaskPage extends StatefulWidget {
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

  ItemListPickerGroupBloc itemListPickerGroupBloc = ItemListPickerGroupBloc();

  final TextEditingController _descriptionTextEditingController = TextEditingController();
  final TextEditingController _titleTextEditingController = TextEditingController();


  static Color headerColor = Colors.red;

  static Color homeworkColor = Colors.green;
  static Color testColor = Colors.red;
  static Color oralTestColor = Colors.purple;
  static Color assignmentColor = Colors.yellow;

  static Color formColor = Colors.blue;

  static String _color = '';

  static final double padding = 8;

  static bool _isExpanded = false;

  EditTaskBlocs blocs;

  static PojoSubject chosenSubject;

  FormField groupFormField;

  ExpandableController expandableController = new ExpandableController(true);

  static final AppBar appBar = AppBar(
  title: Text("Edit Task"),
  );

  List<PojoTask> task_data = List();
  List<PojoSubject> subjects_data = List();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void processData(PojoTask pojoTask){
   // expandablePanel.c
    widget.pojoTask = pojoTask;
    setState(() {
      /*
      _subject = pojoTask.subject.name;
      _group = pojoTask.group.name;

      _creator = pojoTask.creator.displayName;

      _type = pojoTask.type.name;
      _deadline = pojoTask.dueDate.toString();
      _description = pojoTask.description;
      _title = pojoTask.title;
      */
    });
  }

  @override
  void initState() {
    blocs = new EditTaskBlocs();

    blocs.groupItemPickerBloc.dispatch(LoadData());

    if(widget.pojoTask != null) {
      processData(widget.pojoTask);
    }
    headerColor = Colors.yellow;
    formColor = Colors.grey.withAlpha(120);

    super.initState();
  }

  @override
  void dispose() {
    blocs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var taskTypePicker = BlocBuilder(
        bloc: blocs.taskTypePickerBloc,
        builder: (BuildContext context, TaskTypePickerState state) {
          return GestureDetector(
            child: FormField(
              builder: (FormFieldState formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: formColor,
                      labelText: 'Type',
                    ),
                    isEmpty: _color == '',
                    child: Builder(
                      builder: (BuildContext context){//, ItemListState state) {
                        String typeName = "error lol123";
                        if(state is TaskTypePickedState) {
                          if (state.item.id == 1) {
                            headerColor = homeworkColor;
                            typeName = "Homework";
                          }
                          else if (state.item.id == 2) {
                            headerColor = assignmentColor;
                            typeName = "Assignment";
                          }
                          else if (state.item.id == 3) {
                            headerColor = testColor;
                            typeName = "Test";
                          }
                          else if (state.item.id == 4) {
                            headerColor = oralTestColor;
                            typeName = "Oral test";
                          }
                        }

                        return Center(
                          child: Text('${typeName}',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        );
                      },
                    )
                );
              },
            ),
            onTap: () {
              showDialogTaskType(context, (PojoType type) {
                blocs.taskTypePickerBloc.dispatch(TaskTypePickedEvent(type));
              }
              );
            },
          );
        }
    );
    var groupPicker = BlocBuilder(
      bloc: blocs.groupItemPickerBloc,
      builder: (BuildContext context, ItemListState state) {
        print("log: widget update111");
        return GestureDetector(
          child: FormField(
            builder: (FormFieldState formState) {
              return InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: formColor,
                    icon: const Icon(Icons.group),
                    labelText: 'Group',
                  ),
                  isEmpty: _color == '',
                  child: Builder(
                  //  bloc: blocs.groupItemPickerBloc,
                    builder: (BuildContext context){//, ItemListState state) {
                      print("log: widget update2");
                      if (state is Loaded) {
                        return Container();
                      }
                      if(state is PickedGroupState){
                        print("log: asdasdGroup: $state.item.name");
                        return Center(
                          child: Text('${state.item.name}',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        );
                      }
                      return Text("Loading");
                    },
                  )
              );
            },
          ), //groupFormField,
          onTap: () {
            List<PojoGroup> dataList = blocs.groupItemPickerBloc.dataList;
            if(dataList != null){
              if (state is Loaded || state is PickedGroupState) {
                showDialogGroup(context, (PojoGroup group) {
                 // chosenGroup = group;
                  blocs.groupItemPickerBloc.dispatch(PickedGroupEvent(item: group));
                  print("log: group: ${group.name}");
                },
                  data: dataList,
                );
              }
            }

          },
        );
      }
    );
    var subjectPicker = BlocBuilder(
        bloc: blocs.subjectItemPickerBloc,
        builder: (BuildContext context, ItemListState state) {
          print("log: widget update111");
          return GestureDetector(
            child: FormField(
              builder: (FormFieldState formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: formColor,
                      icon: const Icon(Icons.group),
                      labelText: 'Subject',
                    ),
                    isEmpty: _color == '',
                    child: Builder(
                      builder: (BuildContext context){//, ItemListState state) {
                        print("log: widget update2");
                        if (state is Loaded) {
                          return Container();
                        }
                        if(state is PickedSubjectState){
                          print("log: asdasdGroup: $state.item.name");
                          return Center(
                            child: Text('${state.item.name}',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          );
                        }
                        return Text("Loading");
                      },
                    )
                );
              },
            ), //groupFormField,
            onTap: () {
              List<PojoSubject> dataList = blocs.subjectItemPickerBloc.dataList;
              if(dataList != null){
                if (state is Loaded || state is PickedSubjectState) {
                  showDialogSubject(context, (PojoSubject subject) {
                    // chosenGroup = group;
                    blocs.subjectItemPickerBloc.dispatch(PickedSubjectEvent(item: subject));
                    print("log: group: ${subject.name}");
                  },
                    data: dataList,
                  );
                }
              }

            },
          );
        }
    );
    var deadlinePicker = BlocBuilder(
      bloc: blocs.deadlineBloc,
      builder: (BuildContext context, DateTimePickerState state) {
        return GestureDetector(
          child: FormField(
            builder: (FormFieldState formState) {
              return InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: formColor,
                  icon: const Icon(Icons.date_range),
                  labelText: 'Deadline',
                ),
                isEmpty: _color == '',
                child: Builder(
                  builder: (BuildContext context){
                    if (state is DateTimeNotPickedState) {
                      return Container();
                    }
                    if(state is DateTimePickedState){
                      return Center(
                        child: Text('${state.dateTime.toString()}',
                          style: TextStyle(fontSize: 24.0),
                        ),
                      );
                    }
                    return Text("Loading");
                  },
                ),
              );
            },
          ),
          onTap: () async {
            final DateTime picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(hours: 24)), lastDate: DateTime.now().add(Duration(days: 364)));
            blocs.deadlineBloc.dispatch(DateTimePickedEvent(dateTime: picked));
          },
        );
      }
    );

    return Hero(
        tag: "hero_task_edit",
        child: Scaffold(
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
                        child: ExpandableNotifier(
                          controller: expandableController,
                          child: BlocBuilder(
                            bloc: blocs.taskTypePickerBloc,
                            builder: (BuildContext context, TaskTypePickerState state) {
                              String typeName = "Not picked";
                              if(state is TaskTypePickedState){
                                if(state.item.id == 1) {
                                headerColor = homeworkColor;
                                typeName = "Homework";
                                }
                                else if(state.item.id == 2) {
                                headerColor = assignmentColor;
                                typeName = "Assignment";
                                }
                                else if(state.item.id == 3) {
                                headerColor = testColor;
                                typeName = "Test";
                                }
                                else if(state.item.id == 4) {
                                headerColor = oralTestColor;
                                typeName = "Oral test";
                                }
                              }

                              return new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expandable(
                                      collapsed: Container(
                                        color: headerColor,
                                        child: Row(
                                            children: [
                                              Expanded(child: Column(),),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(typeName,
                                                      style: TextStyle(
                                                          fontSize: 30
                                                      ),
                                                    ),
                                                    BlocBuilder(
                                                      bloc: blocs.groupItemPickerBloc,
                                                      builder: (BuildContext context, ItemListState state) {
                                                        String groupName = "Not picked group";
                                                        if(state is PickedGroupState){
                                                          groupName = state.item.name;
                                                        }
                                                        return Text(groupName,
                                                          style: TextStyle(
                                                              fontSize: 22
                                                          ),
                                                        );
                                                      }
                                                    ),
                                                    BlocBuilder(
                                                        bloc: blocs.subjectItemPickerBloc,
                                                        builder: (BuildContext context, ItemListState state) {
                                                          String subjectName = "Not picked subject";
                                                          if(state is PickedSubjectState){
                                                            subjectName = state.item.name;
                                                          }
                                                          return Text(subjectName,
                                                            style: TextStyle(
                                                                fontSize: 22
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                    BlocBuilder(
                                                        bloc: blocs.deadlineBloc,
                                                        builder: (BuildContext context, DateTimePickerState state) {
                                                          String deadline = "Not picked deadline";
                                                          if(state is DateTimePickedState){
                                                            deadline = state.dateTime.toString();
                                                          }
                                                          return Text(deadline,
                                                            style: TextStyle(
                                                                fontSize: 22
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: FractionalOffset
                                                      .bottomRight,
                                                  child: Builder(
                                                      builder: (context) {
                                                        //  var exp = expandableController.of(context);
                                                        return IconButton(
                                                            icon: Icon(Icons
                                                                .keyboard_arrow_down),
                                                            onPressed: () {
                                                              expandableController
                                                                  .toggle();
                                                            });
                                                      }
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      expanded: Container(
                                        color: headerColor,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0,
                                                  right: 2.0,
                                                  bottom: 2),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Flexible(child: Column()),
                                                  new Expanded(
                                                      child: taskTypePicker
                                                  ),
                                                  Flexible(
                                                    child: Align(
                                                      alignment: FractionalOffset
                                                          .bottomRight,
                                                      child: Builder(
                                                          builder: (context) {
                                                            //  var exp = expandableController.of(context);
                                                            return IconButton(
                                                                icon: Icon(Icons
                                                                    .keyboard_arrow_up),
                                                                onPressed: () {
                                                                  expandableController
                                                                      .toggle();
                                                                });
                                                          }
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 4),
                                                    child: BlocProviderTree(
                                                      blocProviders: [
                                                        BlocProvider<GroupItemPickerBloc>(bloc: blocs.groupItemPickerBloc),
                                                      //  BlocProvider<VariableBloc>(bloc: chosenGroup),
                                                      ],
                                                      child: groupPicker,
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 4),
                                                      child: subjectPicker
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 4),
                                                    child: deadlinePicker,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      animationDuration: Duration(milliseconds: 200),
                                    ),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                new Flexible(
                                                  child: FormBuilder(
                                                    key: _fbKey,
                                                    autovalidate: true,
                                                    child: FormBuilderTextField(
                                                      controller: _titleTextEditingController,
                                                      attribute: "title",
                                                      decoration: InputDecoration(
                                                          labelText: "Title"),
                                                      validators: [
                                                        FormBuilderValidators.minLength(2, errorText: "Min characters is 2"),
                                                        FormBuilderValidators.maxLength(20, errorText: "Max characters is 20"),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                        ]
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 4),
                                      child: TextField(
                                        controller: _descriptionTextEditingController,
                                        decoration: new InputDecoration.collapsed(
                                            hintText: 'desctiption',
                                            border: OutlineInputBorder()
                                        ),

                                        maxLength: 240,
                                        maxLines: 8,
                                        minLines: 6,
                                        expands: false,
                                        style: TextStyle(
                                            fontSize: 22
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: RaisedButton(
                                          child: Text("Send"),
                                          onPressed: () {
                                            _fbKey.currentState.save();
                                            if (_fbKey.currentState.validate()) {
                                              print(_fbKey.currentState.value);

                                              blocs.send(
                                                title: _titleTextEditingController.text,
                                                description: _descriptionTextEditingController.text,
                                                onSuccess: (){
                                                  Navigator.of(context).pop();
                                                }
                                              );
                                            }
                                          }
                                      ),
                                    )
                                  ]
                              );

                            }
                          ),
                        ),
                      ),
                          ),
                    )
                  ),
              ),
            ),
    );
  }

  Future<Null> _handleRefresh() async{
   // await getData();

    var now = new DateTime.now();
    var berlinWallFell = new DateTime.utc(1989, 11, 9);
    var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");  // 8:18pm
  }
}
