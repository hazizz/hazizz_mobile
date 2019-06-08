import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';

import '../request_event.dart';
import '../response_states.dart';


abstract class ItemListState extends HState {
  ItemListState([List props = const []]) : super(props);
 // ItemListState(this.name) : super([name]);
}


class NotPicked extends ItemListState {
 /// NotPicked([List props = const []]) : super(props);
  @override
  String toString() => 'ItemListNotPickedEvent';
}

class Loaded extends ItemListState {
  final List<dynamic> data;
  Loaded({@required this.data})
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

class Error extends ItemListState {
  final PojoError error;
  Error({this.error})
      : assert(error != null);
  @override
  String toString() => 'ItemListError';
}

class PickedState extends ItemListState {
 // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final dynamic item;


 // PickedState() : super(props);

  PickedState({this.item})
      : assert(item != null), super(item);
  @override
  String toString() => 'PickedState';
}


abstract class ItemListEvent extends HEvent {
  ItemListEvent([List props = const []]) : super(props);
}

class LoadData extends ItemListEvent {
  @override
  String toString() => 'ItemListLoadData';
}
class PickedEvent extends ItemListEvent {
  final dynamic item;
  PickedEvent({this.item})
      : assert(item != null), super([item]);
  @override
  String toString() => 'ItemListPicked';
}


class NotPickedEvent extends ItemListEvent {

  @override
  String toString() => 'ItemListNotPickedEvent';
}


class ItemListPickerBloc extends Bloc<ItemListEvent, ItemListState> {
  List<dynamic> listItemData;
  dynamic pickedItem;

  @override
  ItemListState get initialState => Empty();

  Future<ItemListState> fetchedData()async{

  }

  void onPicked(dynamic item){

  }

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    print("log: Event2: ${event.toString()}");

    if(event is PickedEvent){
      pickedItem = event.item;
      onPicked(pickedItem);
    }
  }
}
