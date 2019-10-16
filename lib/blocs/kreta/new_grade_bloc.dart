import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';

//region EditTask bloc parts
//region EditTask events
abstract class NewGradesEvent extends HEvent {
  NewGradesEvent([List props = const []]) : super(props);
}

class HasNewGradesEvent extends NewGradesEvent {

  @override
  String toString() => 'HasNewGradesEvent';
}
class DoesntHaveNewGradesEvent extends NewGradesEvent {

  @override
  String toString() => 'DoesntHaveNewGradesEvent';
}
//endregion

abstract class NewGradesState extends HState {
  NewGradesState([List props = const []]) : super(props);
}

class HasNewGradesState extends NewGradesState {

  @override
  String toString() => 'HasNewGradesState';
}
class DoesntHaveNewGradesState extends NewGradesState {

  @override
  String toString() => 'DoesntHaveNewGradesState';
}

//region SubjectItemListBloc
class NewGradesBloc extends Bloc<NewGradesEvent, NewGradesState> {

  static final NewGradesBloc _singleton = new NewGradesBloc._internal();
  factory NewGradesBloc() {

    return _singleton;
  }
  NewGradesBloc._internal();

  @override
  NewGradesState get initialState => DoesntHaveNewGradesState();

  @override
  Stream<NewGradesState> mapEventToState(NewGradesEvent event) async* {
    if (event is HasNewGradesEvent) {
      yield HasNewGradesState();
    }else if (event is DoesntHaveNewGradesEvent) {
      yield DoesntHaveNewGradesState();
    }
  }
}
//endregion
//endregion
