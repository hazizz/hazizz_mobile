import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/text_field_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/cache_manager.dart';

import '../hazizz_response.dart';
import '../image_operations.dart';
import '../request_sender.dart';


class UserDataBlocs{

  ProfilePictureBloc pictureBloc = ProfilePictureBloc();
  DisplayNameBloc displayNameBloc = DisplayNameBloc();
  MyUserDataBloc userDataBloc = MyUserDataBloc();


  static final UserDataBlocs _singleton = new UserDataBlocs._internal();
  factory UserDataBlocs() {
    return _singleton;
  }
  UserDataBlocs._internal();

  void initialize(){
    userDataBloc.dispatch(MyUserDataGetEvent());
    pictureBloc.dispatch(ProfilePictureGetEvent());

  }



  dispose(){
    pictureBloc.dispose();
  }
}

/*
abstract class DisplayNameState extends HState {
  DisplayNameState([List props = const []]) : super(props);
}
abstract class DisplayNameEvent extends HEvent {
  DisplayNameEvent([List props = const []]) : super(props);
}
*/

//region GroupItemPickerBlocParts
//region GroupItemListEvents

abstract class ProfilePictureState extends HState {
  ProfilePictureState([List props = const []]) : super(props);
}
abstract class ProfilePictureEvent extends HEvent {
  ProfilePictureEvent([List props = const []]) : super(props);
}

class ProfilePictureSetEvent extends ProfilePictureEvent {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final Uint8List imageBytes;
  ProfilePictureSetEvent({@required this.imageBytes})
      : assert(imageBytes != null), super([imageBytes]);
  @override
  String toString() => 'ProfilePictureSetEvent';
}

class ProfilePictureGetEvent extends ProfilePictureEvent {
  @override
  String toString() => 'ProfilePictureGetEvent';
}

class ProfilePictureRefreshEvent extends ProfilePictureEvent {
  @override
  String toString() => 'ProfilePictureChangedState';
}

//endregion

//region GroupItemListStates
class ProfilePictureInitialState extends ProfilePictureState {
  @override
  String toString() => 'ProfilePictureInitialState';
}

class ProfilePictureLoadedState extends ProfilePictureState {
  @override
  String toString() => 'ProfilePictureLoadedState';
}

class ProfilePictureWaitingState extends ProfilePictureState {
  @override
  String toString() => 'ProfilePictureWaitingState';
}

//endregion

//region GroupItemListBloc
class ProfilePictureBloc extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  Uint8List profilePictureBytes;

  @override
  // TODO: implement initialState
  ProfilePictureState get initialState => ProfilePictureInitialState();

  @override
  Stream<ProfilePictureState> mapEventToState(event) async*{
    print("log: profilepic event: $event");

    if(event is ProfilePictureGetEvent) {
      yield ProfilePictureWaitingState();
      String str_profilePicture = await InfoCache.getMyProfilePicture();
      if(str_profilePicture == null){
        HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyProfilePicture.full());

        if(hazizzResponse.isSuccessful){
          str_profilePicture = hazizzResponse.convertedData;

        }
      }
      profilePictureBytes = ImageOpeations.fromBase64ToBytesImage(str_profilePicture);


      yield ProfilePictureLoadedState();
    }

    if(event is ProfilePictureSetEvent) {
      yield ProfilePictureWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new UpdateMyProfilePicture(
              encodedImage: fromBytesImageToBase64(event.imageBytes)));
      if(hazizzResponse.isSuccessful) {
        InfoCache.setMyProfilePicture(hazizzResponse.convertedData);
        profilePictureBytes = event.imageBytes;
        yield ProfilePictureLoadedState();
      }
    }
    else if(event is ProfilePictureRefreshEvent) {
      yield ProfilePictureWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new GetMyProfilePicture.full());
      if(hazizzResponse.isSuccessful) {
        InfoCache.setMyProfilePicture(hazizzResponse.convertedData);
        profilePictureBytes = hazizzResponse.convertedData;
        yield ProfilePictureLoadedState();
      }
    }
  }

  /*
  @override
  Stream<ProfilePictureState> mapEventToState(ProfilePictureEvent event) async* {
    if(event is ProfilePictureSetEvent) {
      yield ProfilePictureWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new UpdateMyProfilePicture(
              encodedImage: fromBytesImageToBase64(event.imageBytes)));
      if(hazizzResponse.isSuccessful) {
        InfoCache.setMyProfilePicture(hazizzResponse.convertedData);
        profilePictureBytes = event.imageBytes;
        yield ProfilePictureLoadedState();
      }
    }
    else if(event is ProfilePictureRefreshEvent) {
      yield ProfilePictureWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new GetMyProfilePicture.full());
      if(hazizzResponse.isSuccessful) {
        InfoCache.setMyProfilePicture(hazizzResponse.convertedData);
        profilePictureBytes = event.imageBytes;
        yield ProfilePictureLoadedState();
      }
    }
  }
  */
}

















