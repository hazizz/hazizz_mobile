import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/blocs/text_field_bloc.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';

import 'package:meta/meta.dart';

import '../RequestSender.dart';
import 'TextFormBloc.dart';
import 'date_time_picker_bloc.dart';
import 'item_list_picker_bloc/item_list_picker_bloc.dart';

//region TitleTextFieldBloc
class TitleTextFieldBloc extends TextFieldBloc{
  @override
  TextFieldState check(String text) {
    if(text.length < 2){
      return ErrorTooShortState();
    }
    if(text.length > 20){
      return ErrorTooLongState();
    }
    return FineState();
  }
}
//endregion

//region GroupItemPickerBlocParts
//region GroupItemListEvents
class PickedGroupEvent extends ItemListEvent {
  final PojoGroup item;
  PickedGroupEvent({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedGroupEvent';
}
//endregion

//region GroupItemListStates
class PickedGroupState extends ItemListState {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final PojoGroup item;
  PickedGroupState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedGroupState';
}
//endregion

//region GroupItemListBloc
class GroupItemPickerBloc extends ItemListPickerBloc {
  final SubjectItemPickerBloc subjectItemPickerBloc;
  StreamSubscription subjectItemPickerBlocSubscription;
  List<PojoGroup> dataList;


  GroupItemPickerBloc(this.subjectItemPickerBloc) {
    subjectItemPickerBlocSubscription = this.state.listen((state) {
      if (state is PickedGroupState) {
        print("log: picked Group listen");
        subjectItemPickerBloc.dispatch(SubjectLoadData(state.item.id));
      }
    });
  }

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    if (event is PickedGroupEvent) {
      print("log: PickedState is played");
      yield PickedGroupState(item: event.item);
    }
    if (event is ItemListLoadData) {
      try {
        yield Waiting();
        dynamic responseData = await RequestSender().getResponse(
            new GetMyGroups());
        print("log: responseData: ${responseData}");
        print(
            "log: responseData type:  ${responseData.runtimeType.toString()}");

        if (responseData is List<PojoGroup>) {
          dataList = responseData;
          if (dataList.isNotEmpty) {
            print("log: response is List");
            yield ItemListLoaded(data: responseData);
          } else {
            yield Empty();
          }
        }
      } on Exception catch (e) {
        print("log: Exception: ${e.toString()}");
      }
    }
    super.mapEventToState(event);
  }
}
//endregion
//endregion

//region SubjectItemPickerBlocParts
//region SubjectItemListEvents
class PickedSubjectEvent extends ItemListEvent {
  final PojoSubject item;
  PickedSubjectEvent({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedSubjectEvent';
}

class SubjectLoadData extends ItemListEvent {

  int groupId;

  SubjectLoadData(this.groupId);

  @override
  String toString() => 'SubjectItemListLoadData';
}

//endregion

//region SubjectItemListStates
class PickedSubjectState extends ItemListState {
  final PojoSubject item;
  PickedSubjectState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedSubjectState';
}
//endregion

//region SubjectItemListBloc
class SubjectItemPickerBloc extends ItemListPickerBloc {
  List<PojoSubject> dataList;

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async*{
    if(event is PickedSubjectEvent){
      print("log: PickedState is played");
      yield PickedSubjectState(item: event.item);
    }
    if (event is SubjectLoadData) {
      try {
        yield Waiting();
        dynamic responseData = await RequestSender().getResponse(new GetSubjects(groupId: event.groupId));
        print("log: responseData: ${responseData}");
        print("log: responseData type:  ${responseData.runtimeType.toString()}");

        if(responseData is List<PojoSubject>){
          dataList = responseData;
          if(dataList.isNotEmpty) {
            print("log: response is List");
            yield ItemListLoaded(data: responseData);
          }else{
            yield Empty();
          }
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
    super.mapEventToState(event);
  }

  @override
  // TODO: implement initialState
  ItemListState get initialState => Empty();
}
//endregion
//endregion

//region TaskTypePickerBlocParts
//region TaskTypePickerStates
abstract class TaskTypePickerState extends HState {
  TaskTypePickerState([List props = const []]) : super(props);
}
class TaskTypePickedState extends TaskTypePickerState {
  PojoType item;

  TaskTypePickedState(this.item) : assert(item!= null);

  @override
  String toString() => 'PickedState';
}
class HomeworkState extends TaskTypePickerState {
  @override
  String toString() => 'HomeworkState';
}
class TestState extends TaskTypePickerState {
  @override
  String toString() => 'TestState';
}
class OralTestState extends TaskTypePickerState {
  @override
  String toString() => 'OralTestState';
}
class AssignmentState extends TaskTypePickerState {
  @override
  String toString() => 'AssignmentState';
}
//endregion

//region TaskTypePickerEvents
abstract class TaskTypePickerEvent extends HEvent {
  TaskTypePickerEvent([List props = const []]) : super(props);
// ItemListState(this.name) : super([name]);
}
class TaskTypePickedEvent extends TaskTypePickerEvent {
  PojoType type;

  TaskTypePickedEvent(this.type) : assert(type != null);

  @override
  String toString() => 'TaskTypePickEvent';
}
//endregion

//region TaskTypePickerBloc
class TaskTypePickerBloc extends Bloc<TaskTypePickerEvent, TaskTypePickerState>{

  List<PojoType> types = PojoType.pojoTypes;
  PojoType pickedType;

  TaskTypePickerBloc(){
    pickedType = types[0];
  }

  @override
  TaskTypePickerState get initialState =>TaskTypePickedState(types[0]);

  @override
  Stream<TaskTypePickerState> mapEventToState(TaskTypePickerEvent event) async*{
    if(event is TaskTypePickedEvent){
      pickedType = event.type;
      yield TaskTypePickedState(pickedType);
    }
  }
}
//endregion
//endregion

//region EditTask bloc parts
//region EditTask events
abstract class TaskEditEvent extends HEvent {
  TaskEditEvent([List props = const []]) : super(props);
}

class TaskEditSetEditModeEvent extends TaskEditEvent {

  final PojoTask taskToEdit;
  TaskEditSetEditModeEvent({@required this.taskToEdit})
      : assert(taskToEdit != null), super([taskToEdit]);

  @override
  String toString() => 'TaskEditSetEditModeEvent';
}
class TaskEditSetCreateModeEvent extends TaskEditEvent {
  @override
  String toString() => 'TaskEditSetCreateModeEvent';
}

class TaskEditSendEvent extends TaskEditEvent {
  @override
  String toString() => 'TaskEditSendEvent';
}
//endregion

//region SubjectItemListStates
abstract class TaskEditState extends HState {
  TaskEditState([List props = const []]) : super(props);
}

class TaskEditInitialState extends TaskEditState {
  @override
  String toString() => 'TaskEditInitialState';
}

class TaskEditModeEditState extends TaskEditState {
  final PojoTask taskToEdit;
  TaskEditModeEditState({@required this.taskToEdit})
      : assert(taskToEdit != null), super([taskToEdit]);
  @override
  String toString() => 'TaskEditModeEditState';
}

class TaskEditModeCreateState extends TaskEditState {
  @override
  String toString() => 'TaskEditModeCreateState';
}

class TaskEditSentState extends TaskEditState {
  @override
  String toString() => 'TaskEditSentState';
}

class TaskEditWaiting extends TaskEditState {
  @override
  String toString() => 'TaskEditWaiting';
}

//endregion

//region SubjectItemListBloc
class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {

  PojoTask taskToEdit;

  EditTaskMode mode;

  GroupItemPickerBloc groupItemPickerBloc;
  SubjectItemPickerBloc subjectItemPickerBloc = new SubjectItemPickerBloc();
  DateTimePickerBloc deadlineBloc = new DateTimePickerBloc();
  TaskTypePickerBloc taskTypePickerBloc = new TaskTypePickerBloc();
//  TitleTextFieldBloc titleTextField = new TitleTextFieldBloc();

  TextFormBloc titleBloc;
  TextFormBloc descripitonBloc;

  TaskEditBloc.create({@required this.groupItemPickerBloc, @required this.subjectItemPickerBloc,
    @required this.deadlineBloc, @required this.taskTypePickerBloc,
    @required this.titleBloc, @required this.descripitonBloc,
  }){
    mode = EditTaskMode.create;
    this.dispatch(TaskEditSetCreateModeEvent());

  }
  TaskEditBloc.edit({@required this.groupItemPickerBloc, @required this.subjectItemPickerBloc,
    @required this.deadlineBloc, @required this.taskTypePickerBloc, @required this.titleBloc,
    @required this.descripitonBloc, @required this.taskToEdit
  }){
    mode = EditTaskMode.edit;
    this.dispatch(TaskEditSetEditModeEvent(taskToEdit: taskToEdit));
  }

  @override
  Stream<TaskEditState> mapEventToState(TaskEditEvent event) async*{
    if(event is TaskEditSetCreateModeEvent){
      yield TaskEditModeCreateState();
    }else if(event is TaskEditSetEditModeEvent){
      print("log: TaskEditSetEditModeEvent");
      groupItemPickerBloc.dispatch(PickedGroupEvent(item: event.taskToEdit.group));
      subjectItemPickerBloc.dispatch(PickedSubjectEvent(item: event.taskToEdit.subject));
      deadlineBloc.dispatch(DateTimePickedEvent(dateTime: event.taskToEdit.dueDate));
      taskTypePickerBloc.dispatch(TaskTypePickedEvent(event.taskToEdit.type));

    //  groupItemPickerBloc.dispatch(PickedGroupEvent(item: event.taskToEdit.group));

      yield TaskEditModeEditState(taskToEdit: event.taskToEdit);
    }
    if (event is TaskEditSendEvent) {
      try {
        yield TaskEditWaiting();

        //region send
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
          print("log: missing info");
          return;
        }
        print("log: not missing info");

        dynamic response;

        if(mode == EditTaskMode.create) {
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
            yield TaskEditSentState();
          }
        }
        //endregion

      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }

  @override
  TaskEditState get initialState => TaskEditInitialState();

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

enum EditTaskMode{ edit, create }

class EditTaskBlocs{

  EditTaskMode mode;
  PojoTask taskToEdit;

  TaskEditBloc taskEditBloc;
  GroupItemPickerBloc groupItemPickerBloc;
  SubjectItemPickerBloc subjectItemPickerBloc = new SubjectItemPickerBloc();
  DateTimePickerBloc deadlineBloc = new DateTimePickerBloc();
  TaskTypePickerBloc taskTypePickerBloc = new TaskTypePickerBloc();
  TextFormBloc titleBloc = TextFormBloc(validate: null);
  TextFormBloc descriptionBloc = TextFormBloc(validate: null);

  EditTaskBlocs.create(){
    groupItemPickerBloc = new GroupItemPickerBloc(subjectItemPickerBloc);
    mode = EditTaskMode.create;
    taskEditBloc = TaskEditBloc.create(groupItemPickerBloc: groupItemPickerBloc, subjectItemPickerBloc: subjectItemPickerBloc,
      deadlineBloc: deadlineBloc,taskTypePickerBloc: taskTypePickerBloc, titleBloc: titleBloc, descripitonBloc: descriptionBloc
    );
  }

  EditTaskBlocs.edit(PojoTask task){
    groupItemPickerBloc = new GroupItemPickerBloc(subjectItemPickerBloc);
    mode = EditTaskMode.edit;
    taskToEdit = task;

    taskEditBloc = TaskEditBloc.edit(groupItemPickerBloc: groupItemPickerBloc, subjectItemPickerBloc: subjectItemPickerBloc,
        deadlineBloc: deadlineBloc, taskTypePickerBloc: taskTypePickerBloc, titleBloc: titleBloc,
        descripitonBloc: descriptionBloc, taskToEdit: taskToEdit,
    );
    //titleBloc.dispatch(event);
  }

  void dispose(){
    groupItemPickerBloc.dispose();
    subjectItemPickerBloc.dispose();
    deadlineBloc.dispose();
    taskTypePickerBloc.dispose();
    titleBloc.dispose();
    descriptionBloc.dispose();
  }
}











