
import 'package:flutter/material.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/extension_methods/duration_extension.dart';
import 'package:googleapis/drive/v3.dart' as driveapi;
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';
import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/managers/app_state_restorer.dart';
import 'package:mobile/services/task_similarity_checker.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';

import '../../managers/google_drive_manager.dart';


//region EditTask bloc parts
//region EditTask events
abstract class TaskCreateEvent extends TaskMakerEvent {
  TaskCreateEvent([List props = const []]) : super(props);
}

class InitializeTaskCreateEvent extends TaskCreateEvent {
  final PojoGroup group;
  InitializeTaskCreateEvent({this.group}) :   super([group]);
  @override
  String toString() => 'InitializeTaskCreateState';
  List<Object> get props => [group];
}

class TaskMakerProceedToSendEvent extends TaskMakerEvent {
  TaskMakerProceedToSendEvent();
  @override
  String toString() => 'TaskMakerProceedToSendEvent';
  List<Object> get props => null;
}

//endregion

//region TaskCreate state
abstract class TaskCreateState extends TaskMakerState {
  TaskCreateState([List props = const []]) : super(props);
}

class InitializedTaskCreateState extends TaskCreateState {
  final PojoGroup group;
  InitializedTaskCreateState({this.group}) : super([group]);

  String toString() => 'InitializeTaskEditState';
  List<Object> get props => [group];
}

class SimilarTasksTaskCreateState extends TaskCreateState {
  final List<TaskSimilarity> similarTasks;
  SimilarTasksTaskCreateState({this.similarTasks}) : super([similarTasks]);

  String toString() => 'SimilarTasksTaskCreateState';
  List<Object> get props => [similarTasks];
}
//endregion

//region TaskCreate bloc
class TaskCreateBloc extends TaskMakerBloc {

  int groupId, subjectId;
  List<String> tags = List();
  DateTime deadline;
  String description;

  String salt;

  List<HazizzImageData> imageDatas;

  List<String> imageUrls = [];
  String imageUrlsDesc;

  PojoGroup group;

  TaskMakerAppState taskMakerAppState;

