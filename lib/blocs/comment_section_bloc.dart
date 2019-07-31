import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/requests/request_collection.dart';

import '../request_sender.dart';
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
      :  assert(items != null), super(items);
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
  List<PojoComment> comments;

  int taskId;

  CommentSectionBloc({@required this.taskId}){

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
          comments = hazizzResponse.convertedData;
          print("log: comments: $comments");
          print("log: response is List2134");
          if(comments.isEmpty) {
            yield CommentSectionLoadedState(items: comments);
          }else {
            yield CommentSectionLoadedState(items: comments);
          }
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


class CommentBlocs{
  int taskId;

  CommentSectionBloc commentSectionBloc;
  CommentWriterBloc commentWriterBloc;

  CommentBlocs({@required this.taskId}){
    commentSectionBloc = CommentSectionBloc(taskId: taskId);
    commentWriterBloc = CommentWriterBloc(taskId: taskId, commentSectionBloc: commentSectionBloc );
    commentSectionBloc.dispatch(CommentSectionFetchEvent());
  }

  dispose(){
    commentSectionBloc.dispose();
    commentWriterBloc.dispose();
  }


}



abstract class CommentWriterEvent extends HEvent {
  CommentWriterEvent([List props = const []]) : super(props);
}
abstract class CommentWriterState extends HState {
  CommentWriterState([List props = const []]) : super(props);
}

class CommentWriterSendEvent extends CommentWriterEvent {
  CommentWriterSendEvent();
}

class CommentWriterUpdateContentEvent extends CommentWriterEvent {
  String content;
  CommentWriterUpdateContentEvent({@required String this.content}): assert(content != null), super([content]){

  }
}

class CommentWriterFineEvent extends CommentWriterEvent {
}


class CommentWriterEmptyState extends CommentWriterState {
  CommentWriterEmptyState();
}

class CommentWriterFineState extends CommentWriterState {
}

class CommentWriterSentState extends CommentWriterState {
  CommentWriterSentState();
}

class CommentWriterErrorState extends CommentWriterState {
  CommentWriterErrorState();
}


class CommentWriterBloc extends Bloc<CommentWriterEvent,  CommentWriterState> {


  final TextEditingController commentController = TextEditingController();


  int taskId;

  CommentSectionBloc commentSectionBloc;

  String content;


  CommentWriterBloc({@required this.taskId, @required this.commentSectionBloc}){
    commentController.addListener((){
      content = commentController.text;
      if(content.length > 0 && this.currentState is CommentWriterEmptyState){
        this.dispatch(CommentWriterFineEvent());
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    commentSectionBloc.dispose();
    super.dispose();
  }

  @override
  CommentWriterState get initialState => CommentWriterFineState();

  @override
  Stream<CommentWriterState> mapEventToState(CommentWriterEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if(event is CommentWriterFineEvent){
      yield CommentWriterFineState();
    }
    if(event is CommentWriterUpdateContentEvent){
      content = event.content;
    }
    if (event is CommentWriterSendEvent) {
      if(content == null || content == "") {
        yield CommentWriterEmptyState();
      }else {
        HazizzResponse hazizzResponse = await RequestSender().getResponse(
            CreateTaskComment(p_taskId: taskId, b_content: content));
        if(hazizzResponse.isSuccessful) {
          commentController.clear();
          commentSectionBloc.dispatch(CommentSectionFetchEvent());
          yield CommentWriterSentState();
        }else {
          yield CommentWriterErrorState();
        }
      }
    }
  }
}











