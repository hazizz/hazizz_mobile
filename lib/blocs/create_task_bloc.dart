
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import '../request_sender.dart';
import '../hazizz_response.dart';
import 'TextFormBloc.dart';
import 'date_time_picker_bloc.dart';
import 'item_list_picker_bloc/item_list_picker_bloc.dart';
import 'main_tab_blocs/main_tab_blocs.dart';

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
      print("log: event: TaskMakerSendEvent");
      try {
        yield TaskMakerWaitingState();

        print("log: lul1");

        //region send
        int groupId, subjectId, typeId;
        DateTime deadline;
        String title, description;

        bool missingInfo = false;

        TaskTypePickerState typeState = taskTypePickerBloc.currentState;
        if(typeState is TaskTypePickedState){
          typeId = typeState.item.id;
        }

        print("log: lul11");


        ItemListState groupState =  groupItemPickerBloc.currentState;

        if (groupState is PickedGroupState) {
          groupId = groupItemPickerBloc.pickedItem.id;
          print("log: lulu0");
        } else {
          print("log: lulu1");
          groupItemPickerBloc.dispatch(NotPickedEvent());
          print("log: lulu2");
          missingInfo = true;
        }




        HState subjectState = subjectItemPickerBloc.currentState;
        if(subjectState is PickedSubjectState) {
          subjectId = subjectState.item.id;
        }else{
          if(groupId != 0){
            print("log: subjectItemPickerBloc.dispatch(NotPickedEvent());");

            subjectItemPickerBloc.dispatch(NotPickedEvent());
            missingInfo = true;
          }
        }
        print("log: lul12");


        /*
        if(subjectId == null) {
          print("log: uff: ${groupItemPickerBloc.currentState}");
          print("log: lulu0000");

          ItemListState groupState =  groupItemPickerBloc.currentState;
          print("log: lulu00");
          if (groupState is PickedGroupState) {
            groupId = groupItemPickerBloc.pickedItem.id;
            print("log: lulu0");
          } else {
            print("log: lulu1");
            groupItemPickerBloc.dispatch(NotPickedEvent());
            print("log: lulu2");
            missingInfo = true;
          }
        }
        */



        print("log: lul2");


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
          if(title == null || title == ""){
            missingInfo = true;
          }
        }else{
          missingInfo = true;
        }
        HFormState descriptionState = descriptionBloc.currentState;
        if(descriptionState is TextFormFine){
          description = descriptionBloc.lastText;

        }else{
          missingInfo = true;
        }

        print("log: lul3");


        if(missingInfo){
          print("log: missing info");
          this.dispatch(TaskMakerFailedEvent());
          return;
        }
        print("log: not missing info");

        HazizzResponse hazizzResponse;


        print("BEFORE POIOP: ${groupId}, ${subjectId},");
        hazizzResponse = await RequestSender().getResponse(new CreateTask(
            groupId: groupId,
            subjectId: subjectId,
            b_taskType: typeId,
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
          print("log: task making was succcessful");
          yield TaskMakerSentState();
          MainTabBlocs().tasksBloc.dispatch(FetchData());
        }else{
          yield TaskMakerFailedState();
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












