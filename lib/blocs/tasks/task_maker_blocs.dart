
import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';

import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/custom/image_operations.dart';

enum TaskMakerMode{ create,edit }

abstract class TaskMakerBloc extends Bloc<TaskMakerEvent, TaskMakerState> {
  GroupItemPickerBloc groupItemPickerBloc;
  SubjectItemPickerBloc subjectItemPickerBloc;
  DateTimePickerBloc deadlineBloc;
  TaskTagBloc taskTagBloc;
  TextFormBloc descriptionBloc;

  final TextEditingController descriptionController = TextEditingController();



  TaskMakerBloc(){
    subjectItemPickerBloc = SubjectItemPickerBloc();
    groupItemPickerBloc = GroupItemPickerBloc(subjectItemPickerBloc);
    deadlineBloc = DateTimePickerBloc();
    taskTagBloc = TaskTagBloc();

    descriptionBloc = TextFormBloc();

    descriptionController.addListener((){
      String text = descriptionController.text;
      descriptionBloc.add(TextFormValidate(text: text));
    });

    groupItemPickerBloc.add(ItemListLoadData());
  }

  @override
  Future<void> close() {
    groupItemPickerBloc.close();
    subjectItemPickerBloc.close();
    deadlineBloc.close();
    taskTagBloc.close();
    descriptionBloc.close();
  
    return super.close();
  }
}