/*






//region GroupItemPickerBlocParts
//region GroupItemListEvents

abstract class DisplayNameState extends HState {
  DisplayNameState([List props = const []]) : super(props);
}
abstract class DisplayNameEvent extends HEvent {
  DisplayNameEvent([List props = const []]) : super(props);
}

class DisplayNameLoadFromCacheEvent extends DisplayNameEvent {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final String displayName;
  DisplayNameLoadFromCacheEvent({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override
  String toString() => 'DisplayNameLoadFromCacheEvent';
}

class DisplayNameSendEvent extends DisplayNameEvent {
  @override
  String toString() => 'DisplayNameSendEvent';
}

class DisplayNameLoadedFromCacheState extends DisplayNameState {
  final String displayName;
  DisplayNameLoadedFromCacheState({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override String toString() => 'DisplayNameLoadedFromCacheState';
}

class DisplayNameSavedState extends DisplayNameState {
  @override String toString() => 'DisplayNameSavedState';
}

class DisplayNameChangedState extends DisplayNameState {
  final String displayName;
  DisplayNameChangedState({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override String toString() => 'DisplayNameChangedState';
}

class DisplayNameChangedEvent extends DisplayNameEvent {
  final String displayName;
  DisplayNameChangedEvent({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override String toString() => 'DisplayNameChangedEvent';
}

class DisplayNameInitialState extends DisplayNameState {
  @override String toString() => 'DisplayNameInitialState';
}



//endregion

//region GroupItemListStates

//endregion

//region GroupItemListBloc
class DisplayNameBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  String displayName;

  String lastText;

  TextEditingController displayNameController = TextEditingController();


  DisplayNameBloc() {
    displayNameController.addListener((){
      if(this.currentState is! DisplayNameInitialState && displayNameController.text != lastText){
        lastText = displayNameController.text;
        this.dispatch(DisplayNameChangedEvent(displayName: displayNameController.text));
      }
    });
  }

  @override
  // TODO: implement initialState
  DisplayNameState get initialState => DisplayNameInitialState();

  @override
  Stream<DisplayNameState> mapEventToState(DisplayNameEvent event) async* {

    print("log: displayNameEvnet:  $event");

    if(event is DisplayNameLoadFromCacheEvent){
      displayNameController.text = event.displayName;
      lastText = event.displayName;
      yield DisplayNameLoadedFromCacheState(displayName: event.displayName);
    }else if (event is DisplayNameSendEvent){
      if(this.currentState is DisplayNameChangedState){
        HazizzResponse hazizzResponse = await getResponse(UpdateMyDisplayName(b_displayName: displayNameController.text));

        if(hazizzResponse.isSuccessful){

          PojoMeInfo meInfo = hazizzResponse.convertedData;

          displayNameController.text = meInfo.displayName;
          yield DisplayNameSavedState();
        }
      }
    }else if(event is DisplayNameChangedEvent){
      yield DisplayNameChangedState(displayName: event.displayName);
    }
  }


}
*/







































abstract class DisplayNameState extends HState {
  DisplayNameState([List props = const []]) : super(props);
}
abstract class DisplayNameEvent extends HEvent {
  DisplayNameEvent([List props = const []]) : super(props);
}

class DisplayNameSetEvent extends DisplayNameEvent {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final String newDisplayName;
  DisplayNameSetEvent({@required this.newDisplayName})
      : assert(newDisplayName != null), super([newDisplayName]);
  @override
  String toString() => 'DisplayNameSetEvent';
}

class DisplayNameRefreshEvent extends DisplayNameEvent {
  @override
  String toString() => 'DisplayNameRefreshEvent';
}

//endregion

//region GroupItemListStates
class DisplayNameInitialState extends DisplayNameState {
  @override
  String toString() => 'DisplayNameInitialState';
}

class DisplayNameLoadedState extends DisplayNameState {
  @override
  String toString() => 'DisplayNameLoadedState';
}

