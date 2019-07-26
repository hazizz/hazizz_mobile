import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/requests/request_collection.dart';

import '../RequestSender.dart';
import '../hazizz_response.dart';



abstract class CommentSectionEvent extends HEvent {
  CommentSectionEvent([List props = const []]) : super(props);
}
abstract class CommentSectionState extends HState {
  CommentSectionState([List props = const []]) : super(props);
}

class CommentSectionLoadedEvent extends CommentSectionEvent {
  final List<PojoComment> items;
  CommentSectionLoadedEvent({this.items})
      : assert(items != null), super([items]);
  @override
  String toString() => 'CommentSectionLoadedEvent';
}

class CommentSectionFetchEvent extends CommentSectionEvent {
  CommentSectionFetchEvent();
  @override
  String toString() => 'CommentSectionFetchEvent';
}

class CommentSectionAddCommentEvent extends CommentSectionEvent {
  CommentSectionAddCommentEvent();
  @override
  String toString() => 'CommentSectionAddCommentEvent';
}



class CommentSectionWaitingState extends CommentSectionState {
  CommentSectionWaitingState();
  @override
  String toString() => 'CommentSectionWaitingState';
}


class CommentSectionLoadedState extends CommentSectionState {
  final List<PojoComment> items;
  CommentSectionLoadedState({@required this.items})
      :  assert(items != null), super([items]);
  @override
  String toString() => 'CommentSectionLoadedState';
}

class CommentSectionFailState extends CommentSectionState {
  final dynamic error;
  CommentSectionFailState({ this.error})
      :  assert(error != null), super([error]);
  @override
  String toString() => 'CommentSectionFailState';
}

class CommentSectionInitialState extends CommentSectionState {
  CommentSectionInitialState();
  @override
  String toString() => 'CommentSectionInitialState';
}



class CommentSectionBloc extends Bloc<CommentSectionEvent, CommentSectionState> {
  List<PojoComment> tasksTomorrow;

  int taskId;

  CommentSectionBloc({@required this.taskId}){

  }


  Future<bool> addComment(String content) async {
    HazizzResponse hazizzResponse = await RequestSender().getResponse(CreateTaskComment(p_taskId: taskId, b_content: content));
    if(hazizzResponse.isSuccessful){
      this.dispatch(CommentSectionFetchEvent());
      return true;
    }else{

    }
    return false;
  }


  @override
  CommentSectionState get initialState => CommentSectionInitialState();

  @override
  Stream<CommentSectionState> mapEventToState(CommentSectionEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is CommentSectionFetchEvent) {
      try {
        yield CommentSectionWaitingState();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTaskComments(taskId: taskId));
        print("log: responseData: ${hazizzResponse}");
        print("log: responseData type:  ${hazizzResponse.runtimeType.toString()}");

        if(hazizzResponse.isSuccessful){
          tasksTomorrow = hazizzResponse.convertedData;
          print("log: response is List");
          yield CommentSectionLoadedState(items: tasksTomorrow);
        }
        else if(hazizzResponse.isError){
          print("log: response is List<PojoComment>");
          yield CommentSectionFailState(error: hazizzResponse.pojoError);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }else if(event is CommentSectionLoadedEvent){
      yield CommentSectionLoadedState(items: event.items);
    }

    else if(state is CommentSectionAddCommentEvent){

    }


  }
}