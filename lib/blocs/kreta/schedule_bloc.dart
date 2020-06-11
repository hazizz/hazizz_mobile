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
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/blocs/kreta/schedule_event_bloc.dart';
import 'package:mobile/services/selected_session_helper.dart';
import 'package:mobile/storage/caches/data_cache.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

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
  final DateTime dateTime;
  ScheduleSetSessionEvent({this.dateTime}) :  super([dateTime]);
  @override
  String toString() => 'ScheduleSetSessionEvent';
  List<Object> get props => [dateTime];
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
  final int year, week;
  final PojoSchedules schedules;

  final List<PojoSession> failedSessions;

  ScheduleLoadedState(this.schedules, {this.year, this.week, this.failedSessions})
      : assert(schedules!= null), super([schedules, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'ScheduleLoadedState';
  List<Object> get props => [schedules, SelectedSessionBloc().selectedSession, DateTime.now()];
}

class ScheduleLoadedCacheState extends ScheduleState {
  final PojoSchedules data;
  final List<PojoSession> failedSessions;

  ScheduleLoadedCacheState(this.data, {this.failedSessions})
      : assert(data!= null), super([data, SelectedSessionBloc().selectedSession]);
  @override
  String toString() => 'ScheduleLoadedCacheState';
  List<Object> get props => [data, SelectedSessionBloc().selectedSession];

}

class ScheduleErrorState extends ScheduleState {
  final HazizzResponse hazizzResponse;
  ScheduleErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'ScheduleErrorState';
  List<Object> get props => [hazizzResponse];

}


//endregion

//region Schedule bloc
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  List<PojoSession> failedSessions = [];

  final ScheduleEventBloc scheduleEventBloc = ScheduleEventBloc();

  int currentYearNumber = DateTime.now().year;
  int currentWeekNumber = 0;

  int currentCurrentWeekNumber;
  int currentCurrentYearNumber;

  DateTime currentWeekMonday = DateTime(0, 0, 0, 0, 0);
  DateTime currentWeekSunday = DateTime(0, 0, 0, 0, 0);

  int _failedRequestCount = 0;

  DateTime nowDate;

  DateTime selectedDate;

  PojoSchedules getScheduleFromSession(){
    Map<String, List<PojoClass>> sessionSchedules = {};

    for(String key in classes.classes.keys){
      int newI = 0;
      for(int i = 0; i < classes.classes[key].length; i++){
        print("selected session username: ${SelectedSessionBloc().selectedSession?.username}");
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



    currentCurrentWeekNumber = _getWeekNumber(nowDate);

    currentCurrentYearNumber = nowDate.year;

    currentWeekNumber = currentCurrentWeekNumber;
    currentYearNumber = currentCurrentYearNumber;
  }

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  PojoSchedules classes;

  PojoSchedules sessionClasses;

  final int todayIndex = DateTime.now().weekday-1;
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
    selectedDate = selectedDate.add(7.days);

    int year = _getYear(selectedDate);
    int weekNumber = _getWeekNumber(selectedDate);

    MainTabBlocs().schedulesBloc.add(ScheduleFetchEvent(yearNumber: year, weekNumber: weekNumber));
  }

  void previousWeek(){
    fromCurrentWeek--;
    selectedDate = selectedDate.subtract(7.days);
    print("slected date: $selectedDate");

    int year = _getYear(selectedDate);
    int weekNumber = _getWeekNumber(selectedDate);

    MainTabBlocs().schedulesBloc.add(ScheduleFetchEvent(yearNumber: year, weekNumber: weekNumber));
  }

  @override
  ScheduleState get initialState => ScheduleInitialState();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if(event is ScheduleSetSessionEvent){
      print("Updating ScheduleBloc state due to new session selected");
      yield ScheduleLoadedState(classes, year: currentYearNumber, week: currentWeekNumber, failedSessions: failedSessions);
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

        currentWeekSunday = currentWeekMonday.add(6.days);

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

        HazizzResponse hazizzResponse = await getResponse(
          KretaGetSchedules(qYear: currentYearNumber, qWeekNumber: currentWeekNumber),
          useSecondaryOptions: event.retry
        );

        if(hazizzResponse.isSuccessful){
          failedSessions = getFailedSessionsFromHeader(hazizzResponse.response.headers);

          PojoSchedules r = hazizzResponse.convertedData;
          if(r != null && r.classes.isNotEmpty){
            classes = hazizzResponse.convertedData;

            if(classes != null ){
              lastUpdated = DateTime.now();
              if(currentYearNumber == currentCurrentYearNumber && currentWeekNumber == currentCurrentWeekNumber) {
                saveScheduleCache(classes, year: currentYearNumber, weekNumber: currentWeekNumber);
              }
              yield ScheduleLoadedState(classes, year: currentYearNumber, week: currentWeekNumber, failedSessions: failedSessions);
            }
          }else{
            yield ScheduleLoadedCacheState(classes, failedSessions: failedSessions);
          }
        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            yield ScheduleErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
                this.add(ScheduleFetchEvent());
              },
              "schedule_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
                || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            _failedRequestCount++;
            if(_failedRequestCount <= 1) {
              this.add(ScheduleFetchEvent());
            }else{
              yield ScheduleLoadedCacheState(classes);
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

  void closeBloc(){
    scheduleEventBloc.close();
  }
}
//endregion
//endregion
