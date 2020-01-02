import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';
import 'package:mobile/custom/line_break_limit_text_formatter.dart';
import 'package:mobile/managers/google_drive_manager.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/tasks/create_task_bloc.dart';
import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/blocs/tasks/edit_task_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/image_operations.dart';

import 'package:mobile/defaults/pojo_group_empty.dart';
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/widgets/google_drive_image_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';
import 'package:mobile/widgets/tag_chip.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:native_state/native_state.dart';

class TaskMakerPage extends StatefulWidget {
  int groupId;

  PojoGroup group;
  PojoTask taskToEdit;
  int taskId;

  TaskMakerMode mode;

  String title;

  String cryptKey = HazizzCrypt.generateKey();

  TaskMakerPage.edit({Key key, this.taskToEdit}) : super(key: key){
    taskId = taskToEdit.id;
    mode = TaskMakerMode.edit;

    cryptKey = taskToEdit.salt;
  }

  TaskMakerPage.create({Key key, this.groupId}) : super(key: key){
    mode = TaskMakerMode.create;
  }

  @override
  _TaskMakerPage createState() => _TaskMakerPage();
}

class _TaskMakerPage extends State<TaskMakerPage> with StateRestoration {

  List<HazizzImageData> imageDatas = List();

  List<HazizzImageData> imageDatasToRemove = List();


  final FocusNode _descriptionFocusNode = FocusNode();

  Color headerColor = HazizzTheme.homeworkColor;

  static String _color = '';

  static final double padding = 8;

  TaskMakerBloc blocs;

  static PojoSubject chosenSubject;

  FormField groupFormField;

  final ScrollController scrollController = ScrollController();


  int descriptionMaxLength = 500;

  AppBar getAppBar(BuildContext context){
    return AppBar(
      leading: HazizzBackButton(),
        title: Text(widget.mode == TaskMakerMode.create ? locText(context, key: "createTask") : locText(context, key: "editTask") )
    );
  }

  void deleteGDriveImages(){
    print("deleting google drives images");
    for(Object imageData in imageDatas){
      print("deleting google drives images loop");
      if(imageData is HazizzImageData){
        if(imageData.driveFileId != null){
          print("deleting google drives images loop2");

          GoogleDriveManager().deleteHazizzImage(imageData.driveFileId);
        }
      }
    }
  }