//region GroupItemPickerBlocParts
//region GroupItemListEvents
class PickedGroupEvent extends ItemListEvent {
  final PojoGroup item;
  PickedGroupEvent({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedGroupEvent';
  List<Object> get props => [item];
}

class SetGroupEvent extends ItemListEvent {
  final PojoGroup item;
  SetGroupEvent({@required this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'SetGroupEvent';
  List<Object> get props => [item];
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
  List<Object> get props => [item];
}
//endregion

//region GroupItemListBloc
class GroupItemPickerBloc extends ItemListPickerBloc {
  final SubjectItemPickerBloc subjectItemPickerBloc;
  StreamSubscription subjectItemPickerBlocSubscription;
  List<PojoGroup> dataList;

  bool isLocked = false;


  @override
  ItemListState get initialState => InitialState();

  GroupItemPickerBloc(this.subjectItemPickerBloc) {
    subjectItemPickerBlocSubscription = this.listen((state) {
      if (state is PickedGroupState) {
        HazizzLogger.printLog("log: picked Group listen");
        if(state.item.id != 0) {
          subjectItemPickerBloc.add(SubjectLoadData(state.item.id));
        }
      }
    });
  }

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {

    HazizzLogger.printLog("GroupBloc: $state");

    if(event is SetGroupEvent){
      isLocked = true;
      pickedItem = event.item;
      yield PickedGroupState(item: event.item);
    }
    if(!isLocked) {
      if(event is PickedGroupEvent) {
        HazizzLogger.printLog("log: PickedState is played");
        pickedItem = event.item;

        yield PickedGroupState(item: event.item);
      }
      if(event is ItemListLoadData) {
        try {
          yield Waiting();
          HazizzResponse hazizzResponse = await RequestSender().getResponse(
              new GetMyGroups());
          HazizzLogger.printLog("log: responseData: ${hazizzResponse.convertedData}");
          HazizzLogger.printLog(
              "log: responseData type:  ${hazizzResponse.convertedData
                  .runtimeType.toString()}");

          if(hazizzResponse.isSuccessful) {
            dataList = hazizzResponse.convertedData;
            if(dataList.isNotEmpty) {
              HazizzLogger.printLog("log: response is List");
              yield ItemListLoaded(data: dataList);
            }else{
              yield ItemListLoaded(data: dataList);
            }
          }
        }on Exception catch(e) {
          HazizzLogger.printLog("log: Exception: ${e.toString()}");
        }
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
  List<Object> get props => [item];
}






class SetSubjectEvent extends ItemListEvent {
  final PojoSubject item;
  SetSubjectEvent({@required this.item})
      : super([item, 5]);
  @override
  String toString() => 'SetSubjectEvent';
  List<Object> get props => [item];
}

class SubjectLoadData extends ItemListEvent {

  int groupId;

  SubjectLoadData(this.groupId);

  @override
  String toString() => 'SubjectItemListLoadData';
  List<Object> get props => [groupId];
}

//endregion

//region SubjectItemListStates
class PickedSubjectState extends ItemListState {
  final PojoSubject item;
  PickedSubjectState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'PickedSubjectState';
  List<Object> get props => [item];
}
//endregion

//region SubjectItemListBloc
class SubjectItemPickerBloc extends ItemListPickerBloc {
  List<PojoSubject> dataList = List();

  bool isLocked = false;

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async*{
    HazizzLogger.printLog("ohhohh : ${event.toString()} isLocked: $isLocked");
    if(event is SetSubjectEvent){
      isLocked = true;
      yield PickedSubjectState(item: event.item);
    }
    if(event is NotPickedEvent){
      yield ItemListNotPickedState();
    }
    if(!isLocked) {
      if(event is PickedSubjectEvent){
        HazizzLogger.printLog("log: PickedState is played");
        yield PickedSubjectState(item: event.item);
      }

      if(event is SubjectLoadData) {
        HazizzLogger.printLog("imp log");
        try {
          yield Waiting();
          HazizzResponse hazizzResponse = await RequestSender().getResponse(
              new GetSubjects(groupId: event.groupId));
          // HazizzLogger.printLog("log: responseData: ${hazizzResponse.convertedData}");
          //   HazizzLogger.printLog("log: responseData type:  ${hazizzResponse.runtimeType.toString()}");

          if(hazizzResponse.isSuccessful) {
            dataList = hazizzResponse.convertedData;
            yield ItemListLoaded(data: dataList);
          }else{
            yield ItemListFail();
          }
        }on Exception catch(e) {
          HazizzLogger.printLog("log: Exception: ${e.toString()}");
        }
      }
      super.mapEventToState(event);
    }

  }


  @override
  ItemListState get initialState => InitialState();

}

//endregion
//endregion

//region TaskTagBlocParts
//region TaskTagStates
abstract class TaskTagState extends HState {
  TaskTagState([List props = const []]) : super(props);
}
class TaskTagFineState extends TaskTagState {
  final List<PojoTag> tags;
  DateTime time;

 // PojoTag tag;

  TaskTagFineState(this.tags, this.time) : assert(tags!= null), super([tags, time]);

  @override
  String toString() => 'TaskTagFineState';
  List<Object> get props => [tags, time];
}
//endregion

//region TaskTagEvents
abstract class TaskTagEvent extends HEvent {
  TaskTagEvent([List props = const []]) : super(props);
// ItemListState(this.name) : super([name]);
}
class TaskTagAddEvent extends TaskTagEvent {
 // List<PojoTag> tags;

  PojoTag tag;

  TaskTagAddEvent(this.tag) : assert(tag != null), super([tag]);

  @override
  String toString() => 'TaskTagAddEvent';
  List<Object> get props => [tag];
}

class TaskTagRemoveEvent extends TaskTagEvent {
  // List<PojoTag> tags;

  PojoTag tag;
  int index;

  TaskTagRemoveEvent({this.tag, this.index}) : super([tag, index]);

  @override
  String toString() => 'TaskTagRemoveEvent';
  List<Object> get props => [tag, index];
}
//endregion

//region TaskTagBloc
class TaskTagBloc extends Bloc<TaskTagEvent, TaskTagState>{

  List<PojoTag> pickedTags = List();

  TaskTagBloc(){

  }

  @override
  TaskTagState get initialState =>TaskTagFineState(pickedTags, DateTime.now());

  @override
  Stream<TaskTagState> mapEventToState(TaskTagEvent event) async*{
    HazizzLogger.printLog("event: $event");
    if(event is TaskTagAddEvent){
      pickedTags.add(event.tag);
      HazizzLogger.printLog("state: fine");

      yield TaskTagFineState(pickedTags, DateTime.now());
    }else if(event is TaskTagRemoveEvent){
      HazizzLogger.printLog("oi");
      bool asd = null;
      if(event.tag != null){
        asd = pickedTags.remove(event.tag);
      }else{
        pickedTags.removeAt(event.index);
      }
      HazizzLogger.printLog("asdőú: $asd");
      HazizzLogger.printLog("asdőű: ${pickedTags}");
      yield TaskTagFineState(pickedTags, DateTime.now());
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
  List<Object> get props => null;
}

class TaskMakerSuccessfulState extends TaskMakerState {
  final PojoTask task;

  TaskMakerSuccessfulState(this.task) : assert(task!= null), super([task]);
  @override
  String toString() => 'TaskMakerSuccessfulState';
  List<Object> get props => [task];
}

class TaskMakerFailedState extends TaskMakerState {
  @override
  String toString() => 'TaskMakerFailedState';
  List<Object> get props => null;
}


abstract class TaskMakerEvent extends HEvent {
  TaskMakerEvent([List props = const []]) : super(props);
}

class TaskMakerSendEvent extends TaskMakerEvent {
  List<HazizzImageData> imageDatas;
  String salt;
  TaskMakerSendEvent({@required this.imageDatas, @required this.salt});
  @override
  String toString() => 'TaskMakerSendEvent';
  List<Object> get props => null;
}

class TaskMakerSaveStateEvent extends TaskMakerEvent {
  List<HazizzImageData> imageDatas;
  String salt;
  TaskMakerSaveStateEvent({@required this.imageDatas, @required this.salt});
  @override
  String toString() => 'TaskMakerSendEvent';
  List<Object> get props => null;
}

class TaskMakerFailedEvent extends TaskMakerEvent {
  @override
  String toString() => 'TaskMakerFailedEvent';
  List<Object> get props => null;
}



