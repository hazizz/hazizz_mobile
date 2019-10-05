
import 'dart:async';

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

enum TaskMakerMode{ create,edit }

abstract class TaskMakerBloc extends Bloc<TaskMakerEvent, TaskMakerState> {
  GroupItemPickerBloc groupItemPickerBloc;
  SubjectItemPickerBloc subjectItemPickerBloc;
  DateTimePickerBloc deadlineBloc;
  TaskTagBloc taskTagBloc;
  TextFormBloc titleBloc;
  TextFormBloc descriptionBloc;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

/*
 TaskMakerBloc({@required this.groupItemPickerBloc, @required this.subjectItemPickerBloc,
    @required this.deadlineBloc, @required this.taskTypePickerBloc,
    @required this.titleBloc, @required this.descriptionBloc,
  });
  */

  TaskMakerBloc(){
    subjectItemPickerBloc = SubjectItemPickerBloc();
    groupItemPickerBloc = GroupItemPickerBloc(subjectItemPickerBloc);
    deadlineBloc = DateTimePickerBloc();
    taskTagBloc = TaskTagBloc();
    titleBloc = TextFormBloc(
     validate: (String text){
       if(text.length < 2){
         return TextFormErrorTooShort();
       }
       if(text.length > 20){
         return TextFormErrorTooLong();
       }
       return TextFormFine();
     },
    );
    descriptionBloc = TextFormBloc();
    titleController.addListener((){

      String text = titleController.text;

      HazizzLogger.printLog("change: $text");
      titleBloc.dispatch(TextFormValidate(text: text));

    });

    descriptionController.addListener((){

      String text = descriptionController.text;

      HazizzLogger.printLog("change: $text");
      descriptionBloc.dispatch(TextFormValidate(text: text));
    });


    groupItemPickerBloc.dispatch(ItemListLoadData());

  }

  @override
  void dispose() {
    groupItemPickerBloc.dispose();
    subjectItemPickerBloc.dispose();
    deadlineBloc.dispose();
    taskTagBloc.dispose();
    titleBloc.dispose();
    descriptionBloc.dispose();
  
    super.dispose();
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
}

class SetGroupEvent extends ItemListEvent {
  final PojoGroup item;
  SetGroupEvent({@required this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'SetGroupEvent';
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

  bool isLocked = false;


  @override
  ItemListState get initialState => InitialState();

  GroupItemPickerBloc(this.subjectItemPickerBloc) {
    subjectItemPickerBlocSubscription = this.state.listen((state) {
      if (state is PickedGroupState) {
        HazizzLogger.printLog("log: picked Group listen");
        if(state.item.id != 0) {
          subjectItemPickerBloc.dispatch(SubjectLoadData(state.item.id));
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
}






class SetSubjectEvent extends ItemListEvent {
  final PojoSubject item;
  SetSubjectEvent({@required this.item})
      : super([item, 5]);
  @override
  String toString() => 'SetSubjectEvent';
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
  // TODO: implement initialState
  ItemListState get initialState => InitialState();

}




class SubjectItemPickerBloc2 extends ItemListPickerBloc {
  List<PojoGroup> dataList;

  bool isLocked = false;

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    if(event is SetSubjectEvent){
      isLocked = true;
      yield PickedSubjectState(item: event.item);
    }
    if(!isLocked) {
      if(event is PickedGroupEvent) {
        HazizzLogger.printLog("log: PickedState is played");
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
            }else {
              yield Empty();
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

//region TaskTagBlocParts
//region TaskTagStates
abstract class TaskTagState extends HState {
  TaskTagState([List props = const []]) : super(props);
}
class TaskTagFineState extends TaskTagState {
  final List<PojoTag> tags;

 // PojoTag tag;

  TaskTagFineState(this.tags, DateTime time) : assert(tags!= null), super([tags, time]);

  @override
  String toString() => 'TaskTagFineState';
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
}

class TaskTagRemoveEvent extends TaskTagEvent {
  // List<PojoTag> tags;

  PojoTag tag;
  int index;

  TaskTagRemoveEvent({this.tag, this.index}) : super([tag, index]);

  @override
  String toString() => 'TaskTagRemoveEvent';
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
}

class TaskMakerSuccessfulState extends TaskMakerState {
  final PojoTask task;

  TaskMakerSuccessfulState(this.task) : assert(task!= null), super([task]);
  @override
  String toString() => 'TaskMakerSuccessfulState';
}

class TaskMakerFailedState extends TaskMakerState {
  @override
  String toString() => 'TaskMakerFailedState';
}


abstract class TaskMakerEvent extends HEvent {
  TaskMakerEvent([List props = const []]) : super(props);
}

class TaskMakerSendEvent extends TaskMakerEvent {
  @override
  String toString() => 'TaskMakerSendEvent';
}
class TaskMakerFailedEvent extends TaskMakerEvent {
  @override
  String toString() => 'TaskMakerFailedEvent';
}



