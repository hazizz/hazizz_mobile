import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoGradeAvarage.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';

//region KretaGradeStatistics events
abstract class KretaGradeStatisticsEvent extends HEvent {
  KretaGradeStatisticsEvent([List props = const []]) : super(props);
}

class KretaGradeStatisticsFetchEvent extends KretaGradeStatisticsEvent {
  @override
  String toString() => 'KretaGradeStatisticsFetchEvent';
  List<Object> get props => null;
}
//endregion

//region KretaGradeStatistics states
abstract class KretaGradeStatisticsState extends HState {
  KretaGradeStatisticsState([List props = const []]) : super(props);
}

class KretaGradeStatisticsInitialState extends KretaGradeStatisticsState {
  @override
  String toString() => 'KretaGradeStatisticsInitialState';
  List<Object> get props => null;
}

class KretaGradeStatisticsWaitingState extends KretaGradeStatisticsState {
  @override
  String toString() => 'KretaGradeStatisticsWaitingState';
  List<Object> get props => null;
}

class KretaGradeStatisticsLoadedState extends KretaGradeStatisticsState {
  final List<PojoGradeAverage> gradeAvarages;

  KretaGradeStatisticsLoadedState(this.gradeAvarages) : assert(gradeAvarages!= null), super([gradeAvarages, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'KretaGradeStatisticsLoadedState';
  List<Object> get props => [gradeAvarages, SelectedSessionBloc().selectedSession];
}

class KretaGradeStatisticsLoadedCacheState extends KretaGradeStatisticsState {
  final List<PojoGradeAverage> gradeAvarages;
  KretaGradeStatisticsLoadedCacheState(this.gradeAvarages) : assert(gradeAvarages!= null), super([gradeAvarages, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'KretaGradeStatisticsLoadedCacheState';
  List<Object> get props => [gradeAvarages, SelectedSessionBloc().selectedSession];
}

class KretaGradeStatisticsErrorState extends KretaGradeStatisticsState {
  final HazizzResponse hazizzResponse;
  KretaGradeStatisticsErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'KretaGradeStatisticsErrorState';
  List<Object> get props => [hazizzResponse];
}
//endregion

//region KretaGradeStatisticsBloc
class KretaGradeStatisticsBloc extends Bloc<KretaGradeStatisticsEvent, KretaGradeStatisticsState> {

  List<PojoGradeAverage> gradeAvarages = List();
  Map<String, PojoGradeAverage> gradeAvaragesBySubject = Map();



  @override
  KretaGradeStatisticsState get initialState => KretaGradeStatisticsInitialState();

  @override
  Stream<KretaGradeStatisticsState> mapEventToState(KretaGradeStatisticsEvent event) async* {

    if (event is KretaGradeStatisticsFetchEvent) {
      try {
        yield KretaGradeStatisticsWaitingState();

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetGradeAvarages());
        if(hazizzResponse.isSuccessful){
          print("being black is fine :O: 0");
          if(hazizzResponse.convertedData != null){
            print("being black is fine :O: 1");
            gradeAvarages = hazizzResponse.convertedData;
            print("being black is fine :O: 2");
            yield KretaGradeStatisticsLoadedState(gradeAvarages);
            print("being black is fine :O: 3");
          }else{
            yield KretaGradeStatisticsErrorState(hazizzResponse);
          }
        }

        else{
          if(hazizzResponse.dioError == noConnectionError){
            yield KretaGradeStatisticsErrorState(hazizzResponse);
            Connection.addConnectionOnlineListener((){
              this.add(KretaGradeStatisticsFetchEvent());
            },
                "KretaGradeStatistics_fetch"
            );
          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            HazizzLogger.printLog("log: noConnectionError22");
            this.add(KretaGradeStatisticsFetchEvent());
          } else if(hazizzResponse.hasPojoError && hazizzResponse.pojoError.errorCode == 138) {
            yield KretaGradeStatisticsErrorState(hazizzResponse);
          }
          else{
            yield KretaGradeStatisticsErrorState(hazizzResponse);

          }
        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}
//endregion
