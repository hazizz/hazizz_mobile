import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';


import '../RequestSender.dart';
import '../hazizz_response.dart';


class MyGroupsBloc extends Bloc<HEvent, HState> {
  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetMyGroups());

        if(hazizzResponse.isSuccessful){
          List<PojoGroup> groups = hazizzResponse.convertedData;
          if(groups.isNotEmpty) {
            yield ResponseDataLoaded(data: groups);
          }else{
            yield ResponseEmpty();
          }
        }
        if(hazizzResponse.hasPojoError){
          yield ResponseError(error: hazizzResponse.pojoError);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}