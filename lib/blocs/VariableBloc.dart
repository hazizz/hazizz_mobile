import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';


abstract class VariableState extends Equatable {}

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

class InitalizeVariable extends VariableEvent {
  @override
  String toString() => 'ItemListLoadData';
}
class InstantiateVariable extends VariableEvent {
  final dynamic item;
  InstantiateVariable({this.item})
      : assert(item != null);
  @override
  String toString() => 'ItemListPick';
}


class VariableBloc extends Bloc<VariableEvent, VariableState> {
  List<dynamic> listItemData;

  @override
  VariableBloc get initialState => VariableNotInstantiated();


  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is ItemListLoadData) {
      try {
        yield ItemListWaiting();
        yield await loadData();

      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }
  }
}
