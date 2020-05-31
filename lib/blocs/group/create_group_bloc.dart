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

abstract class CreateGroupEvent extends HEvent {
  CreateGroupEvent([List props = const []]) : super(props);
}

abstract class CreateGroupState extends HState {
  CreateGroupState([List props = const []]) : super(props);
}

class CreateGroupCreateEvent extends CreateGroupEvent {
  final GroupTypeEnum groupType;
  final String groupName;
  CreateGroupCreateEvent({@required this.groupType, @required this.groupName})
      : assert(groupType != null), assert(groupName != null), super([groupName]);

  @override String toString() => 'CreateGroupCreateEvent';
  @override
  List<Object> get props => [groupName, groupType];
}



class CreateGroupFineState extends CreateGroupState {
  @override String toString() => 'CreateGroupFineState';
  @override
  List<Object> get props => null;
}

class CreateGroupWaitingState extends CreateGroupState {
  @override String toString() => 'CreateGroupWaitingState';
  @override
  List<Object> get props => null;
}
class CreateGroupPasswordIncorrectState extends CreateGroupState {
  @override String toString() => 'CreateGroupPasswordIncorrectState';
  @override
  List<Object> get props => null;
}

class CreateGroupGroupNameTakenState extends CreateGroupState {
  @override String toString() => 'CreateGroupGroupNameTakenState';
  @override
  List<Object> get props => null;
}

class CreateGroupInvalidState extends CreateGroupState {
  @override String toString() => 'CreateGroupInvalidState';
  @override
  List<Object> get props => null;
}



class CreateGroupSuccessfulState extends CreateGroupState {
  @override String toString() => 'CreateGroupSuccessfulState';
  @override
  List<Object> get props => null;
}

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  
  CreateGroupState get initialState => CreateGroupFineState();

  @override
  Stream<CreateGroupState> mapEventToState(CreateGroupEvent event) async* {
    HazizzLogger.printLog("sentaa state asd");

    if (event is CreateGroupCreateEvent) {
      yield CreateGroupWaitingState();

      HazizzResponse hazizzResponse;

      if(event.groupType == GroupTypeEnum.CLOSED){
        hazizzResponse = await getResponse(CreateGroup.closed(bGroupName: event.groupName));
      }else{
        hazizzResponse = await getResponse(CreateGroup.open(bGroupName: event.groupName));
      }

      if(hazizzResponse.isSuccessful){
        yield CreateGroupSuccessfulState();
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