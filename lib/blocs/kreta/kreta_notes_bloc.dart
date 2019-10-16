import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';


import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';

class KretaNotesBloc extends Bloc<HEvent, HState> {

  /*
  static final KretaNotesBloc _singleton = new KretaNotesBloc._internal();
  factory KretaNotesBloc() {
    return _singleton;
  }
  KretaNotesBloc._internal();
  */

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetNotes());

        if(hazizzResponse.isSuccessful){
          List<PojoKretaNote> notes = hazizzResponse.convertedData;
          yield ResponseDataLoaded(data: notes);

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



