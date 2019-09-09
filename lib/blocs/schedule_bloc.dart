import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_date_time.dart';

import 'package:mobile/managers/kreta_session_manager.dart';

import '../caches/data_cache.dart';
import '../communication/connection.dart';
import '../communication/errors.dart';
import '../communication/pojos/PojoClass.dart';
import '../communication/pojos/PojoSchedules.dart';
import '../communication/requests/request_collection.dart';
import '../hazizz_response.dart';
import '../hazizz_time_of_day.dart';
import '../request_sender.dart';
import 'main_tab_blocs/main_tab_blocs.dart';
import 'schedule_event_bloc.dart';

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


  DateTime currentWeekMonday = HazizzDateTime(0, 0, 0, 0, 0);
  DateTime currentWeekSunday = HazizzDateTime(0, 0, 0, 0, 0);


  MainSchedulesBloc(){
    scheduleEventBloc = ScheduleEventBloc();
  }

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  PojoSchedules classes;

  int currentDayIndex = DateTime.now().weekday-1;

  @override
  ScheduleState get initialState => ScheduleInitialState();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleFetchEvent) {
      try {
        currentWeekNumber = event.weekNumber;
        print("currentWeekNumber: $currentWeekNumber");

        currentWeekMonday = DateTime(event.yearNumber, 1, 1);
        print("currentWeekMonday: $currentWeekMonday");

        currentWeekMonday = currentWeekMonday.add(Duration(days: 7 * (currentWeekNumber-1)));

        print("currentWeekMonday2: $currentWeekMonday, ${7 * (currentWeekNumber-1)}");

        currentWeekSunday = currentWeekMonday.add(Duration(days: 6));

        print("currentWeekSunday: $currentWeekSunday");


        yield ScheduleWaitingState();

        print("WIATING222 : ${event.yearNumber}, ${event.weekNumber}");


        if(event.yearNumber == currentYearNumber && event.weekNumber == currentWeekNumber){
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

        print("WEEK OF YEAR: $weekOfYear");*/

          // now.month, 7 * (currentWeekNumber-1)



        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSchedules(q_year: event.yearNumber, q_weekNumber: event.weekNumber));

        //  print("classes.: ${classes}");
        if(hazizzResponse.isSuccessful){

          print("classes.classes: ${ hazizzResponse.convertedData}");
          classes = hazizzResponse.convertedData;

          /*
          classes = PojoSchedules({"1": [
            PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
            PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
            PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
            PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),

          ],
            "2": [
              PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 2, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),
              PojoClass(date: DateTime(2000), periodNumber: 1, startOfClass: HazizzTimeOfDay(hour: 2, minute: 2), endOfClass: HazizzTimeOfDay(hour: 2, minute: 2), className: "TEST", topic: "TOPIC", subject: "SUBJECT", room: "", cancelled: true, standIn: true, teacher: "PEKÁR LOL"),

            ],

          });
          */

          if(classes != null ){

            currentWeekNumber = event.weekNumber;
            currentYearNumber = event.yearNumber;
            lastUpdated = DateTime.now();
            if(!event.isDefault) {
              saveScheduleCache(classes);
            }

            print("log: opsie: 0");

            // classes = classesDummy;


            print("log: opsie: 0");

           // scheduleEventBloc.dispatch(ScheduleEventUpdateClassesEvent());

            yield ScheduleLoadedState(classes);

            print("log: oy133");
          }


        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            print("log: noConnectionError22");
            yield ScheduleErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(ScheduleFetchEvent());
            },
                "schedule_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            print("log: noConnectionError22");
            this.dispatch(ScheduleFetchEvent());
          }else{
            yield ScheduleErrorState(hazizzResponse);

          }


        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }

}
//endregion
//endregion
