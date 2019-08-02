import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dummy/schedule_dummy.dart';

import '../hazizz_response.dart';
import '../hazizz_time_of_day.dart';
import '../request_sender.dart';

import 'package:bloc/bloc.dart';

import 'main_tab_blocs/main_tab_blocs.dart';


//region ScheduleEvent events
abstract class ScheduleEventEvent extends HEvent {
  ScheduleEventEvent([List props = const []]) : super(props);
}

abstract class ScheduleEventState extends HState {
  ScheduleEventState([List props = const []]) : super(props);
}



class ScheduleEventInitializeState extends ScheduleEventState {

  ScheduleEventInitializeState() : super();

  @override
  String toString() => 'ScheduleEventInitializeState';
}


class ScheduleEventFineState extends ScheduleEventState {
  EventItem currentEvent;
  ScheduleEventFineState({@required this.currentEvent}) : super([currentEvent]);

  @override
  String toString() => 'ScheduleEventFineState';
}


class ScheduleEventTimerFiredEvent extends ScheduleEventEvent {

  ScheduleEventTimerFiredEvent() : super();

  @override
  String toString() => 'ScheduleEventTimerFiredEvent';
}



class ScheduleEventUpdateEventEvent extends ScheduleEventEvent {

  ScheduleEventUpdateEventEvent() : super();

  @override
  String toString() => 'ScheduleEventUpdateEventEvent';
}


class ScheduleEventUpdateClassesEvent extends ScheduleEventEvent {

  ScheduleEventUpdateClassesEvent() : super();

  @override
  String toString() => 'ScheduleEventUpdateClassesEvent';
}

//endregion




class EventItem{
  String text;

  HazizzTimeOfDay start;

  HazizzTimeOfDay end;

  EventItem({@required this.text, @required this.start, @required this.end});
}


class BeforeClassesEventItem extends EventItem{
  PojoClass upcommingClass;

  BeforeClassesEventItem({@required text, @required this.upcommingClass}) :
        super(text: text, start: HazizzTimeOfDay(hour: 0, minute: 0), end: upcommingClass.startOfClass){

  }
}

class AfterClassesEventItem extends EventItem{
  PojoClass lastClass;

  AfterClassesEventItem({@required text, @required this.lastClass}) :
        super(text: text, start: lastClass.startOfClass, end: HazizzTimeOfDay(hour: 23, minute: 59)){

  }
}

class ClassEventItem extends EventItem{
  PojoClass currentClass;

  ClassEventItem({@required text, @required this.currentClass}) :
  super(text: text, start: currentClass.startOfClass, end: currentClass.endOfClass){

  }
}

class BreakEventItem extends EventItem{
  PojoClass previousClass;

  PojoClass nextClass;

  BreakEventItem({@required text, @required this.previousClass, @required this.nextClass}) :
  super(text: text, start: previousClass.endOfClass, end: nextClass.startOfClass){

  }
}


class ScheduleEventBloc extends Bloc<ScheduleEventEvent, ScheduleEventState> {

  int currentEventIndex;
  List<EventItem> events = List();

  ScheduleEventBloc scheduleEventBloc;

  int currentDayIndex = DateTime.now().weekday-1;

  @override
  ScheduleEventState get initialState => ScheduleEventInitializeState();

  @override
  Stream<ScheduleEventState> mapEventToState(ScheduleEventEvent event) async* {
    if (event is ScheduleEventUpdateClassesEvent) {
      print("log: this is a debug: 0");
      calculateUpcomingEvent2();
      print("log: this is a debug: 1");

      this.dispatch(ScheduleEventUpdateEventEvent());
      print("log: this is a debug: 2");

    }else if (event is ScheduleEventUpdateEventEvent) {

      EventItem currentEvent = findCurrentEvent();
      setTimer(currentEvent.end);
      yield ScheduleEventFineState(currentEvent: currentEvent);

    }
  }

  // ez fog szolni hogy mikor kell újra calculálni
  void setTimer(HazizzTimeOfDay nextEventChangeTime2){

    void handleTimeout() {  // callback function
      // time to update the event widget
      this.dispatch(ScheduleEventUpdateEventEvent());
    }

    startTimeout() {
      HazizzTimeOfDay now = HazizzTimeOfDay.now();

      var duration = now.compare(nextEventChangeTime2);

      return new Timer(duration, handleTimeout);
    }

    startTimeout();


  }