class DisplayNameWaitingState extends DisplayNameState {
  @override
  String toString() => 'DisplayNameWaitingState';
}

//endregion

//region GroupItemListBloc
class DisplayNameBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  String displayName;

  @override
  // TODO: implement initialState
  DisplayNameState get initialState => DisplayNameInitialState();

  @override
  Stream<DisplayNameState> mapEventToState(DisplayNameEvent event) async* {
    if(event is DisplayNameSetEvent) {
      yield DisplayNameWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new UpdateMyDisplayName(b_displayName: event.newDisplayName));
      if(hazizzResponse.isSuccessful) {

        PojoMeInfo meInfo = hazizzResponse.convertedData;

        InfoCache.setMyDisplayName(meInfo.displayName);
        displayName = meInfo.displayName;
        yield DisplayNameLoadedState();
      }
    }
    else if(event is ProfilePictureRefreshEvent) {
      yield DisplayNameWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new GetMyProfilePicture.full());
      if(hazizzResponse.isSuccessful) {
        InfoCache.setMyProfilePicture(hazizzResponse.convertedData);
      //  profilePictureBytes = event.imageBytes;
        yield DisplayNameLoadedState();
      }
    }
  }
}










































abstract class MyUserDataState extends HState {
  MyUserDataState([List props = const []]) : super(props);
}
abstract class MyUserDataEvent extends HEvent {
  MyUserDataEvent([List props = const []]) : super(props);
}

class MyUserDataGetEvent extends MyUserDataEvent {
  @override
  String toString() => 'MyUserDataGetEvent';
}

class MyUserDataRefreshEvent extends MyUserDataEvent {
  @override
  String toString() => 'MyUserDataRefreshEvent';
}

class MyUserDataChangeDisplaynameEvent extends MyUserDataEvent {
  String displayName;
  MyUserDataChangeDisplaynameEvent({this.displayName}) : super([displayName]){

  }
  @override
  String toString() => 'MyUserDataChangeDisplaynameEvent';
}


//endregion

//region GroupItemListStates
class MyUserDataInitialState extends MyUserDataState {
  @override
  String toString() => 'MyUserDataInitialState';
}

class MyUserDataLoadedState extends MyUserDataState {
  PojoMeInfo meInfo;
  MyUserDataLoadedState({@required this.meInfo}) : super([meInfo]){

  }
  @override
  String toString() => 'MyUserDataLoadedState';
}


class MyUserDataWaitingState extends MyUserDataState {
  @override
  String toString() => 'MyUserDataWaitingState';
}

//endregion

//region GroupItemListBloc
class MyUserDataBloc extends Bloc<MyUserDataEvent, MyUserDataState> {
  PojoMeInfoPrivate myUserData;

  @override
  // TODO: implement initialState
  MyUserDataState get initialState => MyUserDataInitialState();

  @override
  Stream<MyUserDataState> mapEventToState(MyUserDataEvent event) async* {
    print("log: myuserdata event: $event");
    if(event is MyUserDataGetEvent) {
      yield MyUserDataWaitingState();

      PojoMeInfoPrivate meInfoCached = await InfoCache.getMyUserData();

      if(meInfoCached == null){

        HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyInfo.private());

        if(hazizzResponse.isSuccessful){
          PojoMeInfoPrivate meInfoRefreshed = hazizzResponse.convertedData;
          myUserData = meInfoRefreshed;
          InfoCache.setMyUserData(meInfoRefreshed);

        }
      }else{
        myUserData = meInfoCached;
      }

      yield MyUserDataLoadedState(meInfo: meInfoCached);


    }
    /*
    else if(event is ProfilePictureRefreshEvent) {
      yield MyUserDataWaitingState();

      HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyInfo.private());

      if(hazizzResponse.isSuccessful){
        PojoMeInfoPrivate meInfoRefreshed = hazizzResponse.convertedData;
        myUserData = meInfoRefreshed;
      }

      yield MyUserDataLoadedState();
    }
    */
    else if(event is MyUserDataChangeDisplaynameEvent){
      PojoMeInfo meInfo = await InfoCache.getMyUserData();
      print("debuglol: 3 ${meInfo.displayName}");
      meInfo.displayName = event.displayName;
      print("debuglol: 4 ${meInfo.displayName}");
      InfoCache.setMyUserData(meInfo);
      myUserData = meInfo;
      yield MyUserDataLoadedState(meInfo: meInfo);
    }
  }
}














