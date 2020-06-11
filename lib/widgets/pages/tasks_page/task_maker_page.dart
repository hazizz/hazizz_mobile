import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/custom/line_break_limit_text_formatter.dart';
import 'package:mobile/main.dart';
import 'package:mobile/managers/app_state_restorer.dart';
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
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';
import 'package:mobile/widgets/similar_tasks_widget.dart';
import 'package:mobile/widgets/tag_chip.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:native_state/native_state.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

// TODO image deletion doesnt work. And it won't
// TODO delete uploaded files from gDrive when canceled
class TaskMakerPage extends StatefulWidget {
  final int groupId;

  final PojoGroup group;
  final PojoTask taskToEdit;
  final int taskId;

  final TaskMakerMode mode;

  final String cryptKey;

  final TaskMakerAppState taskMakerAppState;

  TaskMakerPage.edit({Key key, this.taskToEdit, this.taskMakerAppState})
    : groupId = taskToEdit?.group?.id, group = taskToEdit?.group,
      taskId = taskToEdit.id,
      cryptKey = taskToEdit.salt,
      mode = TaskMakerMode.edit,
    super(key: key);

  TaskMakerPage.create({Key key, this.groupId, this.taskMakerAppState})
    : group = null, taskToEdit = null, taskId = null,
      cryptKey = HazizzCrypt.generateKey(),
      mode = TaskMakerMode.create,
    super(key: key);

  @override
  _TaskMakerPage createState() => _TaskMakerPage();
}

class _TaskMakerPage extends State<TaskMakerPage> {

  final List<HazizzImageData> imageDatas = List();//(imageLimit);

  /// images that has been deleted
  final List<HazizzImageData> imageDatasToRemove = List();//(imageLimit);

  /// images that has been added
  final List<HazizzImageData> imageDatasNewlyAdded = List();//(imageLimit);

  final FocusNode _descriptionFocusNode = FocusNode();

  Color headerColor = HazizzTheme.homeworkColor;

  static String _color = '';

  static const double padding = 8;

  TaskMakerBloc taskMakerBloc;

  final ScrollController scrollController = ScrollController();


  static const int descriptionMaxLength = 500;

  AppBar getAppBar(BuildContext context){
    return AppBar(
      leading: HazizzBackButton(),
        title: Text(widget.mode == TaskMakerMode.create ? localize(context, key: "createTask") : localize(context, key: "editTask") )
    );
  }

  void deleteDeletedGDriveImages(){
    print("deleting google drives images");
    for(HazizzImageData imageData in imageDatasToRemove){
      print("deleting google drives images loop");
      if(imageData.driveFileId != null){
        print("deleting google drives images loop2");
        GoogleDriveManager().deleteHazizzImage(imageData.driveFileId);
      }
    }
  }

  void deleteAddedGDriveImages(){
    print("deleting google drives images");
    for(HazizzImageData imageData in imageDatasNewlyAdded){
      print("deleting google drives images loop");
      if(imageData.driveFileId != null){
        print("deleting google drives images loop2");
        GoogleDriveManager().deleteHazizzImage(imageData.driveFileId);
      }
    }
  }