  HazizzTimeOfDay nextEventChangeTime;

  bool nextEventChangeIsNotToday = false;


  EventItem findCurrentEvent(){
    int i = currentEventIndex != null ? currentEventIndex : 0;
    var now = HazizzTimeOfDay.now();
    for(;i < events.length; i++){
      EventItem event = events[i];
      if(event.start <= now && event.end > now){
        currentEventIndex = i;
        return event;
      }
    }
    return null;
  }



  void calculateUpcomingEvent2(){
    print("log: debugMode ACTIVATED: 0");
    List<PojoClass> todayClasses =  MainTabBlocs().schedulesBloc.classes.classes[currentDayIndex.toString()];
    print("log: debugMode ACTIVATED: 1: ${todayClasses.length}");
    events.add(BeforeClassesEventItem(text: null, upcommingClass: todayClasses[0]));
    print("log: debugMode ACTIVATED: 2");
    for(int i = 0; i < todayClasses.length; i++){
      print("log: debugMode ACTIVATED: 3: $i");
      PojoClass currentClassInLoop = todayClasses[i];

      if(currentClassInLoop.periodNumber == 1){
        events.add(ClassEventItem(text: "", currentClass: currentClassInLoop));
      }else{
        events.add(BreakEventItem(text: "", previousClass: todayClasses[i-1], nextClass: currentClassInLoop));
        events.add(ClassEventItem(text: "", currentClass: currentClassInLoop));
      }
      print("log: debugMode ACTIVATED: 4");
    }

    events.add(AfterClassesEventItem(text: null, lastClass: todayClasses[todayClasses.length-1]));

    print("log: class state: loop end");
  }


  void calculateUpcomingEvent(){

    List<PojoClass> todayClasses =  MainTabBlocs().schedulesBloc.classes.classes[currentDayIndex.toString()];

    print("log: opsie: 2");
    HazizzTimeOfDay now = HazizzTimeOfDay.now();
    print("log: opsie: 3");

    HazizzTimeOfDay closestBefore;
    HazizzTimeOfDay closestAfter;

    print("log: oy1334: todayClasses.length: ${todayClasses.length}");

    for(int i = 0; i < todayClasses.length; i++){

      print("loop: i: $i");

      PojoClass currentClassInLoop = todayClasses[i];

      if(i == 0){
        if(currentClassInLoop.startOfClass > now){
          // első óra még nem indult el

          nextEventChangeTime = currentClassInLoop.startOfClass;
          print("log: class state: első óra még nem indult el");
          break;
        }else if(currentClassInLoop.startOfClass < now && currentClassInLoop.endOfClass > now){
          // első óra már el indult, de nem ért végett
          nextEventChangeTime = currentClassInLoop.endOfClass;
          print("log: class state: első óra már el indult, de nem ért végett");
          break;
        }
      }

      else if(i == todayClasses.length-1){
        if(currentClassInLoop.startOfClass > now){
          // utlsó óra még nem indult el
          nextEventChangeTime = currentClassInLoop.startOfClass;
          print("log: class state: utlsó óra még nem indult el");
          break;
        }else if(currentClassInLoop.startOfClass < now && currentClassInLoop.endOfClass > now){
          // utlsó óra már el indult, de nem ért végett

          nextEventChangeTime = currentClassInLoop.endOfClass;
          print("log: class state: utlsó óra már el indult, de nem ért végett");
          break;
        }else{
          // az utolsó órának vége
          nextEventChangeTime = null;
          nextEventChangeIsNotToday = true;
          print("log: class state: az utlsó órának vége");
          break;
        }
      }
      else{
        if(todayClasses[i-1].endOfClass < now && currentClassInLoop.startOfClass > now){
          // szünetben
          nextEventChangeTime = currentClassInLoop.startOfClass;
          print("log: class state: szünetben: ");
          break;
        }else if(currentClassInLoop.startOfClass < now && currentClassInLoop.endOfClass > now){

          // órán, nem az első és nem is az utolsó óra ez
          nextEventChangeTime = currentClassInLoop.endOfClass;
          print("log: class state: órán, nem az első és nem is az utolsó óra ez ");
          break;
        }
        // itt már error mentesen lehet az elöző és a következő órához hasonlitani
      }
    }
    print("log: class state: loop end");
  }
}










