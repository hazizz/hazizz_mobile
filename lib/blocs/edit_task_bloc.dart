import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';

abstract class EditTaskState extends Equatable {}

class EditTaskLoaded extends EditTaskState {
  final List<dynamic> data;
  EditTaskLoaded({@required this.data})
      : assert(data != null);
  @override
  String toString() => 'EditTaskLoaded';
}

class EditTaskWaiting extends EditTaskState {
  @override
  String toString() => 'EditTaskLoading';
}

class EditTaskEmpty extends EditTaskState {
  @override
  String toString() => 'EditTaskEmtpy';
}

class EditTaskError extends EditTaskState {
  final PojoError error;
  EditTaskError({this.error})
      : assert(error != null);
  @override
  String toString() => 'EditTaskError';
}

class EditTaskUpdate extends EditTaskState {
  final PojoError error;
  EditTaskUpdate({this.error})
      : assert(error != null);
  @override
  String toString() => 'EditTaskUpdate';
}

class Send extends EditTaskState {
  final PojoError error;
  Send({this.error})
      : assert(error != null);
  @override
  String toString() => 'EditTaskUpdate';
}




// TODO csak akkor tárol adatot ha csinálni is fog vele valamit!!!

abstract class EditTaskEvent extends Equatable {
  EditTaskEvent([List props = const []]) : super(props);
}

class EditTaskLoadData extends EditTaskEvent {
  @override
  String toString() => 'EditTaskLoadData';
}
class EditTaskPick extends EditTaskEvent {
  final dynamic item;
  EditTaskPick({this.item})
      : assert(item != null);
  @override
  String toString() => 'EditTaskPick';
}


class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  List<dynamic> listItemData;

  @override
  EditTaskState get initialState => EditTaskEmpty();

  Future<EditTaskState> loadData()async{

  }

  @override
  Stream<EditTaskState> mapEventToState(EditTaskEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is EditTaskLoadData) {
      try {
        yield EditTaskWaiting();
        yield await loadData();

      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }
  }
}