  @override
  void initState() {
    if(widget.mode == TaskMakerMode.create){
      taskMakerBloc = TaskCreateBloc(group: widget.group, taskMakerAppState: widget.taskMakerAppState);
    }else if(widget.mode == TaskMakerMode.edit){
      taskMakerBloc = new TaskEditBloc(taskToEdit: widget.taskToEdit, taskMakerAppState: widget.taskMakerAppState);

      List<String> splited = widget.taskToEdit.description.split("\n![img_");
      for(int i = 1; i < splited.length; i++){
        if(true){
          final String url = splited[i].substring(3, splited[i].length-1);

          print("url is: $url");
          imageDatas.add(HazizzImageData.fromGoogleDrive(url, widget.taskToEdit.salt));
        }
      }

    }else{
      HazizzLogger.printLog("this should not be visible: 542311z8");
    }

    taskMakerBloc.descriptionController.addListener((){
      SavedState.of(context).putString("task_description", taskMakerBloc.descriptionController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    taskMakerBloc.close();
    super.dispose();
  }

  void pickImage() async {
    print("miva? 1");
    if(!await AppState.isAllowedGDrive()){
      print("miva? 2");
      if(await showGrantAccessToGDRiveDialog(context)){
      }else{
        return;
      }
    }

    taskMakerBloc.add(TaskMakerSaveStateEvent(
      salt: widget.cryptKey,
      imageDatas: imageDatas
    ));
    HazizzImageData imageData = await ImageOperations.pick();
    AppStateRestorer.setShouldReloadTaskMaker(false);
    print("miauuu?");
    if(imageData == null){
      return;
    }
    setState(() {
      imageDatas.add(imageData);
      imageDatasNewlyAdded.add(imageData);
    });
    await GoogleDriveManager().initialize();

    // upload to gdrive
    imageData.compressEncryptAndUpload(widget.cryptKey);

    Future.delayed(1000.milliseconds, (){
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: 300.milliseconds, curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: HazizzBackButton(),
      title: Text(widget.mode == TaskMakerMode.create ? localize(context, key: "createTask") : localize(context, key: "editTask") )
    );

    Widget taskTypePicker = BlocBuilder(
        bloc: taskMakerBloc.taskTagBloc,
        builder: (BuildContext context, TaskTagState state) {
          List<PojoTag> pickedTags =  taskMakerBloc.taskTagBloc.pickedTags;
          List<Widget> tagWidgets = List();
          for(PojoTag t in pickedTags){
            tagWidgets.add(
              TagChip(child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 21, ), textAlign: TextAlign.center,),
                hasCloseButton: true,
                onCloseClick: (){
                  HazizzLogger.printLog("locsing");
                  taskMakerBloc.taskTagBloc.add(TaskTagRemoveEvent(tag: t));
                },
              )
            );
          }
          if(pickedTags.length < 8){
            tagWidgets.add(TagChip(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.plus, size: 18,),
                  Text(localize(context, key: "add"), style: TextStyle(fontSize: 20),)
                ],
              ),
              hasCloseButton: false,
              onClick: () async {
                PojoTag result = await showDialogTaskTag(context, except: taskMakerBloc.taskTagBloc.pickedTags);
                HazizzLogger.printLog("showDialogTaskTag dialog result: ${result?.name}");
                if(result != null){
                  taskMakerBloc.taskTagBloc.add(TaskTagAddEvent(result));
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
    Widget groupPicker = BlocBuilder(
      bloc: taskMakerBloc.groupItemPickerBloc,
      builder: (BuildContext context, ItemListState state) {
        String error;
        if(state is ItemListNotPickedState){
          error = localize(context, key: "error_noGroupSelected");
        }

        return GestureDetector(
          child: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.users, color: taskMakerBloc is TaskCreateBloc ? null : Colors.black26,),
              Expanded(child:
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: FormField(
                    builder: (FormFieldState formState) {
                      String hint;
                      if(state is ItemListLoaded){
                        hint = localize(context, key: "group");
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
                                  style: TextStyle(fontSize: 20, color: taskMakerBloc is TaskCreateBloc
                                    ? null
                                    : Colors.black45,)
                                );
                              }
                              return Text(localize(context, key: "loading"));
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
            if(taskMakerBloc is TaskCreateBloc) {
              List<PojoGroup> dataList = taskMakerBloc.groupItemPickerBloc.dataList;
              if(dataList != null) {
                if(state is ItemListLoaded || state is PickedGroupState) {
                  PojoGroup result = await showDialogGroup(context, data: dataList);
                  if(result != null) {
                    taskMakerBloc.groupItemPickerBloc.add(PickedGroupEvent(item: result));
                  }
                }
              }
            }
          },
        );
      }
    );
    Widget subjectPicker = BlocBuilder(
        bloc: taskMakerBloc.subjectItemPickerBloc,
        builder: (BuildContext context, ItemListState state) {
          return BlocBuilder(
            bloc: taskMakerBloc.groupItemPickerBloc,
            builder: (context2, state2){
              if(taskMakerBloc.groupItemPickerBloc.pickedItem == null
              || taskMakerBloc.groupItemPickerBloc.pickedItem.id == 0){
                return Container();
              }
              return GestureDetector(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(FontAwesomeIcons.flask, color: taskMakerBloc is TaskCreateBloc ? null : Colors.black26,),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FormField(
                        enabled: taskMakerBloc is TaskCreateBloc,

                        builder: (FormFieldState formState) {
                          String hint;
                          String error;
                          if(state is ItemListNotPickedState){
                            error = "Not picked";
                          }
                          if(!(state is PickedSubjectState)){
                            hint = localize(context, key: "subject");
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
                                      style: TextStyle(fontSize: 20, color: taskMakerBloc is TaskCreateBloc
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
                  if(taskMakerBloc is TaskCreateBloc) {
                    List<PojoSubject> dataList = taskMakerBloc.subjectItemPickerBloc.dataList;
                    if (state is! Waiting && state is! InitialState && state is! ItemListFail) {
                      PojoSubject result = await showDialogSubject(context, data: dataList, group: taskMakerBloc.groupItemPickerBloc.pickedItem);
                      if(result != null){
                        taskMakerBloc.subjectItemPickerBloc.add(PickedSubjectEvent(item: result));
                      }
                    }
                  }
                },
              );
            },
          );
        }
    );
    Widget deadlinePicker = BlocBuilder(
      bloc: taskMakerBloc.deadlineBloc,
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
                        hint = localize(context, key: "deadline");
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
                              return Text('${state.dateTime.hazizzShowDateFormat}',
                                style: TextStyle(fontSize: 20.0),
                              );
                            }
                            return Text(localize(context, key: "loading"));
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
              locale: preferredLocale,
              initialEntryMode: DatePickerEntryMode.calendar,
              context: context,
              initialDate: widget.mode == TaskMakerMode.edit ? widget.taskToEdit.dueDate : DateTime.now(),

              firstDate: DateTime.now().subtract(24.hours),
              lastDate: DateTime.now().add(364.days)
            );
            if(picked != null) {
              taskMakerBloc.deadlineBloc.add(DateTimePickedEvent(dateTime: picked));
            }
          },
        );
      }
    );
    Widget descriptionTextForm = Stack(
      children: <Widget>[
        BlocBuilder(
            bloc: taskMakerBloc.descriptionBloc,
            builder: (BuildContext context, HFormState state) {

              if(state is TextFormSetState){
                taskMakerBloc.descriptionController.text = state.text;
              }
              return TextFormField(
                inputFormatters:[
                  LineBreakLimitingTextInputFormatter(24)
                ],
                focusNode: _descriptionFocusNode,
                controller: taskMakerBloc.descriptionController,
                textInputAction: TextInputAction.newline,
                onFieldSubmitted: (String value){
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                decoration: InputDecoration(labelText: "description".localize(context),
                  alignLabelWithHint: true, filled: true,
                ),
                maxLength: descriptionMaxLength - 75 * imageDatas.length,
                maxLines: 10,
                minLines: 6,
                expands: false,
                style: TextStyle(fontSize: 19),
              );
            }
        ),
      ],
    );

    return WillPopScope(
      onWillPop: (){
        if(widget.mode == TaskMakerMode.create){
          deleteDeletedGDriveImages();
          deleteAddedGDriveImages();
        }else if(widget.mode == TaskMakerMode.edit){
          deleteAddedGDriveImages();
        }
        return Future.value(true);
      },
      child: BlocListener(
          bloc: taskMakerBloc,
          listener: (context, state) async {
            if (state is TaskMakerSuccessfulState) {
              deleteDeletedGDriveImages();
              Navigator.pop(context, state.task);
              MainTabBlocs().tasksBloc.add(TasksFetchEvent());
            }
            if(state is SimilarTasksTaskCreateState) {
              bool result = await showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierLabel: MaterialLocalizations.of(context)
                    .modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: 200.milliseconds,
                pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                  return SimilarTasksWidget(similarTasks: state.similarTasks,);
                }
              );
              if(result){
                taskMakerBloc.add(TaskMakerProceedToSendEvent());
              }else{
                Navigator.pop(context);
              }
            }
          },
          child: Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(10),
              child: BlocBuilder(
                  bloc: taskMakerBloc,
                  builder: (BuildContext context, TaskMakerState state) {
                    if(state is TaskMakerWaitingState) {
                      return FloatingActionButton(
                        heroTag: "task_maker_page",
                        backgroundColor: Colors.grey,
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
                      return FloatingActionButton(
                          heroTag: "task_maker_page_2",
                          child: widget.mode == TaskMakerMode.create
                            ?  Icon(FontAwesomeIcons.check)
                            : Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Icon(FontAwesomeIcons.edit),
                            ),
                          onPressed: () async {
                            if(!(state is TaskMakerWaitingState)) {
                              taskMakerBloc.add(
                                  TaskMakerSendEvent(imageDatas: imageDatas, salt: widget.cryptKey)
                              );
                            }
                          }
                      );
                    }
                  }
              ),
            ),
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
                      bloc: taskMakerBloc.taskTagBloc,
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
                              duration: 500.milliseconds,
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
                                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6, right: 10),
                                        child: Builder(
                                          builder: (context){
                                            if(imageDatas == null || imageDatas.isEmpty){
                                              return Container(
                                                 width: 62,
                                                  height: 46,
                                                //color: Colors.blue,
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  onPressed: pickImage,
                                                  padding: EdgeInsets.all(0),
                                                  color: Colors.grey,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        bottom: 10, right: 2,
                                                        child: Container(
                                                          decoration: new BoxDecoration(
                                                            borderRadius: BorderRadius.all(const Radius.circular(5.0)),
                                                            color: Colors.grey,

                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left:4, right:4, bottom: 2),
                                                            child: Icon(FontAwesomeIcons.image),
                                                          ),
                                                        )
                                                      ),
                                                      Positioned(
                                                        bottom: 12, left: 4,
                                                        child: Icon(FontAwesomeIcons.plus),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return Card(
                                              color: Colors.grey,
                                              child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: ConstrainedBox(
                                                    constraints: new BoxConstraints(
                                                      minHeight: 0,
                                                      maxHeight: 100,
                                                    ),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        SingleChildScrollView(
                                                          controller: scrollController,
                                                          scrollDirection: Axis.horizontal,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: ListView.builder(
                                                              /*
                                                                    cacheExtent: 100000000,
                                                                    addAutomaticKeepAlives: true,
                                                                    */
                                                                    shrinkWrap: true,
                                                                    scrollDirection: Axis.horizontal,
                                                                    itemCount: imageDatas.length,
                                                                    itemBuilder: (context, index){
                                                                      Function f = (){};
                                                                      if(imageDatas[index].imageType == ImageType.GOOGLE_DRIVE){
                                                                        f = (){
                                                                          imageDatasToRemove.add(imageDatas[index]);
                                                                        };
                                                                      }
                                                                      return imageViewerFromHazizzImageData(
                                                                        imageDatas[index], //key: ObjectKey(imageDatas[index]), //index: index, key: ObjectKey(imageDatas[index]),//Key(index.toString()),//ObjectKey(imageDatas[index]),
                                                                        height: 100,
                                                                        onSmallDelete: (){
                                                                          HazizzLogger.printLog("Pressed X. Deleting at index $index");
                                                                          setState(() {
                                                                            imageDatas.remove(imageDatas[index]);
                                                                          });
                                                                        },
                                                                        onDelete: (){
                                                                          HazizzLogger.printLog("Pressed X. Deleting");
                                                                          f();
                                                                          setState(() {
                                                                            imageDatas.removeAt(index);
                                                                          });
                                                                          Navigator.pop(context);
                                                                        },
                                                                      );
                                                                    }
                                                                ),
                                                              ),
                                                              Builder(
                                                                builder: (context){
                                                                  if(imageDatas.length >= 5) return Container();
                                                                  return Center(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(left: 4),
                                                                      child: IconButton(
                                                                          icon: Icon(FontAwesomeIcons.plus),
                                                                          onPressed: pickImage
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(top: 0, right: 0,
                                                          child:Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                                                                  color: Colors.grey
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 3),
                                                                child: Text("${imageDatas.length}/5"),
                                                              ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ),
                                                )
                                            );
                                          },
                                        ),
                                      ),
                                    ),
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
}