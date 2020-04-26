import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';

//region CommentSection events
abstract class CommentSectionEvent extends HEvent {
  CommentSectionEvent([List props = const []]) : super(props);
}

class CommentSectionLoadedEvent extends CommentSectionEvent {
  final List<PojoComment> items;
  CommentSectionLoadedEvent({this.items})
      : assert(items != null), super([items]);
  @override
  String toString() => 'CommentSectionLoadedEvent';
  List<Object> get props => [items];
}

class CommentSectionFetchEvent extends CommentSectionEvent {
  CommentSectionFetchEvent();
  @override
  String toString() => 'CommentSectionFetchEvent';
  List<Object> get props => null;
}

class CommentSectionAddCommentEvent extends CommentSectionEvent {
  CommentSectionAddCommentEvent();
  @override
  String toString() => 'CommentSectionAddCommentEvent';
  List<Object> get props => null;
}
//endregion

//region CommentSection events
abstract class CommentSectionState extends HState {
  CommentSectionState([List props = const []]) : super(props);
}

class CommentSectionWaitingState extends CommentSectionState {
  CommentSectionWaitingState();
  @override
  String toString() => 'CommentSectionWaitingState';
  List<Object> get props => null;
}


class CommentSectionLoadedState extends CommentSectionState {
  final List<PojoComment> items;
  CommentSectionLoadedState({@required this.items}): assert(items != null), super(items);
  @override
  String toString() => 'CommentSectionLoadedState';
  List<Object> get props => [items];
}

class CommentSectionFailState extends CommentSectionState {
  final dynamic error;
  CommentSectionFailState({ this.error})
      :  assert(error != null), super([error]);
  @override
  String toString() => 'CommentSectionFailState';
  List<Object> get props => [error];
}

class CommentSectionInitialState extends CommentSectionState {
  CommentSectionInitialState();
  @override
  String toString() => 'CommentSectionInitialState';
  List<Object> get props => null;
}
//endregion

//region CommentSection bloc
class CommentSectionBloc extends Bloc<CommentSectionEvent, CommentSectionState> {
  List<PojoComment> comments;

  int taskId;
  bool enabled = true;

  CommentSectionBloc({@required this.taskId, @required enabled = true});

  @override
  CommentSectionState get initialState => CommentSectionInitialState();

  @override
  Stream<CommentSectionState> mapEventToState(CommentSectionEvent event) async* {
    HazizzLogger.printLog("log: Event2: ${event.toString()}");
    if(enabled){
      if (event is CommentSectionFetchEvent) {
        try {
          yield CommentSectionWaitingState();
          HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTaskComments(p_taskId: taskId));
          if(hazizzResponse.isSuccessful){
            comments = hazizzResponse.convertedData;
            HazizzLogger.printLog("comments: $comments");
            if(comments.isEmpty) {
              yield CommentSectionLoadedState(items: comments);
            }else {
              yield CommentSectionLoadedState(items: comments);
            }
          }
          else if(hazizzResponse.isError){
            yield CommentSectionFailState(error: hazizzResponse.pojoError);
          }
        } on Exception catch(e){
        }
      }else if(event is CommentSectionLoadedEvent){
        yield CommentSectionLoadedState(items: event.items);
      }

      else if(state is CommentSectionAddCommentEvent){

      }
    }
  }
}
//endregion

class CommentBlocs{
  int taskId;

  CommentSectionBloc commentSectionBloc;
  CommentWriterBloc commentWriterBloc;

  bool hasCommentSection = true;

  CommentBlocs({@required this.taskId, hasCommentSection = true}){
    commentSectionBloc = CommentSectionBloc(taskId: taskId, enabled: hasCommentSection);
    commentWriterBloc = CommentWriterBloc(taskId: taskId, commentSectionBloc: commentSectionBloc, enabled: hasCommentSection);
    commentSectionBloc.add(CommentSectionFetchEvent());
  }

  Future<void> close(){
    commentSectionBloc.close();
    return commentWriterBloc.close();
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
  List<Object> get props => null;
}

class CommentWriterUpdateContentEvent extends CommentWriterEvent {
  String content;
  CommentWriterUpdateContentEvent({@required String this.content}): assert(content != null), super([content]);

  List<Object> get props => [content];
}

class CommentWriterFineEvent extends CommentWriterEvent {
  List<Object> get props => null;
}


class CommentWriterEmptyState extends CommentWriterState {
  CommentWriterEmptyState();
  List<Object> get props => null;
}

class CommentWriterFineState extends CommentWriterState {
  List<Object> get props => null;
}

class CommentWriterSentState extends CommentWriterState {
  CommentWriterSentState();
  List<Object> get props => null;
}

class CommentWriterErrorState extends CommentWriterState {
  CommentWriterErrorState();
  List<Object> get props => null;
}


class CommentWriterBloc extends Bloc<CommentWriterEvent,  CommentWriterState> {
  final TextEditingController commentController = TextEditingController();

  int taskId;

  CommentSectionBloc commentSectionBloc;

  String content;

  bool enabled = true;

  CommentWriterBloc({@required this.taskId, @required this.commentSectionBloc, @required enabled = true}){
    commentController.addListener((){
      content = commentController.text;
      if(content.length > 0 && this.state is CommentWriterEmptyState){
        this.add(CommentWriterFineEvent());
      }
    });
  }

  @override
  Future<void> close() {
    commentSectionBloc.close();
    return super.close();
  }

  @override
  CommentWriterState get initialState => CommentWriterFineState();

  @override
  Stream<CommentWriterState> mapEventToState(CommentWriterEvent event) async* {
    if(enabled){
      HazizzLogger.printLog("log: Event2: ${event.toString()}");
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
            commentSectionBloc.add(CommentSectionFetchEvent());
            yield CommentWriterSentState();
          }else {
            yield CommentWriterErrorState();
          }
        }
      }
    }
  }
}











