
import 'package:mobile/communication/requests/request_collection.dart';

import '../../RequestSender.dart';
import '../../hazizz_response.dart';
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
      print("log: response is List<PojoTask>");
      return Error(error: hazizzResponse.pojoError);
    }
  }

}