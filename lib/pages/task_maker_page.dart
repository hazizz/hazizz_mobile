import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/create_task_bloc.dart';
import 'package:mobile/blocs/date_time_picker_bloc.dart';
import 'package:mobile/blocs/edit_task_bloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_group_bloc.dart';
import 'package:mobile/blocs/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoType.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';

import 'package:expandable/expandable.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import '../hazizz_date.dart';
import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';


class TaskMakerPage extends StatefulWidget {
  int groupId;

  PojoGroup group;
  PojoTask taskToEdit;
  int taskId;

  TaskMakerMode mode;

  String title;

 // EditTaskPage({Key key, this.taskId}) : super(key: key);

  TaskMakerPage.editMode({Key key, this.taskToEdit}) : super(key: key){
    taskId = taskToEdit.id;
    mode = TaskMakerMode.edit;
  }

  TaskMakerPage.createMode({Key key, this.groupId}) : super(key: key){
    mode = TaskMakerMode.create;
  }

  @override
  _TaskMakerPage createState() => _TaskMakerPage();
}

class _TaskMakerPage extends State<TaskMakerPage> {

  ItemListPickerGroupBloc itemListPickerGroupBloc = ItemListPickerGroupBloc();

//  final TextEditingController _descriptionTextEditingController = TextEditingController();
//  final TextEditingController _titleTextEditingController = TextEditingController();

  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  Color headerColor = HazizzTheme.homeworkColor;

  static String _color = '';

  static final double padding = 8;

  static bool _isExpanded = false;

  TaskMakerBloc blocs;

  static PojoSubject chosenSubject;

  FormField groupFormField;

  ExpandableController expandableController = new ExpandableController(true);


  List<PojoTask> task_data = List();
  List<PojoSubject> subjects_data = List();

 // TextEditingController titleController = new TextEditingController();

//  FocusNode titleTextFocus = new FocusNode();


  AppBar getAppBar(BuildContext context){
    return AppBar(
      leading: HazizzBackButton(),
        title: Text(widget.mode == TaskMakerMode.create ? locText(context, key: "createTask") : locText(context, key: "editTask") )
    );
  }

  void processData(PojoTask pojoTask){
   // expandablePanel.c
    widget.taskToEdit = pojoTask;
  }

  @override
  void initState() {

    if(widget.mode == TaskMakerMode.create){
      blocs = TaskCreateBloc(group: widget.group);

    }else if(widget.mode == TaskMakerMode.edit){
      blocs =  new TaskEditBloc(taskToEdit: widget.taskToEdit);
   //   blocs.subjectItemPickerBloc.isLocked = true;
 //     blocs.groupItemPickerBloc.isLocked = true;

      blocs.groupItemPickerBloc.dispatch(SetGroupEvent(item: widget.taskToEdit.group));
      blocs.subjectItemPickerBloc.dispatch(SetSubjectEvent(item: widget.taskToEdit.subject));

    }else{
      print("log: Well ...");
    }

    blocs.groupItemPickerBloc.dispatch(ItemListLoadData());

    super.initState();
  }

