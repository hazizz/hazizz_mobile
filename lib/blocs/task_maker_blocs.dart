
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

enum TaskMakerMode{
  create,edit
}

abstract class TaskMakerBloc extends Bloc<TaskMakerEvent, TaskMakerState> {
  
}


abstract class TaskMakerBlocs{
  TaskMakerBloc taskMakerBloc;
  GroupItemPickerBloc groupItemPickerBloc;
  SubjectItemPickerBloc subjectItemPickerBloc;
  DateTimePickerBloc deadlineBloc;
  TaskTypePickerBloc taskTypePickerBloc;
  TextFormBloc titleBloc;
  TextFormBloc descriptionBloc;
//  void dispose();

  void dispose(){
    taskMakerBloc.dispose();
    groupItemPickerBloc.dispose();
    subjectItemPickerBloc.dispose();
    deadlineBloc.dispose();
    taskTypePickerBloc.dispose();
    titleBloc.dispose();
    descriptionBloc.dispose();
  }
}

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

  /*
  @override
  // TODO: implement initialState
  ItemListState get initialState => LoadData();
  */

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
        print("log: responseData: $responseData");
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

abstract class TaskMakerState extends HState {
  TaskMakerState([List props = const []]) : super(props);
}

class TaskMakerWaitingState extends TaskMakerState {
  @override
  String toString() => 'TaskMakerWaitingState';
}

class TaskMakerSentState extends TaskMakerState {
  @override
  String toString() => 'TaskMakerSentState';
}


abstract class TaskMakerEvent extends HEvent {
  TaskMakerEvent([List props = const []]) : super(props);
}

class TaskMakerSendEvent extends TaskMakerEvent {
  @override
  String toString() => 'TaskMakerSendEvent';
}


