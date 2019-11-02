
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
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';

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

 // GroupItemPickerBloc groupItemPickerBloc;
 // SubjectItemPickerBloc subjectItemPickerBloc;
   PojoGroup group;
   PojoSubject subject;

  TaskEditBloc({@required this.taskToEdit}) : super(){
    group = taskToEdit.group;
    subject = taskToEdit.subject ;//!= null ? taskToEdit.subject : getEmptyPojoSubject(c);


    descriptionController.text = taskToEdit.description;
    titleController.text = taskToEdit.title;

    descriptionController.selection = TextSelection.fromPosition(TextPosition(offset: descriptionController.text.length));
    titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));


    HazizzLogger.printLog("log: descr: ${descriptionController.text}");
    HazizzLogger.printLog("log: title: ${titleController.text}");


    deadlineBloc.dispatch(DateTimePickedEvent(dateTime: taskToEdit.dueDate));
   // taskTagBloc.add(TaskTypePickedEvent(taskToEdit.tags[0]));

    for(PojoTag t in taskToEdit.tags){
      taskTagBloc.dispatch(TaskTagAddEvent(t));
    }

      groupItemPickerBloc.dispatch(SetGroupEvent(item: taskToEdit.group != null ? taskToEdit.group : PojoGroup(0, "", "", "", 0) ));

      subjectItemPickerBloc.dispatch(SetSubjectEvent(item: taskToEdit.subject != null ? taskToEdit.subject : PojoSubject(0, "", false, null, false)));


    titleBloc.dispatch(TextFormSetEvent(text: taskToEdit.title));
    descriptionBloc.dispatch(TextFormSetEvent(text: taskToEdit.description));
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
        int groupId, subjectId;
        List<String> tags = List();
        DateTime deadline;
        String title, description;

        bool missingInfo = false;

        /*
        TaskTypePickerState typeState = taskTypePickerBloc.currentState;
        if(typeState is TaskTypePickedState){
          tags[0] = typeState.tag.getName();
        }
        */

        taskTagBloc.pickedTags.forEach((f){tags.add(f.getName());});


        if(subject != null){
          subjectId = subject.id;
        }

        if(group != null){
          groupId = group.id;
        }

        DateTimePickerState deadlineState = deadlineBloc.currentState;
        if(deadlineState is DateTimePickedState) {
          deadline = deadlineState.dateTime;
        }else{
          HazizzLogger.printLog("log: missing: deadline");
          deadlineBloc.dispatch(DateTimeNotPickedEvent());
          missingInfo = true;
        }

        HFormState titleState = titleBloc.currentState;
        if(titleState is TextFormFine || titleState is TextFormSetState){
          title = titleBloc.lastText;
        }else{
          HazizzLogger.printLog("log: missing: title");
          missingInfo = true;
        }
        HFormState descriptionState = descriptionBloc.currentState;
        /*
        if(descriptionState is TextFormFine ||descriptionState is TextFormSetState){
          description = descriptionBloc.lastText;
        }else{
          HazizzLogger.printLog("log: missing: description");
          missingInfo = true;
        }
        */
        description = descriptionBloc.lastText;

        if(missingInfo){
          HazizzLogger.printLog("log: missing info");
          this.dispatch(TaskMakerFailedEvent());
          return;
        }
        HazizzLogger.printLog("log: not missing info");

        HazizzResponse hazizzResponse;

        if(subjectId != null) {
          hazizzResponse = await RequestSender().getResponse(new EditTask(
              taskId: taskToEdit.id,
              b_tags: tags,
              b_title: title,
              b_description: description,
              b_deadline: deadline
          ));
        }else {
          hazizzResponse = await RequestSender().getResponse(new EditTask(
              taskId: taskToEdit.id,
              b_tags: tags,
              b_title: title,
              b_description: description,
              b_deadline: deadline
          ));
        }

        if(hazizzResponse.isSuccessful){
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









