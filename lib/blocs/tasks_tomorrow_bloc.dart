import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';

import '../RequestSender.dart';
import '../hazizz_response.dart';



abstract class TasksTomorrowEvent extends HEvent {
  TasksTomorrowEvent([List props = const []]) : super(props);
}
abstract class TasksTomorrowState extends HState {
  TasksTomorrowState([List props = const []]) : super(props);
}

class TasksTomorrowLoadedEvent extends TasksTomorrowEvent {
  final List<PojoTask> items;
  TasksTomorrowLoadedEvent({this.items})
      : assert(items != null), super([items]);
  @override
  String toString() => 'TasksTomorrowLoadedEvent';
}

class TasksTomorrowFetchEvent extends TasksTomorrowEvent {
  TasksTomorrowFetchEvent();
  @override
  String toString() => 'TasksTomorrowFetchEvent';
}



class TasksTomorrowWaitingState extends TasksTomorrowState {
  TasksTomorrowWaitingState();
  @override
  String toString() => 'TasksTomorrowWaitingState';
}


class TasksTomorrowLoadedState extends TasksTomorrowState {
  final List<PojoTask> items;
  TasksTomorrowLoadedState({@required this.items})
      :  assert(items != null), super([items]);
  @override
  String toString() => 'TasksTomorrowLoadedState';
}

class TasksTomorrowFailState extends TasksTomorrowState {
  final dynamic error;
  TasksTomorrowFailState({ this.error})
      :  assert(error != null), super([error]);
  @override
  String toString() => 'TasksTomorrowFailState';
}

class TasksTomorrowInitialState extends TasksTomorrowState {
  TasksTomorrowInitialState();
  @override
  String toString() => 'TasksTomorrowInitialState';
}



class TomorrowTasksBloc extends Bloc<TasksTomorrowEvent, TasksTomorrowState> {
  List<PojoTask> tasksTomorrow;

  @override
  TasksTomorrowState get initialState => TasksTomorrowInitialState();

  @override
  Stream<TasksTomorrowState> mapEventToState(TasksTomorrowEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is TasksTomorrowFetchEvent) {
      try {
        yield TasksTomorrowWaitingState();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe());
        print("log: responseData: ${hazizzResponse}");
        print("log: responseData type:  ${hazizzResponse.runtimeType.toString()}");

        if(hazizzResponse.isSuccessful){
          tasksTomorrow = hazizzResponse.convertedData;
          print("log: response is List");
          yield TasksTomorrowLoadedState(items: tasksTomorrow);
        }
        else if(hazizzResponse.isError){
          print("log: response is List<PojoTask>");
          yield TasksTomorrowFailState(error: hazizzResponse.pojoError);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }else if(event is TasksTomorrowLoadedEvent){
      yield TasksTomorrowLoadedState(items: event.items);
    }
  }
}