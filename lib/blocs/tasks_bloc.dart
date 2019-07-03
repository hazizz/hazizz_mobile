import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';

import '../RequestSender.dart';
import '../hazizz_response.dart';

class TasksBloc extends Bloc<HEvent, HState> {
  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe());
        print("log: responseData: ${hazizzResponse.convertedData}");
        print("log: responseData type:  ${hazizzResponse.convertedData.runtimeType.toString()}");

        if(hazizzResponse.isSuccessful){
          List<PojoTask> tasks = hazizzResponse.convertedData;
          if(tasks.isNotEmpty) {
            print("log: response is List");
            yield ResponseDataLoaded(data: tasks);
          }else{
            yield ResponseEmpty();
          }
        }
        if(hazizzResponse.hasPojoError){
          print("log: response is List<PojoTask>");
          yield ResponseError(error: hazizzResponse.pojoError);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }
  }
}
