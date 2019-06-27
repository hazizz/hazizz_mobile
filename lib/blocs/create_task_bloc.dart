
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/blocs/task_maker_blocs.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import '../RequestSender.dart';
import 'TextFormBloc.dart';
import 'date_time_picker_bloc.dart';
import 'item_list_picker_bloc/item_list_picker_bloc.dart';

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
}

//endregion

//region SubjectItemListStates


abstract class TaskCreateState extends TaskMakerState {
  TaskCreateState([List props = const []]) : super(props);
}

class InitializedTaskCreateState extends TaskCreateState {
  final PojoGroup group;
  InitializedTaskCreateState({this.group}) : super([group]);

  String toString() => 'InitializeTaskEditState';
}




//endregion

//region SubjectItemListBloc
class TaskCreateBloc extends TaskMakerBloc {

  PojoGroup group;


  TaskCreateBloc({this.group}) : super();
 
  @override
  Stream<TaskMakerState> mapEventToState(TaskMakerEvent event) async*{
    if(event is InitializeTaskCreateEvent){
      yield InitializedTaskCreateState(group: event.group);

      if(group != null) {
        groupItemPickerBloc.dispatch(PickedGroupEvent(item: group));
      }
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
          print("log: title: $title");
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
  TaskCreateState get initialState => InitializedTaskCreateState(group: group);



}
//endregion
//endregion












