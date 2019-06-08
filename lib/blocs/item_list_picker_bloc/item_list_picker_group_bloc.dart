<<<<<<< HEAD
import 'package:hazizz_mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
=======
import 'package:flutter_hazizz/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/PojoGroup.dart';
import 'package:flutter_hazizz/communication/requests/request_collection.dart';
>>>>>>> 697a6e3b071e12017449a7ca76eb8a9feb3f5ba0

import '../../RequestSender.dart';

class ItemListPickerGroupBloc extends ItemListPickerBloc{

  @override
  Future<ItemListState> loadData() async{
    dynamic responseData = await RequestSender().getResponse(new GetMyGroups());
    print("log: responseData: ${responseData}");
    print("log: responseData type:  ${responseData.runtimeType.toString()}");

    if(responseData is List<PojoGroup>){
      listItemData = responseData;
      if(listItemData.isNotEmpty) {
        return Loaded(data: listItemData);
      }else{
        return Empty();
      }
    }
    if(responseData is PojoError){
      print("log: response is List<PojoTask>");
      return Error(error: responseData);
    }
  }

/*
  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is ItemListLoadData) {
      try {
        yield ItemListWaiting();
        dynamic responseData = await RequestSender().getResponse(new GetMyGroups());
        print("log: responseData: ${responseData}");
        print("log: responseData type:  ${responseData.runtimeType.toString()}");

        if(responseData is List<PojoGroup>){
          listItemData = responseData;
          if(listItemData.isNotEmpty) {
            yield ItemListLoaded(data: listItemData);
          }else{
            yield ItemListEmpty();
          }
        }
        if(responseData is PojoError){
          print("log: response is List<PojoTask>");
          yield ItemListError(error: responseData);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }
  }
  */
}