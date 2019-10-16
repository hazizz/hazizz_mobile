import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/group_types_enum.dart';
import 'package:bloc/bloc.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';

abstract class CreateGroupEvent extends HEvent {
  CreateGroupEvent([List props = const []]) : super(props);
}

abstract class CreateGroupState extends HState {
  CreateGroupState([List props = const []]) : super(props);
}

class CreateGroupCreateEvent extends CreateGroupEvent {
  final GroupType groupType;
  final String groupName;
  final String password;
  CreateGroupCreateEvent({@required this.groupType, @required this.groupName, this.password})
      : assert(groupType != null), assert(groupName != null), super([groupName, password]);

  @override String toString() => 'CreateGroupCreateEvent';
}



class CreateGroupFineState extends CreateGroupState {
  @override String toString() => 'CreateGroupFineState';
}

class CreateGroupWaitingState extends CreateGroupState {
  @override String toString() => 'CreateGroupWaitingState';
}
class CreateGroupPasswordIncorrectState extends CreateGroupState {
  @override String toString() => 'CreateGroupPasswordIncorrectState';
}

class CreateGroupGroupNameTakenState extends CreateGroupState {
  @override String toString() => 'CreateGroupGroupNameTakenState';
}

class CreateGroupInvalidState extends CreateGroupState {
  @override String toString() => 'CreateGroupInvalidState';
}



class CreateGroupSuccessfulState extends CreateGroupState {
  @override String toString() => 'CreateGroupSuccessfulState';
}


class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  
  CreateGroupState get initialState => CreateGroupFineState();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Stream<CreateGroupState> mapEventToState(CreateGroupEvent event) async* {
    HazizzLogger.printLog("sentaa state asd");

    if (event is CreateGroupCreateEvent) {
      yield CreateGroupWaitingState();

      HazizzResponse hazizzResponse = await RequestSender().getResponse(CreateGroup(type: event.groupType, b_groupName: event.groupName, b_password: event.password));

      if(hazizzResponse.isSuccessful){

    //    PojoTokens tokens = hazizzResponseLogin.convertedData;

        yield CreateGroupSuccessfulState();
        // proceed to the app
      }else{
        if(hazizzResponse.hasPojoError){
          if(hazizzResponse.pojoError.errorCode == ErrorCodes.GROUP_NAME_CONFLICT.code){
            yield CreateGroupGroupNameTakenState();
          }else if(hazizzResponse.pojoError.errorCode == ErrorCodes.INVALID_DATA.code){
            yield CreateGroupInvalidState();

          }
        }
      }
    }
  }
}