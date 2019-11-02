import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/storage/cache_manager.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/blocs/other/user_data_bloc.dart';


class ProfileEditorBlocs{

  ProfilePictureEditorBloc pictureEditorBloc;
  DisplayNameEditorBloc displayNameEditorBloc;



  ProfileEditorBlocs(){
    pictureEditorBloc = new ProfilePictureEditorBloc();

    pictureEditorBloc.dispatch(ProfilePictureEditorLoadFromCacheEvent());


    displayNameEditorBloc = new DisplayNameEditorBloc();

    displayNameEditorBloc.dispatch(DisplayNameLoadFromCacheEvent());

  }

  dispose(){
    pictureEditorBloc.dispose();
    displayNameEditorBloc.dispose();

  }
}



abstract class DisplayNameTextFieldState extends HState {
  DisplayNameTextFieldState([List props = const []]) : super(props);
}
abstract class DisplayNameTextFieldEvent extends HEvent {
  DisplayNameTextFieldEvent([List props = const []]) : super(props);
}

//region GroupItemPickerBlocParts
//region GroupItemListEvents

abstract class ProfilePictureEditorState extends HState {
  ProfilePictureEditorState([List props = const []]) : super(props);
}
abstract class ProfilePictureEditorEvent extends HEvent {
  ProfilePictureEditorEvent([List props = const []]) : super(props);
}

class ProfilePictureEditorChangedEvent extends ProfilePictureEditorEvent {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final Uint8List imageBytes;
  ProfilePictureEditorChangedEvent({@required this.imageBytes})
      : assert(imageBytes != null), super([imageBytes]);
  @override
  String toString() => 'ProfilePictureEditorChangedEvent';
  List<Object> get props => [imageBytes];
}

class ProfilePictureEditorSavedEvent extends ProfilePictureEditorEvent {
  @override
  String toString() => 'ProfilePictureEditorSavedEvent';
  List<Object> get props => null;
}

class ProfilePictureEditorLoadFromCacheEvent extends ProfilePictureEditorEvent{
  @override
  String toString() => 'ProfilePictureEditorLoadFromCacheEvent';
  List<Object> get props => null;
}

class ProfilePictureEditorFetchEvent extends ProfilePictureEditorEvent {
  @override String toString() => 'ProfilePictureEditorFetchEvent';
  List<Object> get props => null;
}


//endregion

//region GroupItemListStates
class ProfilePictureEditorChangedState extends ProfilePictureEditorState {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final Uint8List imageBytes;
  ProfilePictureEditorChangedState({@required this.imageBytes})
      : assert(imageBytes != null), super([imageBytes]);
  @override
  String toString() => 'ProfilePictureEditorChangedState';
  List<Object> get props => [imageBytes];
}

class ProfilePictureEditorWaitingState extends ProfilePictureEditorState {
  @override
  String toString() => 'ProfilePictureEditorWaitingState';
  List<Object> get props => null;
}

class ProfilePictureEditorFineState extends ProfilePictureEditorState {
  // PickedState(this.item, [List props = const []]) : assert(item != null), super(props);
  final Uint8List imageBytes;
  ProfilePictureEditorFineState({@required this.imageBytes})
      : assert(imageBytes != null), super([imageBytes]);
  @override
  String toString() => 'ProfilePictureEditorFineState';
  List<Object> get props => [imageBytes];
}

class ProfilePictureEditorInitialState extends ProfilePictureEditorState {
  @override String toString() => 'ProfilePictureEditorInitialState';
  List<Object> get props => null;
}


//endregion

//region GroupItemListBloc
class ProfilePictureEditorBloc extends Bloc<ProfilePictureEditorEvent, ProfilePictureEditorState> {
  Uint8List profilePictureBytes;

  static int counter = 0;


  ProfilePictureEditorBloc() {
    counter++;
    HazizzLogger.printLog("log: ProfilePictureEditorBloc instances: $counter");
  }

  @override
  // TODO: implement initialState
  ProfilePictureEditorState get initialState => ProfilePictureEditorInitialState();

