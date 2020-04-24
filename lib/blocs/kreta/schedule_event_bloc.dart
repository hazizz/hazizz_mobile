import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/custom/hazizz_date_time.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/logger.dart';
import 'package:mobile/custom/hazizz_time_of_day.dart';

import 'package:bloc/bloc.dart';

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
  List<Object> get props => null;

}


class ScheduleEventFineState extends ScheduleEventState {
  EventItem currentEvent;
  EventItem nextEvent;
  ScheduleEventFineState({@required this.currentEvent, @required this.nextEvent}) : super([currentEvent]);

  @override
  String toString() => 'ScheduleEventFineState';
  List<Object> get props => [currentEvent];
}


class ScheduleEventTimerFiredEvent extends ScheduleEventEvent {

  ScheduleEventTimerFiredEvent() : super();

  @override
  String toString() => 'ScheduleEventTimerFiredEvent';
  List<Object> get props => null;
}



class ScheduleEventUpdateEvent extends ScheduleEventEvent {

  ScheduleEventUpdateEvent() : super();

  @override
  String toString() => 'ScheduleEventUpdateEvent';
  List<Object> get props => null;
}

class ScheduleEventNextEvent extends ScheduleEventEvent {

  ScheduleEventNextEvent() : super();

  @override
  String toString() => 'ScheduleEventNextEvent';
  List<Object> get props => null;
}

class ScheduleEventNextDayEvent extends ScheduleEventEvent {

  ScheduleEventNextDayEvent() : super();

  @override
  String toString() => 'ScheduleEventNextDayEvent';
  List<Object> get props => null;
}



class ScheduleEventUpdateClassesEvent extends ScheduleEventEvent {

  ScheduleEventUpdateClassesEvent() : super();

  @override
  String toString() => 'ScheduleEventUpdateClassesEvent';
  List<Object> get props => null;
}

//endregion

//region Event item parts
// Áll: időtartamból és egy event típusból(child class)
class EventItem{

  HazizzDateTime start;

  HazizzDateTime end;

  EventItem({@required this.start, @required this.end}){
  }
}

class BeforeClassesEventItem extends EventItem{
  BeforeClassesEventItem({
    @required HazizzDateTime start,
    @required  HazizzDateTime end}) :
    super(start: start, end: end);
}

class AfterClassesEventItem extends EventItem{
  PojoClass tomorrowClass;
  AfterClassesEventItem({
    @required HazizzDateTime start,
    @required  HazizzDateTime end,
    this.tomorrowClass}) :
    super(start: start, end: end);

  AfterClassesEventItem.fromClass({
    @required PojoClass lastClass,
    @required  PojoClass upcomingClass,
    this.tomorrowClass}) :
    super(
      start: HazizzDateTime.fromTimeOfDay(lastClass.endOfClass),
      end: HazizzDateTime.fromTimeOfDay(upcomingClass.startOfClass)
    );
}


class NoSchoolEventItem extends EventItem{
  NoSchoolEventItem({
    @required HazizzDateTime start,
    @required  HazizzDateTime end}) :
    super(start: start, end: end);
}

class ClassEventItem extends EventItem{
  PojoClass currentClass;

  ClassEventItem({
    @required HazizzDateTime start,
    @required  HazizzDateTime end,
    @required this.currentClass}) :
    super(start: start, end: end
  );

  ClassEventItem.fromClass({
    @required this.currentClass}) :
    super(
      start: HazizzDateTime.fromTimeOfDay(currentClass.startOfClass),
      end: HazizzDateTime.fromTimeOfDay(currentClass.endOfClass)
    );
}

class BreakEventItem extends EventItem{

  BreakEventItem({
    @required HazizzDateTime start,
    @required  HazizzDateTime end}) :
    super(start: start, end: end);
}
//endregion

//region ScheduleEvent bloc
class ScheduleEventBloc extends Bloc<ScheduleEventEvent, ScheduleEventState> {

  int currentEventIndex;
  List<EventItem> events = List();

  ScheduleEventBloc scheduleEventBloc;

  int currentDayIndex = HazizzDateTime.now().weekday-1;

  EventItem currentEvent;

  @override
  ScheduleEventState get initialState => ScheduleEventInitializeState();

  @override
  Stream<ScheduleEventState> mapEventToState(ScheduleEventEvent event) async* {
    if(event is ScheduleEventNextEvent) {
      setNextEvent();

      yield ScheduleEventFineState(currentEvent: currentEvent, nextEvent: nextEvent());

    }
    if (event is ScheduleEventUpdateClassesEvent) {
      HazizzLogger.printLog("log: this is a debug: 0");
      calculateUpcomingEvent2();

      findCurrentEvent();


      HazizzLogger.printLog("log: this is a debug: 1");

      this.add(ScheduleEventUpdateEvent());
      HazizzLogger.printLog("log: this is a debug: 2");

    }else if (event is ScheduleEventUpdateEvent) {

      yield ScheduleEventFineState(currentEvent: currentEvent, nextEvent: nextEvent());

    }
  }

  // ez fog szolni hogy mikor kell újra kalkulálni
  void setTimer(HazizzDateTime nextEventChangeTime2){

    void handleTimeout() {  // callback function
      // time to update the event widget
      HazizzLogger.printLog("TIMER FIRED !!!");
      this.add(ScheduleEventNextEvent());
    }

    startTimeout() {
      HazizzDateTime now = HazizzDateTime.now();

      var duration = (nextEventChangeTime2.difference(now));

      HazizzLogger.printLog("DURATION: ${duration.inMinutes}, ${duration.inSeconds}");

      return new Timer(duration, handleTimeout);
    }

    startTimeout();
  }

  HazizzTimeOfDay nextEventChangeTime;

  bool nextEventChangeIsNotToday = false;


