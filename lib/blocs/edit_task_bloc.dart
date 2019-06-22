
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/blocs/task_maker_blocs.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import '../RequestSender.dart';
import 'TextFormBloc.dart';
import 'date_time_picker_bloc.dart';
import 'item_list_picker_bloc/item_list_picker_bloc.dart';

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
}

abstract class TaskEditState extends TaskMakerState {
  TaskEditState([List props = const []]) : super(props);
}

class InitializedTaskEditState extends TaskEditState {
  final PojoTask taskToEdit;
  InitializedTaskEditState({@required this.taskToEdit}) : assert(taskToEdit != null),  super([taskToEdit]);

  String toString() => 'InitializeTaskEditState';
}


/*
class TaskEditSentState extends TaskEditState {
  @override
  String toString() => 'TaskEditSentState';
}

class TaskEditWaiting extends TaskEditState {
  @override
  String toString() => 'TaskEditWaiting';
}
*/

//endregion

//region SubjectItemListBloc
class TaskEditBloc extends TaskMakerBloc {

  final PojoTask taskToEdit;

 // GroupItemPickerBloc groupItemPickerBloc;
 // SubjectItemPickerBloc subjectItemPickerBloc;
  final PojoGroup group;
  final PojoSubject subject;

  DateTimePickerBloc deadlineBloc;
  TaskTypePickerBloc taskTypePickerBloc;
  TextFormBloc titleBloc;
  TextFormBloc descriptionBloc;


  TaskEditBloc({@required this.group, @required this.subject,
    @required this.deadlineBloc, @required this.taskTypePickerBloc,
    @required this.titleBloc, @required this.descriptionBloc, this.taskToEdit
  });

  /*
  TaskCreateBloc({this.group}){
    groupItemPickerBloc = new GroupItemPickerBloc(subjectItemPickerBloc);
  }
  */

  @override
  Stream<TaskMakerState> mapEventToState(TaskMakerEvent event) async*{
    if(event is InitializeTaskEditEvent){

      yield InitializedTaskEditState(taskToEdit: taskToEdit);


    }
    if (event is TaskMakerSendEvent) {
      try {
        yield TaskMakerWaitingState();

        //region send
        int groupId, subjectId, typeId;
        DateTime deadline;
        String title, description;

        bool missingInfo = false;

        TaskTypePickerState typeState = taskTypePickerBloc.currentState;
        if(typeState is TaskTypePickedState){
          typeId = typeState.item.id;
        }

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
          deadlineBloc.dispatch(DateTimeNotPickedEvent());
          missingInfo = true;
        }

        HFormState titleState = titleBloc.currentState;
        if(titleState is TextFormFine){
          title = titleBloc.lastText;
        }else{
          missingInfo = true;
        }
        HFormState descriptionState = descriptionBloc.currentState;
        if(descriptionState is TextFormFine){
          description = descriptionBloc.lastText;
        }else{
          missingInfo = true;
        }

        if(missingInfo){
          print("log: missing info");
          return;
        }
        print("log: not missing info");

        dynamic response;

        if(subjectId != null) {
          response = await RequestSender().getResponse(new CreateTask(
              subjectId: subjectId,
              b_taskType: typeId,
              b_title: title,
              b_description: description,
              b_deadline: deadline
          ));
        }else {
          response = await RequestSender().getResponse(new CreateTask(
              groupId: groupId,
              b_taskType: typeId,
              b_title: title,
              b_description: description,
              b_deadline: deadline
          ));
        }

        if(!(response is PojoError)){
          Response resp = response;
          if(resp.statusCode == 201){
            yield TaskMakerSentState();
          }
        }
        //endregion

      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }

  @override
  TaskEditState get initialState => InitializedTaskEditState(taskToEdit: taskToEdit);

/*void send() async{
    int groupId, subjectId, typeId;
    DateTime deadline;
    String title, description;

    bool missingInfo = false;

    TaskTypePickerState typeState = taskTypePickerBloc.currentState;
    if(typeState is TaskTypePickedState){
      typeId = typeState.item.id;
    }

    HState subjectState = subjectItemPickerBloc.currentState;
    if(subjectState is PickedSubjectState) {
      subjectId = subjectState.item.id;
    }else{
      subjectItemPickerBloc.dispatch(NotPickedEvent());
    }

    if(subjectId == null) {
      PickedGroupState groupState = await groupItemPickerBloc.currentState;
      if (groupState is PickedGroupState) {
        groupId = groupState.item.id;
      } else {
        groupItemPickerBloc.dispatch(NotPickedEvent());
        missingInfo = true;
      }
    }

    DateTimePickerState deadlineState = deadlineBloc.currentState;
    if(deadlineState is DateTimePickedState) {
      deadline = deadlineState.dateTime;
    }else{
      deadlineBloc.dispatch(DateTimeNotPickedEvent());
      missingInfo = true;
    }

    HFormState titleState = titleBloc.currentState;
    if(titleState is TextFormFine){
      title = titleBloc.lastText;
    }else{
      missingInfo = true;
    }
    HFormState descriptionState = descripitonBloc.currentState;
    if(descriptionState is TextFormFine){
      description = descripitonBloc.lastText;
    }else{
      missingInfo = true;
    }

    if(missingInfo){
      return;
    }

    dynamic response;

    if(mode == TaskEditMode.create) {
      if(subjectId != null) {
        response = await RequestSender().getResponse(new CreateTask(
            subjectId: subjectId,
            b_taskType: typeId,
            b_title: title,
            b_description: description,
            b_deadline: deadline
        ));
      }else {
        response = await RequestSender().getResponse(new CreateTask(
            groupId: groupId,
            b_taskType: typeId,
            b_title: title,
            b_description: description,
            b_deadline: deadline
        ));
      }
    }else{
      response = await RequestSender().getResponse(new EditTask(
          taskId: taskToEdit.id,
          groupId: taskToEdit.group.id,
          b_taskType: typeId,
          b_title: title,
          b_description: description,
          b_deadline: deadline
      ));
    }

    if(!(response is PojoError)){
      Response resp = response;
      if(resp.statusCode == 201){
        onSuccess();
      }
    }
  }*/


}
//endregion
//endregion

class TaskEditBlocs extends TaskMakerBlocs{
  /*
  TaskEditBloc taskEditBloc;
 // GroupItemPickerBloc groupItemPickerBloc;
 // SubjectItemPickerBloc subjectItemPickerBloc = new SubjectItemPickerBloc();
  DateTimePickerBloc deadlineBloc = new DateTimePickerBloc();
  TaskTypePickerBloc taskTypePickerBloc = new TaskTypePickerBloc();
  TextFormBloc titleBloc = TextFormBloc(validate: null);
  TextFormBloc descriptionBloc = TextFormBloc(validate: null);
  */

  TaskEditBlocs({PojoTask taskToEdit}){

    deadlineBloc.dispatch(DateTimePickedEvent(dateTime: taskToEdit.dueDate));
    taskTypePickerBloc.dispatch(TaskTypePickedEvent(taskToEdit.type));
    // TODO this is wrong ˇ
    titleBloc.dispatch(TextFormValidate(text: taskToEdit.title));
    descriptionBloc.dispatch(TextFormValidate(text: taskToEdit.description));


  //  groupItemPickerBloc = new GroupItemPickerBloc(subjectItemPickerBloc);
    taskMakerBloc = TaskEditBloc(group: taskToEdit.group, subject: taskToEdit.subject,
        deadlineBloc: deadlineBloc,taskTypePickerBloc: taskTypePickerBloc, titleBloc: titleBloc, descriptionBloc: descriptionBloc
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}











