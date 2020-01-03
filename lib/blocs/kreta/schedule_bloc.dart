import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_date_time.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/blocs/kreta/schedule_event_bloc.dart';
import 'package:mobile/storage/caches/data_cache.dart';

//region Schedule bloc parts
//region Schedule events
abstract class ScheduleEvent extends HEvent {
  ScheduleEvent([List props = const []]) : super(props);
}

class ScheduleFetchEvent extends ScheduleEvent {
  final int yearNumber;
  final int weekNumber;

  final bool retry;

  ScheduleFetchEvent({this.yearNumber, this.weekNumber, this.retry = false}) :  super([yearNumber, weekNumber]);
  @override
  String toString() => 'ScheduleFetchEvent';
  @override
  List<Object> get props => [yearNumber, weekNumber];
}

class ScheduleSetSessionEvent extends ScheduleEvent {
  ScheduleSetSessionEvent() :  super([DateTime.now()]);
  @override
  String toString() => 'ScheduleSetSessionEvent';
  List<Object> get props => [DateTime.now()];
}
//endregion

//region Schedule states
abstract class ScheduleState extends HState {
  ScheduleState([List props = const []]) : super(props);
}

class ScheduleInitialState extends ScheduleState {
  @override
  String toString() => 'ScheduleInitialState';
  List<Object> get props => null;
}

class ScheduleWaitingState extends ScheduleState {
  @override
  String toString() => 'ScheduleWaitingState';
  List<Object> get props => null;
}



class ScheduleLoadedState extends ScheduleState {
  PojoSchedules schedules;

  ScheduleLoadedState(this.schedules) : assert(schedules!= null), super([schedules, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'ScheduleLoadedState';
  List<Object> get props => [schedules, SelectedSessionBloc().selectedSession];
}

class ScheduleLoadedCacheState extends ScheduleState {
  PojoSchedules data;

  ScheduleLoadedCacheState(this.data) : assert(data!= null), super([data, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'ScheduleLoadedCacheState';
  List<Object> get props => [data, SelectedSessionBloc().selectedSession];

}

class ScheduleErrorState extends ScheduleState {
  HazizzResponse hazizzResponse;
  ScheduleErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'ScheduleErrorState';
  List<Object> get props => [hazizzResponse];

}


//endregion

//region Schedule bloc
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  ScheduleEventBloc scheduleEventBloc;

  int currentYearNumber = DateTime.now().year;
  int currentWeekNumber = 0;

  int currentCurrentWeekNumber;
  int currentCurrentYearNumber;

  DateTime currentWeekMonday = HazizzDateTime(0, 0, 0, 0, 0);
  DateTime currentWeekSunday = HazizzDateTime(0, 0, 0, 0, 0);

  int _failedRequestCount = 0;
//  int _failedRequestLimit = 2;

  DateTime nowDate;

  DateTime selectedDate;

  PojoSchedules getScheduleFromSession(){
    Map<String, List<PojoClass>> sessionSchedules = {};

    for(String key in classes.classes.keys){
      int newI = 0;
      for(int i = 0; i < classes.classes[key].length; i++){
        if(classes.classes[key][i].accountId?.split("_")[2] == SelectedSessionBloc().selectedSession?.username){
          if(!sessionSchedules.containsKey(key) ){
            sessionSchedules[key] = [];
          }
          sessionSchedules[key].insert(newI, classes.classes[key][i]);
          newI++;
        }
      }
    }
    return PojoSchedules(sessionSchedules);
  }



  ScheduleBloc(){
    nowDate = DateTime.now();
    nowDate = nowDate.subtract(Duration(days: nowDate.weekday-1));

    selectedDate = nowDate;

    currentDayIndex = todayIndex;
    scheduleEventBloc = ScheduleEventBloc();


    currentCurrentWeekNumber = _getWeekNumber(nowDate);

    currentCurrentYearNumber = nowDate.year;

    currentWeekNumber = currentCurrentWeekNumber;
    currentYearNumber = currentCurrentYearNumber;
  }

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  PojoSchedules classes;

  PojoSchedules sessionClasses;

  int todayIndex = DateTime.now().weekday-1;

  int currentDayIndex;

  int fromCurrentWeek = 0;

  int _getYear(DateTime dateTime){
    return dateTime.year;
  }

  int _getWeekNumber(DateTime date){
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return  ((dayOfYear - date.weekday + 10) / 7).floor();
  }


  bool get selectedWeekIsCurrent => fromCurrentWeek == 0;
  bool get selectedWeekIsPrevious => fromCurrentWeek == -1;
  bool get selectedWeekIsNext =>  fromCurrentWeek == 1;


  void nextWeek(){
    fromCurrentWeek++;
    selectedDate = selectedDate.add(Duration(days: 7));

    int year = _getYear(selectedDate);
    int weekNumber = _getWeekNumber(selectedDate);

    MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: year, weekNumber: weekNumber));
  }

  void previousWeek(){
    fromCurrentWeek--;
    selectedDate = selectedDate.subtract(Duration(days: 7));
    print("slected date: ${selectedDate}");

    int year = _getYear(selectedDate);
    int weekNumber = _getWeekNumber(selectedDate);

    MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: year, weekNumber: weekNumber));
  }

  @override
  ScheduleState get initialState => ScheduleInitialState();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if(event is ScheduleSetSessionEvent){
      yield ScheduleLoadedState(classes);
    }
    else if (event is ScheduleFetchEvent) {
      try {

        yield ScheduleWaitingState();

        if(event.weekNumber != null){
          currentWeekNumber = event.weekNumber;
        }

        if(event.yearNumber != null){
          currentYearNumber = event.yearNumber;
        }

        HazizzLogger.printLog("currentWeekNumber: $currentWeekNumber");

        currentWeekMonday = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        HazizzLogger.printLog("currentWeekMonday: $currentWeekMonday");

        currentWeekSunday = currentWeekMonday.add(Duration(days: 6));

        HazizzLogger.printLog("currentWeekSunday: $currentWeekSunday");

        if(currentWeekNumber == currentCurrentWeekNumber){
          currentDayIndex = todayIndex;
        }else{
          currentDayIndex = 0;
        }


        HazizzLogger.printLog("event.yearNumber, event.weekNumber: ${event.yearNumber}, ${event.weekNumber}");

        if(currentYearNumber == currentCurrentYearNumber && currentWeekNumber == currentCurrentWeekNumber){
          DataCache dataCache = await loadScheduleCache(year: currentYearNumber, weekNumber: currentWeekNumber);
          if(dataCache!= null){
            lastUpdated = dataCache.lastUpdated;
            classes = dataCache.data;

            yield ScheduleLoadedCacheState(classes);
          }
        }

        //HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSchedulesWithSession(q_year: currentYearNumber, q_weekNumber: currentWeekNumber));
        HazizzResponse hazizzResponse = await getResponse(
          KretaGetSchedules(q_year: currentYearNumber, q_weekNumber: currentWeekNumber),
          useSecondaryOptions: event.retry
        );

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
            lastUpdated = DateTime.now();
            if(currentYearNumber == currentCurrentYearNumber && currentWeekNumber == currentCurrentWeekNumber) {
              saveScheduleCache(classes, year: currentYearNumber, weekNumber: currentWeekNumber);
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
            _failedRequestCount++;
            if(_failedRequestCount <= 1) {
              this.dispatch(ScheduleFetchEvent());
            }

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
