import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';


abstract class VariableState  extends Equatable {}

class VariableReady extends VariableState {
  final dynamic data;
  VariableReady({@required this.data})
      : assert(data != null);
  @override
  String toString() => 'ItemListLoaded';
}

class VariableNotInstantiated extends VariableState {
  @override
  String toString() => 'ItemListLoading';
}

abstract class VariableEvent extends Equatable {
  VariableEvent([List props = const []]) : super(props);
}

class GetVariable extends VariableEvent {
  @override
  String toString() => 'GetVariable';
}

class SetVariable extends VariableEvent {
  final dynamic variable;
  final int  = 1;
  SetVariable({this.variable})
      : assert(variable != null);

  @override
  String toString() => 'SetVariable';
}

/*
class InitalizeVariable extends VariableEvent {
  @override
  String toString() => 'ItemListLoadData';
}
class InstantiateVariable extends VariableEvent {
  final T item;
  InstantiateVariable({this.item})
      : assert(item != null);
  @override
  String toString() => 'ItemListPick';
}
*/


class VariableBloc extends Bloc<VariableEvent, VariableState> {
  dynamic variable;

  @override
  VariableState get initialState => VariableNotInstantiated();


  @override
  Stream<VariableState> mapEventToState(VariableEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if(event is SetVariable){
      variable = event.variable;
    }
    else if (event is GetVariable) {
      yield VariableReady(data: variable);
    }
  }
}