  @override
  void dispose() {
    blocs.dispose();
    super.dispose();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {

    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  @override
  Widget build(BuildContext context) {

    AppBar appBar = AppBar(
        title: Text(widget.mode == TaskMakerMode.create ? locText(context, key: "createTask") : locText(context, key: "editTask") )
    );

    var taskTypePicker = BlocBuilder(
        bloc: blocs.taskTypePickerBloc,
        builder: (BuildContext context, TaskTypePickerState state) {

          String typeName = "ERROR";
          if(state is TaskTypePickedState) {
            if (state.item.id == 1) {
              headerColor = HazizzTheme.homeworkColor;
            }
            else if (state.item.id == 2) {
              headerColor = HazizzTheme.assignmentColor;
            }
            else if (state.item.id == 3) {
              headerColor = HazizzTheme.testColor;
            }
            else if (state.item.id == 4) {
              headerColor = HazizzTheme.oralTestColor;
            }
            typeName = locText(context, key: "taskType_${state.item.id}");
          }



          return GestureDetector(
            child: FormField(
              builder: (FormFieldState formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: HazizzTheme.formColor,
                  //    labelText: 'Type',
                    ),
                    isEmpty: _color == '',
                    child: Text('${typeName}',
                            style: TextStyle(fontSize: 24.0),
                    )
                );
              },
            ),
            onTap: () async {
              PojoType result = await showDialogTaskType(context);
              if(result != null){
                blocs.taskTypePickerBloc.dispatch(TaskTypePickedEvent(result));

              }
            },
          );
        }
    );
    var groupPicker = BlocBuilder(
      bloc: blocs.groupItemPickerBloc,
      builder: (BuildContext context, ItemListState state) {
        print("log: widget update111");

        String error;
        if(state is ItemListNotPickedState){
          error = locText(context, key: "error_noGroupSelected");
        }

        return GestureDetector(
          child: FormField(
            builder: (FormFieldState formState) {
              String hint;
              if(state is ItemListLoaded){
                hint = locText(context, key: "group");
              }
              return InputDecorator(

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 6, bottom: 8, top: 10),
                    errorText: error,
                   // error
                    filled: true,
                    fillColor: HazizzTheme.formColor,
                  //  icon: const Icon(Icons.group),
                    labelText: hint,
                  ),
                  isEmpty: _color == '',
                  child: Builder(
                  //  bloc: blocs.groupItemPickerBloc,
                    builder: (BuildContext context){//, ItemListState state) {
                      if (state is ItemListLoaded) {
                        return Container();
                      }
                      if(state is PickedGroupState){
                        print("log: asdasdGroup: $state.item.name");
                        return Text('${state.item.name}',
                            style: TextStyle(fontSize: 20.0),
                        );
                      }
                      return Text("Loading");
                    },
                  )
              );
            },
          ), //groupFormField,
          onTap: () async {
            List<PojoGroup> dataList = blocs.groupItemPickerBloc.dataList;
            if(dataList != null){
              if (state is ItemListLoaded || state is PickedGroupState) {
                PojoGroup result = await showDialogGroup(context, data: dataList,);
                if(result != null){
                  blocs.groupItemPickerBloc.dispatch(PickedGroupEvent(item: result));
                }
              }
            }

          },
        );
      }
    );
    var subjectPicker = BlocBuilder(
        bloc: blocs.subjectItemPickerBloc,
        builder: (BuildContext context, ItemListState state) {
          print("log: subject picker state: $state");

          return BlocBuilder(
            bloc: blocs.groupItemPickerBloc,
            builder: (context2, state2){
              if(blocs.groupItemPickerBloc.pickedItem == null || blocs.groupItemPickerBloc.pickedItem.id == 0){
                print("what????");
                return Container();
              }

              return GestureDetector(
                child: FormField(

                  builder: (FormFieldState formState) {
                    String hint;
                    String error;
                    if(state is ItemListNotPickedState){
                      error = "Not picked";
                    }
                    if(!(state is PickedSubjectState)){
                      hint = locText(context, key: "subject");
                    }

                    return InputDecorator(

                        decoration: InputDecoration(
                          //    filled: true,
                          //   fillColor: HazizzTheme.formColor,
                          //     icon: const Icon(Icons.group),
                            contentPadding: EdgeInsets.only(left: 6, bottom: 8, top: 10),

                            labelText: hint,
                            errorText: error
                        ),
                        isEmpty: _color == '',
                        child: Builder(
                          builder: (BuildContext context){//, ItemListState state) {
                            print("log: u $state");
                            if (state is ItemListLoaded) {
                              return Container();
                            }
                            if(state is PickedSubjectState) {
                              print("log: ööö");
                              return Text('${ state.item.name != null
                                  ? state.item.name
                                  : "no Subject"}',
                                style: TextStyle(fontSize: 20),

                              );
                            }
                            else if(state is NotPickedEvent){

                            }
                            return Container();
                          },
                        )
                    );
                  },
                ), //groupFormField,
                onTap: () async {
                  List<PojoSubject> dataList = blocs.subjectItemPickerBloc.dataList;
                  if (state is! Waiting && state is! InitialState && state is! ItemListFail) {
                    PojoSubject result = await showDialogSubject(context, data: dataList, group: blocs.groupItemPickerBloc.pickedItem);
                    if(result != null){
                      blocs.subjectItemPickerBloc.dispatch(PickedSubjectEvent(item: result));
                    }
                  }


                },
              );

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
              String hint;
              if(state is DateTimeNotPickedState){
                hint = locText(context, key: "deadline");
              }
              return InputDecorator(

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 6, bottom: 8, top: 10),

                  filled: true,
                  fillColor: HazizzTheme.formColor,
               //   icon: const Icon(Icons.date_range),
                  labelText: hint,
                ),
                isEmpty: _color == '',
                child: Builder(
                  builder: (BuildContext context){
                    if (state is DateTimeNotPickedState) {
                      return Container();
                    }
                    if(state is DateTimePickedState){
                      return Text('${hazizzShowDateFormat(state.dateTime)}',
                          style: TextStyle(fontSize: 20.0),

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
                initialDate: widget.mode == TaskMakerMode.edit ? widget.taskToEdit.dueDate : DateTime.now(),

                firstDate: DateTime.now().subtract(Duration(hours: 24)),
                lastDate: DateTime.now().add(Duration(days: 364))
            );
            if(picked != null) {
              blocs.deadlineBloc.dispatch(DateTimePickedEvent(dateTime: picked));
            }
          },
        );
      }
    );
    var titleTextForm = BlocBuilder(
        bloc: blocs.titleBloc,
        builder: (BuildContext context, HFormState state) {
          String errorText = null;
          if(state is TextFormSetState){
            blocs.titleController.text = state.text;
            print("title is set2: ${blocs.titleController.text}");
          }
          else if(state is TextFormErrorTooShort){
            errorText = "Title is too short";
          }
          return TextFormField(
            style: TextStyle(
                fontSize: 22,
            ),


            maxLength: 20,
            focusNode: _titleFocusNode,
            controller: blocs.titleController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String value){
              print("onFieldSubmitted: $value");
              _fieldFocusChange(context, _titleFocusNode, _descriptionFocusNode);
            },
            decoration:
                InputDecoration(labelText: locText(context, key: "title"), errorText: errorText,
                  contentPadding: EdgeInsets.only(left: 6, bottom: 2, top: 2),

                  //   hintStyle: TextStyle(fontSize: 20),
                  errorStyle: TextStyle(fontSize: 16),
                  filled: true,
              //    fillColor: HazizzTheme.formColor
                ),
          );
        }
    );
    var descriptionTextForm = BlocBuilder(
        bloc: blocs.descriptionBloc,
        builder: (BuildContext context, HFormState state) {

          if(state is TextFormSetState){
            blocs.descriptionController.text = state.text;
          }

          return TextFormField(
            /*
            onChanged: (dynamic text) {
              print("change: $text");
              blocs.descriptionBloc.dispatch(TextFormValidate(text: text));
            },
            */

            focusNode: _descriptionFocusNode,
            controller: blocs.descriptionController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (String value){
              print("onFieldSubmitted: $value");
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration:
                InputDecoration(labelText: locText(context, key: "description"), errorText: null,
                 alignLabelWithHint: true,
                 filled: true,
              //    fillColor: HazizzTheme.formColor,
            ),
            maxLength: 240,
            maxLines: 8,
            minLines: 6,
            expands: false,
            style: TextStyle(
                fontSize: 21
            ),
          );


        }
    );

    return BlocListener(
      bloc: blocs,
      listener: (context, state) {
        if (state is TaskMakerSentState) {
          //  Navigator.of(context).pushNamed('/details');
          Navigator.pop(context);
        }
      },
      child: Hero(
          tag: "hero_task_edit",
          child: Scaffold(
              appBar: appBar,
              body:SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                    width: MediaQuery.of(context).size.width,
                    // valamiért 3* kell megszorozni a paddingot hogy jó legyen
                    height: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 100,
                          child: BlocBuilder(
                              bloc: blocs.taskTypePickerBloc,
                              builder: (BuildContext context, TaskTypePickerState state) {
                                String typeName = "Not picked";
                                if(state is TaskTypePickedState){
                                  if(state.item.id == 1) {
                                    headerColor = HazizzTheme.homeworkColor;
                                    typeName = "Homework";
                                  }
                                  else if(state.item.id == 2) {
                                    headerColor = HazizzTheme.assignmentColor;
                                    typeName = "Assignment";
                                  }
                                  else if(state.item.id == 3) {
                                    headerColor = HazizzTheme.testColor;
                                    typeName = "Test";
                                  }
                                  else if(state.item.id == 4) {
                                    headerColor = HazizzTheme.oralTestColor;
                                    typeName = "Oral test";
                                  }
                                }

                                return Container(

                                  child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          color: headerColor,
                                          child:
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, top: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: taskTypePicker
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 4),
                                                  child: groupPicker,
                                                ),

                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
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
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12, top: 0, right: 12),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              new Flexible(
                                                  child: titleTextForm
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(flex: 1,),


                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, right: 12, top: 0),
                                            child: descriptionTextForm
                                        ),
                                        Spacer(flex: 1,),

                                        Center(
                                            child:

                                            BlocBuilder(
                                                bloc: blocs,
                                                builder: (BuildContext context, TaskMakerState state) {
                                                  if(state is TaskMakerWaitingState) {
                                                    return RaisedButton(
                                                      child: Transform.scale(
                                                        scale: 0.8,
                                                        child: FittedBox(
                                                          child: CircularProgressIndicator(),
                                                          fit: BoxFit.scaleDown,
                                                        ),
                                                      ),
                                                    );
                                                  }else{
                                                    return RaisedButton(
                                                        child: Text((widget.mode == TaskMakerMode.create ? locText(context, key: "create") : locText(context, key: "edit"))),
                                                        onPressed: () async {
                                                          if(!(state is TaskMakerWaitingState)) {
                                                            blocs.dispatch(
                                                                TaskMakerSendEvent());
                                                          }
                                                        }
                                                    );
                                                  }


                                                }
                                            )
                                        ),
                                        Spacer(flex: 2,),
                                      ]
                                  )
                                );
                              }
                          ),
                          ),
                        )
                      ),
                  ]
                ),
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
