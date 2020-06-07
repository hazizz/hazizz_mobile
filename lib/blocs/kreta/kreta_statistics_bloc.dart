import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGradeAvarage.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import 'package:mobile/services/grade_avarage_calculator.dart';
import 'package:mobile/extension_methods/round_double_extension.dart';

//region KretaGradeStatistics events
abstract class KretaGradeStatisticsEvent extends HEvent {
  KretaGradeStatisticsEvent([List props = const []]) : super(props);
}

class KretaGradeStatisticsFetchEvent extends KretaGradeStatisticsEvent {
  @override
  String toString() => 'KretaGradeStatisticsFetchEvent';
  List<Object> get props => null;
}

class KretaGradeStatisticsGetEvent extends KretaGradeStatisticsEvent {
  final String subject;
  KretaGradeStatisticsGetEvent({@required this.subject});
  @override
  String toString() => 'KretaGradeStatisticsFetchEvent';
  List<Object> get props => [subject];
}

class KretaGradeAddEvent extends KretaGradeStatisticsEvent {
  final PojoGrade grade;
  KretaGradeAddEvent({@required this.grade});
  @override
  String toString() => 'KretaGradeAddEvent';
  List<Object> get props => [grade];
}

class KretaGradeRemoveEvent extends KretaGradeStatisticsEvent {
  final int index;
  KretaGradeRemoveEvent({@required this.index});
  @override
  String toString() => 'KretaGradeRemoveEvent';
  List<Object> get props => [index];
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
  final List<GradeStatistic> gradeStatistics;

  KretaGradeStatisticsLoadedState(this.gradeStatistics) : assert(gradeStatistics!= null), super([gradeStatistics, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'KretaGradeStatisticsLoadedState';
  List<Object> get props => [gradeStatistics, SelectedSessionBloc().selectedSession];
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

class KretaGradeStatisticsGetState extends KretaGradeStatisticsState {
  final GradeStatistic currentGradeStatistic;
  KretaGradeStatisticsGetState({@required this.currentGradeStatistic});
  @override
  String toString() => 'KretaGradeStatisticsGetState';
  List<Object> get props => [currentGradeStatistic, DateTime.now()];
}

//endregion

class GradeStatistic{
  PojoGradeAverage gradeAverage;
  List<PojoGrade> gradeList;

  GradeStatistic({@required this.gradeAverage, @required this.gradeList});
}


//region KretaGradeStatisticsBloc
class KretaGradeStatisticsBloc extends Bloc<KretaGradeStatisticsEvent, KretaGradeStatisticsState> {

  List<PojoGradeAverage> gradeAvarages = List();
 // Map<String, PojoGradeAverage> gradeAvaragesBySubject = Map();

  Map<String, GradeStatistic> gradeStatistics = {};


  String currentSubject;
  GradeStatistic currentGradeStatistic;

  List<PojoGrade> addedGrades = [];

  @override
  KretaGradeStatisticsState get initialState => KretaGradeStatisticsInitialState();

  @override
  Stream<KretaGradeStatisticsState> mapEventToState(KretaGradeStatisticsEvent event) async* {
    if(event is KretaGradeStatisticsGetEvent){
      currentSubject = event.subject;
      currentGradeStatistic = gradeStatistics[currentSubject];
      yield KretaGradeStatisticsGetState(currentGradeStatistic: currentGradeStatistic);
    }
    else if(event is KretaGradeAddEvent){
      if(currentGradeStatistic.gradeList != null){
        currentGradeStatistic.gradeList.insert(0, event.grade);
        currentGradeStatistic.gradeAverage.grade = calculateGradeAverage(currentGradeStatistic.gradeList);
        currentGradeStatistic.gradeAverage.difference = (currentGradeStatistic.gradeAverage.grade - currentGradeStatistic.gradeAverage.classGrade).round2();

        yield KretaGradeStatisticsGetState(currentGradeStatistic: currentGradeStatistic);
      }

    }
    else if(event is KretaGradeRemoveEvent){
      currentGradeStatistic.gradeList.removeAt(event.index);
      currentGradeStatistic.gradeAverage.grade = calculateGradeAverage(currentGradeStatistic.gradeList);
      currentGradeStatistic.gradeAverage.difference = (currentGradeStatistic.gradeAverage.grade - currentGradeStatistic.gradeAverage.classGrade).round2();

      yield KretaGradeStatisticsGetState(currentGradeStatistic: currentGradeStatistic);
    }
    else if (event is KretaGradeStatisticsFetchEvent) {
      try {
        yield KretaGradeStatisticsWaitingState();

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetGradeAvarages());
        if(hazizzResponse.isSuccessful){
          print("being black is fine :O: 0");
          if(hazizzResponse.convertedData != null){
            print("being black is fine :O: 1");
            gradeAvarages = hazizzResponse.convertedData;
            print("being black is fine :O: 2");

            for(PojoGradeAverage gradeAverage in gradeAvarages){
              List<PojoGrade> grades = MainTabBlocs().gradesBloc.getGradesFromSession()
                  .grades[gradeAverage.subject]?.reversed?.toList();
              grades?.removeWhere((item) =>
                item.gradeType == GradeTypeEnum.HALFYEAR ||
                item.gradeType == GradeTypeEnum.ENDYEAR
              );
              HazizzLogger.printLog("íasfukhsdv: " + gradeAverage.subject + ": " + grades.toString());
              gradeStatistics[gradeAverage.subject] = GradeStatistic(gradeAverage: gradeAverage, gradeList: grades);
            }

          //  yield KretaGradeStatisticsGetState(currentGradeStatistic: );

            List<String> keyList = gradeStatistics.keys.toList();
            currentGradeStatistic = gradeStatistics[keyList[keyList.length-1]];
            yield KretaGradeStatisticsGetState(currentGradeStatistic: currentGradeStatistic);


         //   yield KretaGradeStatisticsLoadedState(gradeStatistics);
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
