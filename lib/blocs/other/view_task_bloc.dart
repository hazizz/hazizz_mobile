import 'package:flutter/material.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'comment_section_bloc.dart';

import 'package:bloc/bloc.dart';

class ViewTaskBloc extends Bloc<HEvent, HState> {

  CommentBlocs commentBlocs;
  PojoTask pojoTask;

  bool hasCommentSection = true;

  static final ViewTaskBloc _singleton = new ViewTaskBloc._internal();
  factory ViewTaskBloc() {
    return _singleton;
  }

  /*
  ViewTaskBloc getInstance(){
    if(_singleton ==) {
      return _singleton;
    }
  }
  */

  void reCreate({@required PojoTask pojoTask }){
    this.pojoTask = pojoTask;
    HazizzLogger.printLog("assign: " + pojoTask.assignation.name );
    if(pojoTask.assignation.name == "THERA"){
      hasCommentSection = false;
    }else{
      hasCommentSection = true;
    }
    commentBlocs = CommentBlocs(taskId: pojoTask.id, hasCommentSection: hasCommentSection);
  }



  ViewTaskBloc._internal();

  @override
  // TODO: implement initialState
  HState get initialState => null;

  @override
  Stream<HState> mapEventToState(HEvent event) {
    // TODO: implement mapEventToState
    return null;
  }

}