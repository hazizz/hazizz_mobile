import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:bloc/bloc.dart';

import '../hazizz_response.dart';
import '../logger.dart';
import '../request_sender.dart';
import 'auth_bloc.dart';

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
    print("sentaa state asd");

    if (event is CreateGroupCreateEvent) {
      yield CreateGroupWaitingState();

      HazizzResponse hazizzResponseLogin = await RequestSender().getResponse(CreateGroup(type: event.groupType, b_groupName: event.groupName, b_password: event.password));

      if(hazizzResponseLogin.isSuccessful){

    //    PojoTokens tokens = hazizzResponseLogin.convertedData;

        yield CreateGroupSuccessfulState();
        // proceed to the app
      }else{

      }
    }
  }
}