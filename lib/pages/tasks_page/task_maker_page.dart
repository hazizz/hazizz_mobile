import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';
import 'package:mobile/blocs/item_list/item_list_picker_group_bloc.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/tasks/create_task_bloc.dart';
import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/blocs/tasks/edit_task_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/defaults/pojo_group_empty.dart';
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/tag_chip.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';


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

    //  blocs.groupItemPickerBloc.dispatch(SetGroupEvent(item: widget.taskToEdit.group));
    //  blocs.subjectItemPickerBloc.dispatch(SetSubjectEvent(item: widget.taskToEdit.subject));

    }else{
      HazizzLogger.printLog("this should not be visible: 542311z8");
    }

  //  blocs.groupItemPickerBloc.dispatch(ItemListLoadData());

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
        leading: HazizzBackButton(),

        title: Text(widget.mode == TaskMakerMode.create ? locText(context, key: "createTask") : locText(context, key: "editTask") )
    );

    var taskTypePicker = BlocBuilder(
        bloc: blocs.taskTagBloc,
        builder: (BuildContext context, TaskTagState state) {

          List<PojoTag> pickedTags =  blocs.taskTagBloc.pickedTags;

          List<Widget> tagWidgets = List();

          for(PojoTag t in pickedTags){
            tagWidgets.add(
                TagChip(child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 21, ), textAlign: TextAlign.center,),
                  // backgroundColor: t.getColor(),
                  hasCloseButton: true,
                  onCloseClick: (){
                    // notify bloc
                    HazizzLogger.printLog("locsing");
                    blocs.taskTagBloc.dispatch(TaskTagRemoveEvent(tag: t));
                  },
               //   padding: EdgeInsets.only(left: 5, right: 5, top: 4, bottom: 4),

                )
            );
          }

          if(pickedTags.length < 8){
            tagWidgets.add(TagChip(
              child: Row(children: <Widget>[
                Icon(FontAwesomeIcons.plus, size: 18,),
                Text(locText(context, key: "add"), style: TextStyle(fontSize: 20),)
              ],),

              //  padding: EdgeInsets.only(left: 5, right: 5, top: 4, bottom: 4),
              hasCloseButton: false,
              onClick: () async {

                PojoTag result = await showDialogTaskTag(context, except: blocs.taskTagBloc.pickedTags);
                HazizzLogger.printLog("showDialogTaskTag dialog result: ${result?.getName()}");
                if(result != null){
                  blocs.taskTagBloc.dispatch(TaskTagAddEvent(result));
                }
              },
            ));
          }
          return Wrap(
           // alignment: WrapAlignment.start,
          //  runAlignment: WrapAlignment.start,
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: tagWidgets,
          );

        }
    );
    var groupPicker = BlocBuilder(
      bloc: blocs.groupItemPickerBloc,
      builder: (BuildContext context, ItemListState state) {
        String error;
        if(state is ItemListNotPickedState){
          error = locText(context, key: "error_noGroupSelected");
        }

        return GestureDetector(
          child: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.users, color: blocs is TaskCreateBloc ? null : Colors.black26,),
              Expanded(child:
                Padding(
                  padding: EdgeInsets.only(left: 12),
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
                          //  filled: true,
                          //  fillColor: HazizzTheme.formColor,
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
                                /*
                                return Text('${state.item.name}',
                                  style: TextStyle(fontSize: 20.0),
                                );
                                */

                                return Text('${ state.item.id != 0
                                    ? state.item.name
                                    : getEmptyPojoGroup(context).name}',
                                  style: TextStyle(fontSize: 20, color: blocs is TaskCreateBloc
                                      ? null
                                      : Colors.black45,)

                                );


                              }
                              return Text(locText(context, key: "loading"));
                            },
                          )
                      );
                    },
                  ),),
              )
            ],
          ), //groupFormField,
          onTap: () async {
            if(blocs is TaskCreateBloc) {
              List<PojoGroup> dataList = blocs.groupItemPickerBloc.dataList;
              if(dataList != null) {
                if(state is ItemListLoaded || state is PickedGroupState) {
                  PojoGroup result = await showDialogGroup(
                    context, data: dataList,);
                  if(result != null) {
                    blocs.groupItemPickerBloc.dispatch(
                        PickedGroupEvent(item: result));
                  }
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
          return BlocBuilder(
            bloc: blocs.groupItemPickerBloc,
            builder: (context2, state2){
              if(blocs.groupItemPickerBloc.pickedItem == null || blocs.groupItemPickerBloc.pickedItem.id == 0){
                return Container();
              }

              return GestureDetector(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(FontAwesomeIcons.flask, color: blocs is TaskCreateBloc ? null : Colors.black26,),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FormField(
                        enabled: blocs is TaskCreateBloc,

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
                                  if (state is ItemListLoaded) {
                                    return Container();
                                  }
                                  if(state is PickedSubjectState) {

                                    return Text('${ state.item.id != 0
                                        ? state.item.name
                                        : getEmptyPojoSubject(context).name}',
                                      style: TextStyle(fontSize: 20, color: blocs is TaskCreateBloc
                                        ? null
                                        : Colors.black45,),

                                    );
                                  }
                                  else if(state is NotPickedEvent){

                                  }else if(state is SetGroupEvent){

                                  }
                                  return Container();
                                },
                              )
                          );
                        },
                      ),
                    ),
                  )
                ],), //groupFormField,
                onTap: () async {
                  if(blocs is TaskCreateBloc) {
                    List<PojoSubject> dataList = blocs.subjectItemPickerBloc.dataList;
                    if (state is! Waiting && state is! InitialState && state is! ItemListFail) {
                      PojoSubject result = await showDialogSubject(context, data: dataList, group: blocs.groupItemPickerBloc.pickedItem);
                      if(result != null){
                        blocs.subjectItemPickerBloc.dispatch(PickedSubjectEvent(item: result));
                      }
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
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(FontAwesomeIcons.calendarTimes),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FormField(
                    builder: (FormFieldState formState) {
                      String hint;
                      if(state is DateTimeNotPickedState){
                        hint = locText(context, key: "deadline");
                      }
                      return InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 6, bottom: 8, top: 10),

                         // filled: true,
                         // fillColor: HazizzTheme.formColor,
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
                            return Text(locText(context, key: "loading"));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
              HazizzLogger.printLog("change: $text");
              blocs.descriptionBloc.dispatch(TextFormValidate(text: text));
            },
            */

            focusNode: _descriptionFocusNode,
            controller: blocs.descriptionController,
            textInputAction: TextInputAction.newline,
            onFieldSubmitted: (String value){
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
        if (state is TaskMakerSuccessfulState) {
          //  Navigator.of(context).pushNamed('/details');
          Navigator.pop(context, state.task);
        }
      },
      child: Hero(
          tag: "hero_task_edit",
          child: Scaffold(
              appBar: appBar,
              body:SingleChildScrollView(
                child:
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                        maxHeight: (MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3)*2,

                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,

                      ),
                    /*
                    width: MediaQuery.of(context).size.width,
                    // valamiért 3* kell megszorozni a paddingot hogy jó legyen
                    height: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                    */
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 100,
                          child: BlocBuilder(
                              bloc: blocs.taskTagBloc,
                              builder: (BuildContext context, TaskTagState state) {
                               // String typeName = "Not picked";
                                headerColor = HazizzTheme.blue;

                                if(state is TaskTagFineState){
                                 // typeName = state.tag.getDisplayName(context);



                                  if(state.tags.length == 1 && state.tags[0] != null){
                                    headerColor = state.tags[0].getColor();
                                  }

                                }
                                return new Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                                bottom: 16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
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


                                       // Flex(direction: Axis.vertical, ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  new Flexible(
                                                      child: titleTextForm
                                                  )
                                                ],
                                              ),
                                            ),

                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12, right: 12, top: 0),
                                                child: descriptionTextForm
                                            ),

                                            Center(
                                                child:

                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0),
                                                  child: BlocBuilder(
                                                      bloc: blocs,
                                                      builder: (BuildContext context, TaskMakerState state) {
                                                        if(state is TaskMakerWaitingState) {
                                                          return RaisedButton(
                                                            child: Transform.scale(
                                                              scale: 0.8,
                                                              child: FittedBox(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(1),
                                                                  child: CircularProgressIndicator(),
                                                                ),
                                                                fit: BoxFit.scaleDown,
                                                              ),
                                                            ),
                                                          );
                                                        }else{
                                                          return RaisedButton(
                                                              child: Text((widget.mode == TaskMakerMode.create ? locText(context, key: "create") : locText(context, key: "edit")).toUpperCase()),
                                                              onPressed: () async {
                                                                if(!(state is TaskMakerWaitingState)) {
                                                                  blocs.dispatch(
                                                                      TaskMakerSendEvent());
                                                                }
                                                              }
                                                          );
                                                        }


                                                      }
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ]
                                  );
                              }
                          ),
                          ),
                        )
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
