import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';


abstract class ItemListState extends HState {
  ItemListState([List props = const []]) : super(props);
}

class ItemListNotPickedState extends ItemListState {
 /// NotPicked([List props = const []]) : super(props);
  @override
  String toString() => 'ItemListNotPickedState';
  List<Object> get props => null;
}

class ItemListLoaded extends ItemListState {
  final dynamic data;
  ItemListLoaded({@required this.data})
      : assert(data != null);
  @override
  String toString() => 'ItemListLoaded';
  List<Object> get props => [data];
}

class Waiting extends ItemListState {
  @override
  String toString() => 'ItemListLoading';
  List<Object> get props => null;
}

class Empty extends ItemListState {
  @override
  String toString() => 'ItemListEmtpy';
  List<Object> get props => null;
}

class InitialState extends ItemListState {
  @override
  String toString() => 'InitialState';
  List<Object> get props => null;
}

class ItemListFail extends ItemListState {
  final PojoError error;
  ItemListFail({this.error})
      : assert(error != null);
  @override
  String toString() => 'ItemListFail';
  List<Object> get props => [error];
}

class ItemListPickedState extends ItemListState {
  final dynamic item;

  ItemListPickedState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'ItemListPickedState';
  List<Object> get props => [item];
}

class InactiveState extends ItemListState {
  @override
  String toString() => 'InactiveState';
  List<Object> get props => null;
}

abstract class ItemListEvent extends HEvent {
  ItemListEvent([List props = const []]) : super(props);
}

class InactiveEvent extends ItemListEvent {
  @override
  String toString() => 'InactiveEvent';
  List<Object> get props => null;
}

class ItemListLoadData extends ItemListEvent {
  @override
  String toString() => 'ItemListLoadData';
  List<Object> get props => null;
}
class PickedEvent extends ItemListEvent {
  final dynamic item;
  PickedEvent({@required this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'ItemListPicked';
  List<Object> get props => [item];
}


class NotPickedEvent extends ItemListEvent {

  @override
  String toString() => 'ItemListNotPickedEvent';
  List<Object> get props => null;
}

class ItemListCheckPickedEvent extends ItemListEvent {

  @override
  String toString() => 'ItemListCheckPickedEvent';
  List<Object> get props => null;
}


abstract class ItemListPickerBloc extends Bloc<ItemListEvent, ItemListState> {
  dynamic listItemData;
  dynamic pickedItem;

  @override
  ItemListState get initialState => InitialState();

  void onPicked(dynamic item){

  }

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    HazizzLogger.printLog("log: Event2: ${event.toString()}");

    if(event is PickedEvent){
      pickedItem = event.item;
      onPicked(pickedItem);
    }else if(event is ItemListCheckPickedEvent){
      if(pickedItem == null){
        yield new ItemListNotPickedState();
      }else{
        yield new ItemListPickedState(item: pickedItem);
      }
    }
  }
}
