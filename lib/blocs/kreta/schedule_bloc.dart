import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_date_time.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/managers/kreta_session_manager.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/blocs/kreta/schedule_event_bloc.dart';
import 'package:mobile/storage/caches/data_cache.dart';

//region EditTask bloc parts
//region EditTask events
abstract class ScheduleEvent extends HEvent {
  ScheduleEvent([List props = const []]) : super(props);
}

class ScheduleFetchEvent extends ScheduleEvent {
  int yearNumber;
  int weekNumber;
  bool isDefault = false;

  ScheduleFetchEvent({this.yearNumber, this.weekNumber}) :  super([yearNumber, weekNumber]){
    if(weekNumber == null || yearNumber == null){
      yearNumber ??= DateTime.now().year;
      DateTime now = DateTime.now();
      int dayOfYear = int.parse(DateFormat("D").format(now));
      weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
      isDefault = true;
    }
  }
  @override
  String toString() => 'ScheduleFetchEvent';
}
//endregion

//region SubjectItemListStates
abstract class ScheduleState extends HState {
  ScheduleState([List props = const []]) : super(props);
}

class ScheduleInitialState extends ScheduleState {
  @override
  String toString() => 'ScheduleInitialState';
}

class ScheduleWaitingState extends ScheduleState {
  @override
  String toString() => 'ScheduleWaitingState';
}



class ScheduleLoadedState extends ScheduleState {
  PojoSchedules schedules;

  ScheduleLoadedState(this.schedules) : assert(schedules!= null), super([schedules]);
  @override
  String toString() => 'ScheduleLoadedState';
}

class ScheduleLoadedCacheState extends ScheduleState {
  PojoSchedules data;

  ScheduleLoadedCacheState(this.data) : assert(data!= null), super([data]);
  @override
  String toString() => 'ScheduleLoadedCacheState';
}

class ScheduleErrorState extends ScheduleState {
  HazizzResponse hazizzResponse;
  ScheduleErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'ScheduleErrorState';
}


//endregion

//region SubjectItemListBloc
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  ScheduleEventBloc scheduleEventBloc;

  int currentYearNumber = DateTime.now().year;
  int currentWeekNumber = 0;

  int currentCurrentWeekNumber;
  int currentCurrentYearNumber;

  DateTime currentWeekMonday = HazizzDateTime(0, 0, 0, 0, 0);
  DateTime currentWeekSunday = HazizzDateTime(0, 0, 0, 0, 0);


  ScheduleBloc(){
    currentDayIndex = todayIndex;
    scheduleEventBloc = ScheduleEventBloc();

    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    currentCurrentWeekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();

    currentCurrentYearNumber = now.year;
  }

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  PojoSchedules classes;

  int todayIndex = DateTime.now().weekday-1;

  int currentDayIndex;



  void nextWeek(){
    MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber+1));
    currentDayIndex = 0;
  }

  void previousWeek(){
    MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber-1));
    currentDayIndex= 0;
  }


  @override
  ScheduleState get initialState => ScheduleInitialState();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleFetchEvent) {
      try {
        currentWeekNumber = event.weekNumber;
        HazizzLogger.printLog("currentWeekNumber: $currentWeekNumber");

        currentWeekMonday = DateTime(event.yearNumber, 1, 1);
        HazizzLogger.printLog("currentWeekMonday: $currentWeekMonday");

        currentWeekMonday = currentWeekMonday.add(Duration(days: 7 * (currentWeekNumber-1)));

        HazizzLogger.printLog("currentWeekMonday2: $currentWeekMonday, ${7 * (currentWeekNumber-1)}");

        currentWeekMonday = currentWeekMonday.subtract(Duration(days: 1));

        currentWeekSunday = currentWeekMonday.add(Duration(days: 6));

        HazizzLogger.printLog("currentWeekSunday: $currentWeekSunday");


        yield ScheduleWaitingState();

        HazizzLogger.printLog("event.yearNumber, event.weekNumber: ${event.yearNumber}, ${event.weekNumber}");


        if(event.yearNumber == currentCurrentYearNumber && event.weekNumber == currentCurrentWeekNumber){
          DataCache dataCache = await loadScheduleCache();
          if(dataCache!= null){
            lastUpdated = dataCache.lastUpdated;
            classes = dataCache.data;

            yield ScheduleLoadedCacheState(classes);
          }
        }



       // DateTime now = DateTime.now();
/*
        int dayOfYear = int.parse(DateFormat("D").format(n ow));
        int weekOfYear = ((dayOfYear - now.weekday + 10) / 7).floor();

        HazizzLogger.printLog("WEEK OF YEAR: $weekOfYear");*/

          // now.month, 7 * (currentWeekNumber-1)



        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSchedules(q_year: event.yearNumber, q_weekNumber: event.weekNumber));

        //  HazizzLogger.printLog("classes.: ${classes}");
        if(hazizzResponse.isSuccessful){
          classes = hazizzResponse.convertedData;


          /*
          classes = PojoSchedules({"0": [
            PojoClass(date: DateTime(2000), periodNumber: 0, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
            PojoClass(date: DateTime(2000), periodNumber: 0, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
            PojoClass(date: DateTime(2000), periodNumber: 0, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
            PojoClass(date: DateTime(2000), periodNumber: 0, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),

          ],
            "3": [
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),

            ],
            "4": [
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),

            ],



          });
          */

          if(classes != null ){

            currentWeekNumber = event.weekNumber;
            currentYearNumber = event.yearNumber;
            lastUpdated = DateTime.now();
            if(event.yearNumber == currentCurrentYearNumber && event.weekNumber == currentCurrentWeekNumber) {
              saveScheduleCache(classes);
            }
            yield ScheduleLoadedState(classes);
          }


        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            yield ScheduleErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(ScheduleFetchEvent());
            },
                "schedule_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            this.dispatch(ScheduleFetchEvent());
          }else{
            yield ScheduleErrorState(hazizzResponse);

          }


        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }

}
//endregion
//endregion
