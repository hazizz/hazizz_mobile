import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';


import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';


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
        if(hazizzResponse.isError){
          yield ResponseError(errorResponse: hazizzResponse);
        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}