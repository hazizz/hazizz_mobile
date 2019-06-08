import 'package:bloc/bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';

import '../RequestSender.dart';

/*
class TasksBloc extends Bloc<RequestEvent, ResponseState> {
  @override
  ResponseState get initialState => ResponseEmpty();

  @override
  Stream<ResponseState> mapEventToState(RequestEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is FetchRequest) {
      try {
        yield ResponseWaiting();
        dynamic responseData = await RequestSender().getResponse(new GetTasksFromMe());
        print("log: responseData: ${responseData}");
        print("log: responseData type:  ${responseData.runtimeType.toString()}");

        if(responseData is List<PojoTask>){
          List<PojoTask> tasks = responseData;
          if(tasks.isNotEmpty) {
            print("log: response is List");
            yield ResponseDataLoaded(data: responseData);
          }else{
            yield ResponseEmpty();
          }
        }
        if(responseData is PojoError){
          print("log: response is List<PojoTask>");
          yield ResponseError(error: responseData);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }
  }
}
*/