  @override
  Stream<ProfilePictureEditorState> mapEventToState(ProfilePictureEditorEvent event) async* {
    if(event is ProfilePictureEditorLoadFromCacheEvent){

      HazizzLogger.printLog("log: userdata UserDataBlocs().pictureBloc.profilePictureBytes : ${UserDataBlocs().pictureBloc.profilePictureBytes}");

      profilePictureBytes =  UserDataBlocs().pictureBloc.profilePictureBytes;

      yield ProfilePictureEditorFineState(imageBytes: UserDataBlocs().pictureBloc.profilePictureBytes);
    }
    
    else if (event is ProfilePictureEditorChangedEvent) {
      profilePictureBytes = event.imageBytes;

      HazizzLogger.printLog("log: 89238sjdsad: $profilePictureBytes");
      yield ProfilePictureEditorWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(new UpdateMyProfilePicture(encodedImage: fromBytesImageToBase64(profilePictureBytes)));

      if (hazizzResponse.isSuccessful) {

        UserDataBlocs().pictureBloc.dispatch(ProfilePictureSetEvent(imageBytes: profilePictureBytes));

        yield ProfilePictureEditorFineState(imageBytes: profilePictureBytes);


      }else{
        yield ProfilePictureEditorChangedState(imageBytes: profilePictureBytes);
      }
    }
    else if (event is ProfilePictureEditorSavedEvent) {
      yield ProfilePictureEditorWaitingState();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(new UpdateMyProfilePicture(encodedImage: fromBytesImageToBase64(profilePictureBytes)));

      if (hazizzResponse.isSuccessful) {

        UserDataBlocs().pictureBloc.dispatch(ProfilePictureSetEvent(imageBytes: profilePictureBytes));

        yield ProfilePictureEditorFineState(imageBytes: profilePictureBytes);


      }else{
        yield ProfilePictureEditorChangedState(imageBytes: profilePictureBytes);
      }
    }else if(event is ProfilePictureEditorFetchEvent){
      HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetMyGroups());
    }
  }


}

























//region GroupItemPickerBlocParts
//region GroupItemListEvents

abstract class DisplayNameState extends HState {
  DisplayNameState([List props = const []]) : super(props);
}
abstract class DisplayNameEvent extends HEvent {
  DisplayNameEvent([List props = const []]) : super(props);
}

class DisplayNameLoadFromCacheEvent extends DisplayNameEvent {
  @override
  String toString() => 'DisplayNameLoadFromCacheEvent';
  List<Object> get props => null;
}

class DisplayNameSendEvent extends DisplayNameEvent {
  @override
  String toString() => 'DisplayNameSendEvent';
  List<Object> get props => null;
}

class DisplayNameLoadedFromCacheState extends DisplayNameState {
  final String displayName;
  DisplayNameLoadedFromCacheState({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override String toString() => 'DisplayNameLoadedFromCacheState';
  List<Object> get props => [displayName];
}

class DisplayNameSavedState extends DisplayNameState {
  @override String toString() => 'DisplayNameSavedState';
  List<Object> get props => null;
}

class DisplayNameChangedState extends DisplayNameState {
  final String displayName;
  DisplayNameChangedState({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override String toString() => 'DisplayNameChangedState';
  List<Object> get props => [displayName];
}

class DisplayNameChangedEvent extends DisplayNameEvent {
  final String displayName;
  DisplayNameChangedEvent({@required this.displayName})
      : assert(displayName != null), super([displayName]);
  @override String toString() => 'DisplayNameChangedEvent';
  List<Object> get props => [displayName];
}

class DisplayNameInitialState extends DisplayNameState {
  @override String toString() => 'DisplayNameInitialState';
  List<Object> get props => null;
}



//endregion

//region GroupItemListStates

//endregion

//region GroupItemListBloc
class DisplayNameEditorBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  String displayName;

  String lastText;

  TextEditingController displayNameController = TextEditingController();


  DisplayNameEditorBloc() {
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

    HazizzLogger.printLog("log: displayNameEvnet:  $event");

    if(event is DisplayNameLoadFromCacheEvent){
      String displayNameFromCache = UserDataBlocs().userDataBloc.myUserData.displayName;

      HazizzLogger.printLog("log: userdata dname: $displayNameFromCache");

      displayNameController.text = displayNameFromCache;

      lastText = displayNameFromCache;

      yield DisplayNameLoadedFromCacheState(displayName: displayNameFromCache);
    }else if (event is DisplayNameSendEvent){
      if(this.currentState is DisplayNameChangedState){
        HazizzResponse hazizzResponse = await getResponse(UpdateMyDisplayName(b_displayName: displayNameController.text));

        if(hazizzResponse.isSuccessful){

          PojoMeInfo meInfo = hazizzResponse.convertedData;

          displayNameController.text = meInfo.displayName;

          HazizzLogger.printLog("debuglol: 1");
          UserDataBlocs().userDataBloc.dispatch(MyUserDataChangeDisplaynameEvent(displayName: displayNameController.text));
          HazizzLogger.printLog("debuglol: 2");
          yield DisplayNameSavedState();
        }
      }
    }else if(event is DisplayNameChangedEvent){
      yield DisplayNameChangedState(displayName: event.displayName);
    }
  }


}








