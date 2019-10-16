import 'package:flutter/widgets.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/group_types_enum.dart';
import 'package:bloc/bloc.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';

abstract class JoinGroupEvent extends HEvent {
  JoinGroupEvent([List props = const []]) : super(props);
}

abstract class JoinGroupState extends HState {
  JoinGroupState([List props = const []]) : super(props);
}

class JoinGroupCreateEvent extends JoinGroupEvent {
  final GroupType groupType;
  final String groupName;
  final String password;
  JoinGroupCreateEvent({@required this.groupType, @required this.groupName, this.password})
      : assert(groupType != null), assert(groupName != null), super([groupName, password]);

  @override String toString() => 'JoinGroupCreateEvent';
}



class JoinGroupFineState extends JoinGroupState {
  @override String toString() => 'JoinGroupFineState';
}

class JoinGroupWaitingState extends JoinGroupState {
  @override String toString() => 'JoinGroupWaitingState';
}
class JoinGroupPasswordIncorrectState extends JoinGroupState {
  @override String toString() => 'JoinGroupPasswordIncorrectState';
}

class JoinGroupGroupNameTakenState extends JoinGroupState {
  @override String toString() => 'JoinGroupGroupNameTakenState';
}

class JoinGroupInvalidState extends JoinGroupState {
  @override String toString() => 'JoinGroupInvalidState';
}



class JoinGroupSuccessfulState extends JoinGroupState {
  @override String toString() => 'JoinGroupSuccessfulState';
}


class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {

  JoinGroupState get initialState => JoinGroupFineState();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Stream<JoinGroupState> mapEventToState(JoinGroupEvent event) async* {
    HazizzLogger.printLog("sentaa state asd");

    if (event is JoinGroupCreateEvent) {
      yield JoinGroupWaitingState();

      HazizzResponse hazizzResponse = await RequestSender().getResponse(RetrieveGroup.details());

      if(hazizzResponse.isSuccessful){

        //    PojoTokens tokens = hazizzResponseLogin.convertedData;

        yield JoinGroupSuccessfulState();
        // proceed to the app
      }else{
        if(hazizzResponse.hasPojoError){
          if(hazizzResponse.pojoError.errorCode == ErrorCodes.GROUP_NAME_CONFLICT.code){
            yield JoinGroupGroupNameTakenState();
          }else if(hazizzResponse.pojoError.errorCode == ErrorCodes.INVALID_DATA.code){
            yield JoinGroupInvalidState();

          }
        }
      }
    }
  }
}