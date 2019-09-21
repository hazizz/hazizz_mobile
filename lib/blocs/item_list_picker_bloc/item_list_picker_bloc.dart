import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import '../request_event.dart';
import '../response_states.dart';


abstract class ItemListState extends HState {
  ItemListState([List props = const []]) : super(props);
 // ItemListState(this.name) : super([name]);
}

class ItemListNotPickedState extends ItemListState {
 /// NotPicked([List props = const []]) : super(props);
  @override
  String toString() => 'ItemListNotPickedState';
}

class ItemListLoaded extends ItemListState {
  final dynamic data;
  ItemListLoaded({@required this.data})
      : assert(data != null);
  @override
  String toString() => 'ItemListLoaded';
}

class Waiting extends ItemListState {
  @override
  String toString() => 'ItemListLoading';
}

class Empty extends ItemListState {
  @override
  String toString() => 'ItemListEmtpy';
}

class InitialState extends ItemListState {
  @override
  String toString() => 'InitialState';
}

class ItemListFail extends ItemListState {
  final PojoError error;
  ItemListFail({this.error})
      : assert(error != null);
  @override
  String toString() => 'ItemListFail';
}

class ItemListPickedState extends ItemListState {
 // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final dynamic item;

  ItemListPickedState({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'ItemListPickedState';
}

class InactiveState extends ItemListState {
  @override
  String toString() => 'InactiveState';
}


abstract class ItemListEvent extends HEvent {
  ItemListEvent([List props = const []]) : super(props);
}

class InactiveEvent extends ItemListEvent {
  @override
  String toString() => 'InactiveEvent';
}

class ItemListLoadData extends ItemListEvent {
  @override
  String toString() => 'ItemListLoadData';
}
class PickedEvent extends ItemListEvent {
  final dynamic item;
  PickedEvent({@required this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'ItemListPicked';
}


class NotPickedEvent extends ItemListEvent {

  @override
  String toString() => 'ItemListNotPickedEvent';
}

class ItemListCheckPickedEvent extends ItemListEvent {

  @override
  String toString() => 'ItemListCheckPickedEvent';
}


class ItemListPickerBloc extends Bloc<ItemListEvent, ItemListState> {
  dynamic listItemData;
  dynamic pickedItem;

  @override
  ItemListState get initialState => InitialState();

  Future<ItemListState> fetchedData()async{

  }

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