  TaskCreateBloc({this.group, this.taskMakerAppState}) : super(){

    if(taskMakerAppState != null){
      PojoTask t = taskMakerAppState.pojoTask;

      for(PojoTag t in t.tags){
        taskTagBloc.dispatch(TaskTagAddEvent(t));
      }

      if(t.subject != null) subjectItemPickerBloc.dispatch(PickedSubjectEvent(item: t.subject));
      if(t.group != null) groupItemPickerBloc.dispatch(PickedGroupEvent(item: t.group));
      if(t.description != null) descriptionBloc.dispatch(TextFormSetEvent(text: t.description));
      if(t.dueDate != null) deadlineBloc.dispatch(DateTimePickedEvent(dateTime: t.dueDate));
    }else{
      taskTagBloc.dispatch(TaskTagAddEvent(PojoTag.defaultTags[0]));
    }
  }


 
  @override
  Stream<TaskMakerState> mapEventToState(TaskMakerEvent event) async*{

    Future<TaskMakerState> sendTaskPart2() async {
      List<String> imageUrls = [];
      String imageUrlsDesc = "";

      if(imageDatas != null && imageDatas.isNotEmpty){
        print("counter0: ${imageDatas.length}");
        int i = 0;

        List<Future> futures = [];
        for(HazizzImageData d in imageDatas){
          futures.add(d.futureUploadedToDrive);
        }
        await Future.wait(futures);

        for(HazizzImageData d in imageDatas){
          i++;
          print("counter1: ${d.url}");

          imageUrlsDesc += "\n![img_$i](${d.url.split("&")[0]})";
        }
      }

      HazizzLogger.printLog("BEFORE POIOP: ${groupId}, ${subjectId},");



      if(imageDatas != null && imageDatas.isNotEmpty){
        print("majas1: ${imageDatas[0]}");

        print("majas2: ${imageDatas[0]?.key}");

        print("majas3: ${imageUrls}");
        print("majas4: ${description}");

        print("majas5: ${imageUrlsDesc}");

        print("leírás hosz: ${(description + imageUrlsDesc).length}");
      }

      HazizzResponse hazizzResponse = await getResponse(new CreateTask(
          groupId: groupId,
          subjectId: subjectId,
          b_tags: tags,
          b_description: imageDatas.isEmpty ? description : description + "\n" + imageUrlsDesc,
          b_deadline: deadline,
          b_salt: imageDatas.isEmpty ? null : salt
      ));

      print("majas3: broo");
      if(hazizzResponse.isSuccessful){
        if(imageDatas != null && imageDatas.isNotEmpty){
          int taskId = (hazizzResponse.convertedData as PojoTask).id;
          imageDatas.forEach((HazizzImageData hazizzImageData){
            hazizzImageData.renameFile(taskId);
          });
        }
        HazizzLogger.printLog("log: task making was succcessful");
        return TaskMakerSuccessfulState(hazizzResponse.convertedData);
        MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
      }else{
        return TaskMakerFailedState();
      }
    }

    if(event is TaskMakerFailedEvent){
      yield TaskMakerFailedState();
    }
    if(event is InitializeTaskCreateEvent){
      yield InitializedTaskCreateState(group: event.group);

      if(group != null) {
        groupItemPickerBloc.dispatch(PickedGroupEvent(item: group));
      }
    }

    if(event is TaskMakerProceedToSendEvent ){
      yield TaskMakerWaitingState();
      yield await sendTaskPart2();
    }
    else if(event is TaskMakerSaveStateEvent){
      PojoGroup group;
      PojoSubject subject;
      List<String> tags = List();
      DateTime deadline;
      String description;

      String salt = event.salt;

      taskTagBloc.pickedTags.forEach((f){tags.add(f.name);});


      HazizzLogger.printLog("nuno: 1");


      ItemListState groupState =  groupItemPickerBloc.currentState;

      if (groupState is PickedGroupState) {
        group = groupItemPickerBloc.pickedItem;
        HazizzLogger.printLog("nuno: 2");
      }
      HState subjectState = subjectItemPickerBloc.currentState;
      if(subjectState is PickedSubjectState) {
        subject = subjectState.item;
      }

      DateTimePickerState deadlineState = deadlineBloc.currentState;
      if(deadlineState is DateTimePickedState) {
        deadline = deadlineState.dateTime;
      }


      description = descriptionBloc.lastText ?? "";


      PojoTask pojoTaskToSave = PojoTask(
        salt: salt,
        group: group,
        subject: subject,
        description: description,
        tags: taskTagBloc.pickedTags,
        dueDate: deadline
      );
      HazizzLogger.printLog("nuno: 3");


      List<String> imagePaths = [];
      for(HazizzImageData i in event.imageDatas){
        if(i.imageType == ImageType.FILE){
          imagePaths.add(i.imageFile.path);
        }else if(i.imageType == ImageType.GOOGLE_DRIVE){
          imagePaths.add(i.url);
        }
      }

      AppStateRestorer.saveTaskState(TaskMakerAppState(
        pojoTask: pojoTaskToSave,
        taskMakerMode: TaskMakerMode.create,
        imagePaths: imagePaths
      ));
      HazizzLogger.printLog("nuno: finished");



    }
    else if (event is TaskMakerSendEvent) {
      HazizzLogger.printLog("log: event: TaskMakerSendEvent");
      try {
        yield TaskMakerWaitingState();

        bool missingInfo = false;
        HazizzLogger.printLog("log: lul1");

        //region send

        salt = event.salt;

        taskTagBloc.pickedTags.forEach((f){tags.add(f.name);});

        ItemListState groupState =  groupItemPickerBloc.currentState;

        if (groupState is PickedGroupState) {
          groupId = groupItemPickerBloc.pickedItem.id;
          HazizzLogger.printLog("log: lulu0");
        } else {
          HazizzLogger.printLog("log: lulu1");
          groupItemPickerBloc.dispatch(NotPickedEvent());
          HazizzLogger.printLog("log: lulu2");
          missingInfo = true;
        }


        HState subjectState = subjectItemPickerBloc.currentState;
        if(subjectState is PickedSubjectState) {
          subjectId = subjectState.item.id;
        }else{
          if(groupId != 0){
            HazizzLogger.printLog("log: subjectItemPickerBloc.add(NotPickedEvent());");

            subjectItemPickerBloc.dispatch(NotPickedEvent());
            missingInfo = true;
          }
        }
        HazizzLogger.printLog("log: lul12");

        HazizzLogger.printLog("log: lul2");


        DateTimePickerState deadlineState = deadlineBloc.currentState;
        if(deadlineState is DateTimePickedState) {
          deadline = deadlineState.dateTime;
        }else{
          deadlineBloc.dispatch(DateTimeNotPickedEvent());
          missingInfo = true;
        }

        imageDatas = event.imageDatas;

        if(missingInfo){
          HazizzLogger.printLog("log: missing info");
          this.dispatch(TaskMakerFailedEvent());
          return;
        }

        description = descriptionBloc.lastText ?? "";

        // Check task similarity

        if(false){
          HazizzResponse hazizzResponse = await getResponse(
              GetTasksFromMe(
                q_showThera:false,
                q_startingDate: (deadline - 7.days).hazizzRequestDateFormat,
                q_endDate: (deadline + 7.days).hazizzRequestDateFormat,
                q_groupId: groupId,
                q_subjectId: subjectId,
                q_wholeGroup: true
              )
          );
          if(hazizzResponse.isSuccessful){
            List<PojoTask> tasks = hazizzResponse.convertedData;
            if(tasks.isNotEmpty) {
              List<TaskSimilarity> similarTasks = checkTaskSimilarity(description, subjectId, deadline, tasks);
              if(similarTasks.isNotEmpty){
                yield SimilarTasksTaskCreateState(similarTasks: similarTasks);
                return;
              }
            }
          }
        }

        HazizzLogger.printLog("log: lul3");



        HazizzLogger.printLog("log: not missing info");

        yield await sendTaskPart2();

        //endregion

      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }

  @override
  TaskCreateState get initialState => InitializedTaskCreateState(group: group);

}
//endregion
//endregion












