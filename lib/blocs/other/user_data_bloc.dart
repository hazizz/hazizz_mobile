import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoMyDetailedInfo.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/storage/cache_manager.dart';


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
    userDataBloc.add(MyUserDataGetEvent());
    pictureBloc.add(ProfilePictureGetEvent());

  }



  Future<void> close(){
    return pictureBloc.close();
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
  List<Object> get props => [imageBytes];
}

class ProfilePictureGetEvent extends ProfilePictureEvent {
  @override
  String toString() => 'ProfilePictureGetEvent';
  List<Object> get props => null;
}

class ProfilePictureRefreshEvent extends ProfilePictureEvent {
  @override
  String toString() => 'ProfilePictureChangedState';
  List<Object> get props => null;
}

//endregion

//region GroupItemListStates
class ProfilePictureInitialState extends ProfilePictureState {
  @override
  String toString() => 'ProfilePictureInitialState';
  List<Object> get props => null;
}

class ProfilePictureLoadedState extends ProfilePictureState {
  @override
  String toString() => 'ProfilePictureLoadedState';
  List<Object> get props => null;
}

class ProfilePictureWaitingState extends ProfilePictureState {
  @override
  String toString() => 'ProfilePictureWaitingState';
  List<Object> get props => null;
}

//endregion

//region GroupItemListBloc
class ProfilePictureBloc extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  Uint8List profilePictureBytes;

  @override
  ProfilePictureState get initialState => ProfilePictureInitialState();

  @override
  Stream<ProfilePictureState> mapEventToState(event) async*{
    HazizzLogger.printLog("log: profilepic event: $event");

    if(event is ProfilePictureGetEvent) {
      yield ProfilePictureWaitingState();
      String strProfilePicture = await CacheManager.getMyProfilePicture();
      if(strProfilePicture == null){
        HazizzLogger.printLog("baj van fönök: 1");

        HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyProfilePicture.full());

        if(hazizzResponse.isSuccessful){
          strProfilePicture = hazizzResponse.convertedData;

        }
      }

      if(strProfilePicture != null){
        profilePictureBytes = ImageOperations.fromBase64ToBytesImage(strProfilePicture);
        yield ProfilePictureLoadedState();
      }

    }

    if(event is ProfilePictureSetEvent) {
      yield ProfilePictureWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new UpdateMyProfilePicture(
              encodedImage: fromBytesImageToBase64(event.imageBytes)));
      if(hazizzResponse.isSuccessful) {
        CacheManager.setMyProfilePicture(hazizzResponse.convertedData);
        profilePictureBytes = event.imageBytes;
        yield ProfilePictureLoadedState();
      }
    }
    else if(event is ProfilePictureRefreshEvent) {
      yield ProfilePictureWaitingState();
      HazizzLogger.printLog("baj van fönök: 2");
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new GetMyProfilePicture.full());
      if(hazizzResponse.isSuccessful) {
        CacheManager.setMyProfilePicture(hazizzResponse.convertedData);
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
      if(this.state is! DisplayNameInitialState && displayNameController.text != lastText){
        lastText = displayNameController.text;
        this.add(DisplayNameChangedEvent(displayName: displayNameController.text));
      }
    });
  }

  @override
  DisplayNameState get initialState => DisplayNameInitialState();

  @override
  Stream<DisplayNameState> mapEventToState(DisplayNameEvent event) async* {

    HazizzLogger.printLog("log: displayNameEvnet:  $event");

    if(event is DisplayNameLoadFromCacheEvent){
      displayNameController.text = event.displayName;
      lastText = event.displayName;
      yield DisplayNameLoadedFromCacheState(displayName: event.displayName);
    }else if (event is DisplayNameSendEvent){
      if(this.state is DisplayNameChangedState){
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
  List<Object> get props => [newDisplayName];
}

class DisplayNameRefreshEvent extends DisplayNameEvent {
  @override
  String toString() => 'DisplayNameRefreshEvent';
  List<Object> get props => null;
}

//endregion

//region GroupItemListStates
class DisplayNameInitialState extends DisplayNameState {
  @override
  String toString() => 'DisplayNameInitialState';
  List<Object> get props => null;
}

class DisplayNameLoadedState extends DisplayNameState {
  @override
  String toString() => 'DisplayNameLoadedState';
  List<Object> get props => null;
}

class DisplayNameWaitingState extends DisplayNameState {
  @override
  String toString() => 'DisplayNameWaitingState';
  List<Object> get props => null;
}

//endregion

//region GroupItemListBloc
class DisplayNameBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  String displayName;

  @override
  DisplayNameState get initialState => DisplayNameInitialState();

  @override
  Stream<DisplayNameState> mapEventToState(DisplayNameEvent event) async* {
    if(event is DisplayNameSetEvent) {
      yield DisplayNameWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new UpdateMyDisplayName(bDisplayName: event.newDisplayName));
      if(hazizzResponse.isSuccessful) {

        PojoMeInfo meInfo = hazizzResponse.convertedData;

        CacheManager.setMyDisplayName(meInfo.displayName);
        displayName = meInfo.displayName;
        yield DisplayNameLoadedState();
      }
    }
    else if(event is ProfilePictureRefreshEvent) {
      yield DisplayNameWaitingState();
      HazizzLogger.printLog("baj van fönök: 3");
      HazizzResponse hazizzResponse = await RequestSender().getResponse(
          new GetMyProfilePicture.full());
      if(hazizzResponse.isSuccessful) {
        CacheManager.setMyProfilePicture(hazizzResponse.convertedData);
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
  List<Object> get props => null;
}

class MyUserDataRefreshEvent extends MyUserDataEvent {
  @override
  String toString() => 'MyUserDataRefreshEvent';
  List<Object> get props => null;
}

class MyUserDataChangeDisplaynameEvent extends MyUserDataEvent {
  final String displayName;
  MyUserDataChangeDisplaynameEvent({this.displayName}) : super([displayName]);
  @override
  String toString() => 'MyUserDataChangeDisplaynameEvent';
  List<Object> get props => [displayName];
}


//endregion

//region GroupItemListStates
class MyUserDataInitialState extends MyUserDataState {
  @override
  String toString() => 'MyUserDataInitialState';
  List<Object> get props => null;
}

class MyUserDataLoadedState extends MyUserDataState {
  PojoMyDetailedInfo meInfo;
  MyUserDataLoadedState({@required this.meInfo}) : super([meInfo]){

  }
  @override
  String toString() => 'MyUserDataLoadedState';
  List<Object> get props => [meInfo];
}


class MyUserDataWaitingState extends MyUserDataState {
  @override
  String toString() => 'MyUserDataWaitingState';
  List<Object> get props => null;
}

//endregion

//region GroupItemListBloc
class MyUserDataBloc extends Bloc<MyUserDataEvent, MyUserDataState> {
  PojoMyDetailedInfo myUserData;

  @override
  MyUserDataState get initialState => MyUserDataInitialState();

  @override
  Stream<MyUserDataState> mapEventToState(MyUserDataEvent event) async* {
    HazizzLogger.printLog("log: myuserdata event: $event");
    if(event is MyUserDataGetEvent) {
      yield MyUserDataWaitingState();

      PojoMyDetailedInfo meInfoCached = await CacheManager.getMyUserData();
      HazizzLogger.printLog("log: 13123s: 0");
      if(meInfoCached == null){

        PojoMeInfoPrivate meInfoCachedOld = await CacheManager.getMyUserDataOld();

        PojoMyDetailedInfo meInfoGenerated = PojoMyDetailedInfo(
          id: meInfoCachedOld.id,
          username: meInfoCachedOld.username,
          registrationDate: null, emailAddress: null,
          disabled: null, expired: null,
          facebookId: null, googleEmailAddress: null,
          lastUpdated: null, locked: null
        );
        CacheManager.setMyUserData(meInfoGenerated);

        yield MyUserDataLoadedState(meInfo: meInfoGenerated);



        HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyInfo.private());
        HazizzLogger.printLog("log: 13123s: 1");

        if(hazizzResponse.isSuccessful){
          HazizzLogger.printLog("log: 13123s: ${hazizzResponse.convertedData}");

          PojoMyDetailedInfo myDetailedInfoRefreshed = hazizzResponse.convertedData;
          myUserData = myDetailedInfoRefreshed;
          CacheManager.setMyUserData(myDetailedInfoRefreshed);
          meInfoCached = myDetailedInfoRefreshed;
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
      /*
      PojoMyDetailedInfo meInfo = await CacheManager.getMyUserData();
      HazizzLogger.printLog("debuglol: 3 ${meInfo.displayName}");
      meInfo.displayName = event.displayName;
      HazizzLogger.printLog("debuglol: 4 ${meInfo.displayName}");
      CacheManager.setMyUserData(meInfo);
      myUserData = meInfo;
      yield MyUserDataLoadedState(meInfo: meInfo);
      */
    }
  }
}














