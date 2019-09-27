
import 'package:mobile/blocs/item_list/item_list_picker_bloc.dart';
import 'package:mobile/blocs/other/date_time_picker_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';


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


  TaskCreateBloc({this.group}) : super(){
    taskTagBloc.dispatch(TaskTagAddEvent(PojoTag.defaultTags[0]));
  }
 
  @override
  Stream<TaskMakerState> mapEventToState(TaskMakerEvent event) async*{
    if(event is TaskMakerFailedEvent){
      yield TaskMakerFailedState();
    }
    if(event is InitializeTaskCreateEvent){
      yield InitializedTaskCreateState(group: event.group);

      if(group != null) {
        groupItemPickerBloc.dispatch(PickedGroupEvent(item: group));
      }
    }
    if (event is TaskMakerSendEvent) {
      HazizzLogger.printLog("log: event: TaskMakerSendEvent");
      try {
        yield TaskMakerWaitingState();

        HazizzLogger.printLog("log: lul1");

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


        HazizzLogger.printLog("log: lul11");


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
            HazizzLogger.printLog("log: subjectItemPickerBloc.dispatch(NotPickedEvent());");

            subjectItemPickerBloc.dispatch(NotPickedEvent());
            missingInfo = true;
          }
        }
        HazizzLogger.printLog("log: lul12");


        /*
        if(subjectId == null) {
          HazizzLogger.printLog("log: uff: ${groupItemPickerBloc.currentState}");
          HazizzLogger.printLog("log: lulu0000");

          ItemListState groupState =  groupItemPickerBloc.currentState;
          HazizzLogger.printLog("log: lulu00");
          if (groupState is PickedGroupState) {
            groupId = groupItemPickerBloc.pickedItem.id;
            HazizzLogger.printLog("log: lulu0");
          } else {
            HazizzLogger.printLog("log: lulu1");
            groupItemPickerBloc.dispatch(NotPickedEvent());
            HazizzLogger.printLog("log: lulu2");
            missingInfo = true;
          }
        }
        */



        HazizzLogger.printLog("log: lul2");


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
          HazizzLogger.printLog("log: title: $title");
          if(title == null || title == ""){
            missingInfo = true;
          }
        }else{
          missingInfo = true;
        }
        HFormState descriptionState = descriptionBloc.currentState;
        /*
        if(descriptionState is TextFormFine){
          description = descriptionBloc.lastText;

        }else{
          missingInfo = true;
        }
        */

        description = descriptionBloc.lastText;


        HazizzLogger.printLog("log: lul3");


        if(missingInfo){
          HazizzLogger.printLog("log: missing info");
          this.dispatch(TaskMakerFailedEvent());
          return;
        }
        HazizzLogger.printLog("log: not missing info");

        HazizzResponse hazizzResponse;


        HazizzLogger.printLog("BEFORE POIOP: ${groupId}, ${subjectId},");
        hazizzResponse = await RequestSender().getResponse(new CreateTask(
            groupId: groupId,
            subjectId: subjectId,
            b_tags: tags,
            b_title: title,
            b_description: description,
            b_deadline: deadline
        ));

        /*
        if(subjectId != null) {
          hazizzResponse = await RequestSender().getResponse(new CreateTask(
              subjectId: subjectId,
              b_taskType: typeId,
              b_title: title,
              b_description: description,
              b_deadline: deadline
          ));
        }else {
          hazizzResponse = await RequestSender().getResponse(new CreateTask(
              groupId: groupId,
              b_taskType: typeId,
              b_title: title,
              b_description: description,
              b_deadline: deadline
          ));
        }
        */

        if(hazizzResponse.isSuccessful){
          HazizzLogger.printLog("log: task making was succcessful");
          yield TaskMakerSuccessfulState(hazizzResponse.convertedData);
          MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
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
  TaskCreateState get initialState => InitializedTaskCreateState(group: group);



}
//endregion
//endregion