  EventItem nextEvent(){
    try{
      return events[currentEventIndex+1];
    }catch(e){
      return null;
    }
  }

   setPreviousEvent(){
    currentEventIndex++;
    currentEvent = events[currentEventIndex];
  }

   setNextEvent(){
    currentEventIndex++;
    currentEvent = events[currentEventIndex];
  }

  EventItem previousEvent(){
    try{
      return events[currentEventIndex-1];
    }catch(e){
      return null;
    }
  }

  EventItem findCurrentEvent(){
    int i = currentEventIndex != null ? currentEventIndex : 0;
    var now = HazizzDateTime.now();
    for(;i < events.length; i++){
      EventItem event = events[i];
      logger.d("iteratrion: $i, event: $event, event.start: ${event.start}, event.end: ${event.end}");
      if(event.start <= now && event.end > now){
        currentEventIndex = i;
        currentEvent = event;

        setTimer(currentEvent.end);

        return event;
      }else{
        logger.d("iteratrion: $i, event.start <= now && event.end > now: false");

      }
    }
    return null;
  }



  void calculateUpcomingEvent2(){
    HazizzLogger.printLog("log: debugMode ACTIVATED: 0");
    if( MainTabBlocs().schedulesBloc.classes.classes.containsKey(currentDayIndex.toString())) {
      List<PojoClass> todayClasses = MainTabBlocs().schedulesBloc.classes
          .classes[currentDayIndex.toString()];

      HazizzLogger.printLog("log: debugMode ACTIVATED: 1: ${todayClasses.length}");
      events.add(BeforeClassesEventItem(start: HazizzDateTime.fromToday(0, 0), end: HazizzDateTime.fromTimeOfDay(todayClasses[0].startOfClass) ));
      HazizzLogger.printLog("log: debugMode ACTIVATED: 2");
      for(int i = 0; i < todayClasses.length; i++){
        HazizzLogger.printLog("log: debugMode ACTIVATED: 3: $i");
        PojoClass currentClassInLoop = todayClasses[i];

        if(currentClassInLoop.periodNumber == 1){
          events.add(ClassEventItem.fromClass(currentClass: currentClassInLoop));
        }else{
          events.add(BreakEventItem(start: HazizzDateTime.fromTimeOfDay(todayClasses[i-1].endOfClass), end: HazizzDateTime.fromTimeOfDay(currentClassInLoop.startOfClass)));
          events.add(ClassEventItem.fromClass(currentClass: currentClassInLoop));
        }
        HazizzLogger.printLog("log: debugMode ACTIVATED: 4");
      }
      // van holnap óra
      HazizzLogger.printLog("log: class state: loop end");
    }
    else{
      events.add(NoSchoolEventItem(start: HazizzDateTime.fromToday(0, 0), end: HazizzDateTime.fromToday(23, 59)));
      HazizzLogger.printLog("log: 998: null or empty;");
    }
  }


  void calculateUpcomingEvent(){

    List<PojoClass> todayClasses =  MainTabBlocs().schedulesBloc.classes.classes[currentDayIndex.toString()];

    HazizzLogger.printLog("log: opsie: 2");
    HazizzTimeOfDay now = HazizzTimeOfDay.now();
    HazizzLogger.printLog("log: opsie: 3");

    HazizzLogger.printLog("log: oy1334: todayClssaes.length: ${todayClasses.length}");

    for(int i = 0; i < todayClasses.length; i++){

      HazizzLogger.printLog("loop: i: $i");

      PojoClass currentClassInLoop = todayClasses[i];

      if(i == 0){
        if(currentClassInLoop.startOfClass > now){
          // első óra még nem indult el

          nextEventChangeTime = currentClassInLoop.startOfClass;
          HazizzLogger.printLog("log: class state: első óra még nem indult el");
          break;
        }else if(currentClassInLoop.startOfClass < now && currentClassInLoop.endOfClass > now){
          // első óra már el indult, de nem ért végett
          nextEventChangeTime = currentClassInLoop.endOfClass;
          HazizzLogger.printLog("log: class state: első óra már el indult, de nem ért végett");
          break;
        }
      }

      else if(i == todayClasses.length-1){
        if(currentClassInLoop.startOfClass > now){
          // utlsó óra még nem indult el
          nextEventChangeTime = currentClassInLoop.startOfClass;
          HazizzLogger.printLog("log: class state: utlsó óra még nem indult el");
          break;
        }else if(currentClassInLoop.startOfClass < now && currentClassInLoop.endOfClass > now){
          // utlsó óra már el indult, de nem ért végett

          nextEventChangeTime = currentClassInLoop.endOfClass;
          HazizzLogger.printLog("log: class state: utlsó óra már el indult, de nem ért végett");
          break;
        }else{
          // az utolsó órának vége
          nextEventChangeTime = null;
          nextEventChangeIsNotToday = true;
          HazizzLogger.printLog("log: class state: az utlsó órának vége");
          break;
        }
      }
      else{
        if(todayClasses[i-1].endOfClass < now && currentClassInLoop.startOfClass > now){
          // szünetben
          nextEventChangeTime = currentClassInLoop.startOfClass;
          HazizzLogger.printLog("log: class state: szünetben: ");
          break;
        }else if(currentClassInLoop.startOfClass < now && currentClassInLoop.endOfClass > now){

          // órán, nem az első és nem is az utolsó óra ez
          nextEventChangeTime = currentClassInLoop.endOfClass;
          HazizzLogger.printLog("log: class state: órán, nem az első és nem is az utolsó óra ez ");
          break;
        }
        // itt már error mentesen lehet az elöző és a következő órához hasonlitani
      }
    }
    HazizzLogger.printLog("log: class state: loop end");
  }
}
//endregion