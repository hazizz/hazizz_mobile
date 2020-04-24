
import 'package:flutter/material.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/managers/app_state_restorer.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';

//region EditTask bloc parts
//region EditTask events


//endregion

//region SubjectItemListStates

abstract class TaskEditEvent extends TaskMakerEvent {
  TaskEditEvent([List props = const []]) : super(props);
}

class InitializeTaskEditEvent extends TaskEditEvent {
  final PojoTask taskToEdit;
  InitializeTaskEditEvent({@required this.taskToEdit}) : assert(taskToEdit != null),  super([taskToEdit]);
  @override
  String toString() => 'InitializeTaskEditEvent';
  List<Object> get props => [taskToEdit];
}

abstract class TaskEditState extends TaskMakerState {
  TaskEditState([List props = const []]) : super(props);
}

class InitializedTaskEditState extends TaskEditState {
  final PojoTask taskToEdit;
  InitializedTaskEditState({@required this.taskToEdit}) : assert(taskToEdit != null),  super([taskToEdit]);

  String toString() => 'InitializeTaskEditState';
  List<Object> get props => [taskToEdit];
}

//endregion

//region SubjectItemListBloc
class TaskEditBloc extends TaskMakerBloc {

  final PojoTask taskToEdit;


 // int imageIndex = 0;
 // String imageUrls = "";

 // GroupItemPickerBloc groupItemPickerBloc;
 // SubjectItemPickerBloc subjectItemPickerBloc;
   PojoGroup group;
   PojoSubject subject;

  TaskMakerAppState taskMakerAppState;


  TaskEditBloc({this.taskToEdit, this.taskMakerAppState}) : super(){
    if(taskToEdit != null){
      group = taskToEdit.group;
      subject = taskToEdit.subject ;//!= null ? taskToEdit.subject : getEmptyPojoSubject(c);

      descriptionController.text = taskToEdit.description;

      descriptionController.selection = TextSelection.fromPosition(TextPosition(offset: descriptionController.text.length));

      HazizzLogger.printLog("log: descr: ${descriptionController.text}");


      deadlineBloc.add(DateTimePickedEvent(dateTime: taskToEdit.dueDate));
      // taskTagBloc.add(TaskTypePickedEvent(taskToEdit.tags[0]));
      for(PojoTag t in taskToEdit.tags){
        taskTagBloc.add(TaskTagAddEvent(t));
      }

      groupItemPickerBloc.add(SetGroupEvent(item: taskToEdit.group != null ? taskToEdit.group : PojoGroup(0, "", "", "", 0) ));

      subjectItemPickerBloc.add(SetSubjectEvent(item: taskToEdit.subject != null ? taskToEdit.subject : PojoSubject(0, "", false, null, false)));

      List<String> splited = taskToEdit.description.split("\n![img_");
      /* for(int i = 1; i < splited.length; i++){
      imageUrls += "\n![img_" + splited[i];
      imageIndex++;
    }*/
      descriptionBloc.add(TextFormSetEvent(text: splited[0]));
    }else if(taskMakerAppState != null){
      PojoTask t = taskMakerAppState.pojoTask;

      for(PojoTag t in t.tags){
        taskTagBloc.add(TaskTagAddEvent(t));
      }

      subjectItemPickerBloc.add(PickedSubjectEvent(item: t.subject));
      groupItemPickerBloc.add(PickedGroupEvent(item: t.group));
      descriptionBloc.add(TextFormSetEvent(text: t.description));
      deadlineBloc.add(DateTimePickedEvent(dateTime: t.dueDate));
    }
  }

  @override
  Stream<TaskMakerState> mapEventToState(TaskMakerEvent event) async*{
    if(event is InitializeTaskEditEvent){

      yield InitializedTaskEditState(taskToEdit: taskToEdit);


    }
    if (event is TaskMakerSendEvent) {
      try {
        yield TaskMakerWaitingState();

        //region send
        int subjectId;
        List<String> tags = List();
        DateTime deadline;
        String description;

        bool missingInfo = false;

        taskTagBloc.pickedTags.forEach((f){tags.add(f.name);});


        if(subject != null){
          subjectId = subject.id;
        }

        DateTimePickerState deadlineState = deadlineBloc.state;
        if(deadlineState is DateTimePickedState) {
          deadline = deadlineState.dateTime;
        }else{
          HazizzLogger.printLog("log: missing: deadline");
          deadlineBloc.add(DateTimeNotPickedEvent());
          missingInfo = true;
        }

        description = descriptionBloc.lastText;

        if(missingInfo){
          HazizzLogger.printLog("log: missing info");
          this.add(TaskMakerFailedEvent());
          return;
        }
        HazizzLogger.printLog("log: not missing info");

        String newImageUrlsDesc = "";

        if(event.imageDatas != null && event.imageDatas.isNotEmpty){
          print("counter0: ${event.imageDatas.length}");


          List<Future> futures = [];
          for(HazizzImageData d in event.imageDatas){
            if(d.imageType == ImageType.FILE){
              futures.add(d.futureUploadedToDrive);
            }
          }
          await Future.wait(futures);
          int imageIndex = 0;
          for(HazizzImageData d in event.imageDatas){
          //  if(d.imageType == ImageType.FILE){
              imageIndex++;
              print("counter1: ${d.url}");

              newImageUrlsDesc += "\n![img_$imageIndex](${d.url.split("&")[0]})";
          //  }
          }
        }

        HazizzResponse hazizzResponse;

        hazizzResponse = await getResponse(new EditTask(
          taskId: taskToEdit.id,
          b_tags: tags,
          b_description: description /*+ imageUrls*/ + newImageUrlsDesc,
          b_deadline: deadline,
          b_salt: event.salt
        ));


        if(hazizzResponse.isSuccessful){
          if(event.imageDatas != null && event.imageDatas.isNotEmpty){
            int taskId = (hazizzResponse.convertedData as PojoTask).id;
            event.imageDatas.forEach((HazizzImageData hazizzImageData){
              hazizzImageData.renameFile(taskId);
            });
          }
          yield TaskMakerSuccessfulState(hazizzResponse.convertedData);
        }else{
          yield TaskMakerFailedState();
        }
        //endregion

      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }

  @override
  TaskEditState get initialState => InitializedTaskEditState(taskToEdit: taskToEdit);
}
//endregion
//endregion