  @override
  void initState() {

    if(widget.mode == TaskMakerMode.create){
      blocs = TaskCreateBloc(group: widget.group);

    }else if(widget.mode == TaskMakerMode.edit){
      blocs = new TaskEditBloc(taskToEdit: widget.taskToEdit);

      List<String> splited = widget.taskToEdit.description.split("\n![img_");

      for(int i = 1; i < splited.length; i++){
        if(true){
          final String url = splited[i].substring(4, splited[i].length-1);

          print("url is: $url");
          imageDatas.add(HazizzImageData.fromGoogleDrive(url, widget.taskToEdit.salt));
        }
      }


    }else{
      HazizzLogger.printLog("this should not be visible: 542311z8");
    }

    blocs.descriptionController.addListener((){
      SavedState.of(context).putString("task_description", blocs.descriptionController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    blocs.dispose();
    super.dispose();
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
                hasCloseButton: true,
                onCloseClick: (){
                  HazizzLogger.printLog("locsing");
                  blocs.taskTagBloc.dispatch(TaskTagRemoveEvent(tag: t));
                },
              )
            );
          }
          if(pickedTags.length < 8){
            tagWidgets.add(TagChip(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.plus, size: 18,),
                  Text(locText(context, key: "add"), style: TextStyle(fontSize: 20),)
                ],
              ),
              hasCloseButton: false,
              onClick: () async {
                PojoTag result = await showDialogTaskTag(context, except: blocs.taskTagBloc.pickedTags);
                HazizzLogger.printLog("showDialogTaskTag dialog result: ${result?.name}");
                if(result != null){
                  blocs.taskTagBloc.dispatch(TaskTagAddEvent(result));
                }
              },
            ));
          }
          return Wrap(
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
                            labelText: hint,
                          ),
                          isEmpty: _color == '',
                          child: Builder(
                            builder: (BuildContext context){
                              if (state is ItemListLoaded) {
                                return Container();
                              }
                              if(state is PickedGroupState){
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
                  ),
                ),
              )
            ],
          ),
          onTap: () async {
            if(blocs is TaskCreateBloc) {
              List<PojoGroup> dataList = blocs.groupItemPickerBloc.dataList;
              if(dataList != null) {
                if(state is ItemListLoaded || state is PickedGroupState) {
                  PojoGroup result = await showDialogGroup(context, data: dataList);
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
                                  contentPadding: EdgeInsets.only(left: 6, bottom: 8, top: 10),
                                  labelText: hint,
                                  errorText: error
                              ),
                              isEmpty: _color == '',
                              child: Builder(
                                builder: (BuildContext context){
                                  if (state is ItemListLoaded) {
                                    return Container();
                                  }
                                  if(state is PickedSubjectState) {

                                    return Text('${ state.item.id != 0
                                        ? state.item.name
                                        : getEmptyPojoSubject(context).name}',
                                      style: TextStyle(fontSize: 20, color: blocs is TaskCreateBloc
                                        ? null
                                        : Colors.black45,
                                      ),
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
                ],),
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
    var descriptionTextForm = BlocBuilder(
          bloc: blocs.descriptionBloc,
          builder: (BuildContext context, HFormState state) {

            if(state is TextFormSetState){
              blocs.descriptionController.text = state.text;
            }
            return TextFormField(
              inputFormatters:[
                LineBreakLimitingTextInputFormatter(10)
              ],
              focusNode: _descriptionFocusNode,
              controller: blocs.descriptionController,
              textInputAction: TextInputAction.newline,
              onFieldSubmitted: (String value){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(labelText: locText(context, key: "description"), errorText: null,
                alignLabelWithHint: true,
                filled: true,
              ),
              maxLength: descriptionMaxLength - 75 * imageDatas.length,
              maxLines: 8,
              minLines: 6,
              expands: false,
              style: TextStyle(
                  fontSize: 21
              ),
            );
          }
      );

    return WillPopScope(
      onWillPop: (){
        deleteGDriveImages();
       // Navigator.pop(context);
        return Future.value(true);
      },
      child: BlocListener(
          bloc: blocs,
          listener: (context, state) {
            if (state is TaskMakerSuccessfulState) {
              Navigator.pop(context, state.task);
            }
          },
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
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 100,
                    child: BlocBuilder(
                      bloc: blocs.taskTagBloc,
                      builder: (BuildContext context, TaskTagState state) {
                        headerColor = HazizzTheme.blue;
                        if(state is TaskTagFineState){
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
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                                    child: descriptionTextForm
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6, right: 10),
                                    child: Card(
                                      color: Colors.grey,
                                      child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: ConstrainedBox(
                                          constraints: new BoxConstraints(
                                            minHeight: 0,
                                            maxHeight: 100,
                                          ),
                                          child: SingleChildScrollView(
                                            controller: scrollController,

                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: imageDatas.length,
                                                      itemBuilder: (context, index){
                                                        return Padding(
                                                          padding: EdgeInsets.only(left: 6, ),
                                                          child: Container(
                                                            height: 100,
                                                            child: Stack(
                                                              children: <Widget>[
                                                                Builder(
                                                                  builder: (context){
                                                                      Function f = (){};
                                                                      if(imageDatas[index].imageType == ImageType.GOOGLE_DRIVE){
                                                                        f = (){
                                                                          imageDatasToRemove.add(imageDatas[index]);
                                                                        };
                                                                      }
                                                                      return ImageViewer.fromHazizzImageData(
                                                                        imageDatas[index],
                                                                        height: 100,
                                                                        onSmallDelete: (){
                                                                          f();
                                                                          setState(() {
                                                                            imageDatas.removeAt(index);
                                                                          });

                                                                        },
                                                                      );
                                                                  //  }
                                                                    return null;

                                                                  },
                                                                ),
                                                               /* Positioned(
                                                                  top: 0, left: 0,
                                                                  child: Transform.translate(
                                                                    offset: Offset(-1, -1),
                                                                    child: GestureDetector(
                                                                      child: Icon(FontAwesomeIcons.solidTimesCircle, size: 20, color: Colors.red,),
                                                                      onTap: (){

                                                                      },
                                                                    )
                                                                  )
                                                                )
                                                                */
                                                              ],
                                                            ),
                                                          )
                                                        );
                                                      }
                                                  ),
                                                ),
                                                Builder(
                                                  builder: (context){
                                                    if(imageDatas.length >= 3) return Container();
                                                    return Padding(
                                                      padding: EdgeInsets.only(left: 4),
                                                      child: IconButton(
                                                        icon: Icon(imageDatas.isEmpty ? FontAwesomeIcons.image : FontAwesomeIcons.plus),
                                                        onPressed: () async {
                                                          print("miva? 1");
                                                          if(!await AppState.isAllowedGDrive()){
                                                            print("miva? 2");
                                                           if(await showGrantAccessToGDRiveDialog(context)){

                                                           }else{
                                                             return;
                                                           }
                                                          }
                                                          HazizzImageData imageData = await ImageOpeations.pick();
                                                          if(imageData == null){
                                                            return;
                                                          }
                                                          setState(() {
                                                            imageDatas.add(imageData);
                                                          });
                                                          await GoogleDriveManager().initialize();

                                                          // upload to gdrive



                                                          imageData.compressEncryptAndUpload(widget.cryptKey);

                                                          Future.delayed(Duration(milliseconds: 400), (){
                                                            scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                                                          });


                                                        },
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ),
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
                                                  onPressed: null,
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
                                                          TaskMakerSendEvent(imageDatas: imageDatas, salt: widget.cryptKey)
                                                        );
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

  @override
  void restoreState(SavedStateData savedState) {
   // blocs.descriptionController.text = savedState.getString("task_description") ?? "";
  }
}
