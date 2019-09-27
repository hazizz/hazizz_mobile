
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'item_list_picker_bloc.dart';

class ItemListPickerGroupBloc extends ItemListPickerBloc{

  @override
  Future<ItemListState> loadData() async{
    HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetMyGroups());

    if(hazizzResponse.isSuccessful){
      listItemData = hazizzResponse.convertedData;
      if(listItemData.isNotEmpty) {
        return ItemListLoaded(data: listItemData);
      }else{
        return Empty();
      }
    }
    if(hazizzResponse.hasPojoError){
      HazizzLogger.printLog("log: response is List<PojoTask>");
      return ItemListFail(error: hazizzResponse.pojoError);
    }
  }

}