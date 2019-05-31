import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';


abstract class ItemListState extends Equatable {}

class ItemListLoaded extends ItemListState {
  final List<dynamic> data;
  ItemListLoaded({@required this.data})
      : assert(data != null);
  @override
  String toString() => 'ItemListLoaded';
}

class ItemListWaiting extends ItemListState {
  @override
  String toString() => 'ItemListLoading';
}

class ItemListEmpty extends ItemListState {
  @override
  String toString() => 'ItemListEmtpy';
}

class ItemListError extends ItemListState {
  final PojoError error;
  ItemListError({this.error})
      : assert(error != null);
  @override
  String toString() => 'ItemListError';
}

abstract class ItemListEvent extends Equatable {
  ItemListEvent([List props = const []]) : super(props);
}

class ItemListLoadData extends ItemListEvent {
  @override
  String toString() => 'ItemListLoadData';
}
class ItemListPick extends ItemListEvent {
  final dynamic item;
  ItemListPick({this.item})
      : assert(item != null);
  @override
  String toString() => 'ItemListPick';
}


class ItemListPickerBloc extends Bloc<ItemListEvent, ItemListState> {
  List<dynamic> listItemData;

  @override
  ItemListState get initialState => ItemListEmpty();

  Future<ItemListState> loadData()async{

  }

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
