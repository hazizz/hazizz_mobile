import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
<<<<<<< HEAD
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/blocs/text_field_bloc.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
=======
import 'package:flutter_hazizz/blocs/request_event.dart';
import 'package:flutter_hazizz/blocs/response_states.dart';
import 'package:flutter_hazizz/blocs/text_field_bloc.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/PojoGroup.dart';
import 'package:flutter_hazizz/communication/pojos/PojoSubject.dart';
import 'package:flutter_hazizz/communication/pojos/PojoType.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
>>>>>>> 697a6e3b071e12017449a7ca76eb8a9feb3f5ba0
import 'package:meta/meta.dart';

import '../RequestSender.dart';
import 'date_time_picker_bloc.dart';
import 'item_list_picker_bloc/item_list_picker_bloc.dart';

class PickedGroupEvent extends ItemListEvent {
  final PojoGroup item;
  PickedGroupEvent({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedGroupEvent';
}
class PickedGroupState extends ItemListState {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final PojoGroup item;
  PickedGroupState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedGroupState';
}

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
    if (event is LoadData) {
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
            yield Loaded(data: responseData);
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

class PickedSubjectEvent extends ItemListEvent {
  final PojoSubject item;
  PickedSubjectEvent({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedSubjectEvent';
}
class PickedSubjectState extends ItemListState {
  final PojoSubject item;
  PickedSubjectState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedSubjectState';
}

class SubjectLoadData extends ItemListEvent {

  int groupId;

  SubjectLoadData(this.groupId);

  @override
  String toString() => 'SubjectItemListLoadData';
}

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
            yield Loaded(data: responseData);
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

class EditTaskBlocs{
  SubjectItemPickerBloc subjectItemPickerBloc = new SubjectItemPickerBloc();
  GroupItemPickerBloc groupItemPickerBloc;
  DateTimePickerBloc deadlineBloc = new DateTimePickerBloc();
  TitleTextFieldBloc titleTextField = new TitleTextFieldBloc();
  TaskTypePickerBloc taskTypePickerBloc = new TaskTypePickerBloc();

  EditTaskBlocs(){
    groupItemPickerBloc = new GroupItemPickerBloc(subjectItemPickerBloc);
  }

  void send({String title, String description, Function onSuccess})async{
    int groupId;
    int subjectId;
    int typeId;
    DateTime deadline;

    bool missingInfo = false;

    TaskTypePickerState typeState = await taskTypePickerBloc.state.first;
    if(typeState is TaskTypePickedState){
      typeId = typeState.item.id;
    }

    HState subjectState = await subjectItemPickerBloc.state.first;
    if(subjectState is PickedSubjectState) {
      subjectId = subjectState.item.id;
    }else{
      subjectItemPickerBloc.dispatch(NotPickedEvent());
    }

    if(subjectId == null) {
      PickedGroupState groupState = await groupItemPickerBloc.state.first;
      if (groupState is PickedGroupState) {
        groupId = groupState.item.id;
      } else {
        groupItemPickerBloc.dispatch(NotPickedEvent());
        missingInfo = true;
      }
    }

    DateTimePickerState deadlineState = await deadlineBloc.state.first;
    if(deadlineState is DateTimePickedState) {
      deadline = deadlineState.dateTime;
    }else{
      deadlineBloc.dispatch(DateTimeNotPickedEvent());
      missingInfo = true;
    }

    if(missingInfo){
      return;
    }

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
        onSuccess();
      }
    }
  }

  void dispose(){
    groupItemPickerBloc.dispose();
    deadlineBloc.dispose();
    titleTextField.dispose();
    taskTypePickerBloc.dispose();
  }
}











