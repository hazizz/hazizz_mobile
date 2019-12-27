import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
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
      yield ResponseWaiting();
      HazizzResponse hazizzResponse = await getResponse(new GetMyGroups());
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
    }
  }
}