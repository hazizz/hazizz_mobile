import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';

import 'package:mobile/blocs/kreta/schedule_event_bloc.dart';
import 'package:mobile/custom/hazizz_date_time.dart';

import 'package:mobile/custom/logger.dart';


class ScheduleEventWidget extends StatefulWidget {
  ScheduleEventWidget({Key key}) : super(key: key);

  @override
  _ScheduleEventWidget createState() => _ScheduleEventWidget();
}

class _ScheduleEventWidget extends State<ScheduleEventWidget> with SingleTickerProviderStateMixin {


  Duration countdownToEventEnd;
  HazizzDateTime eventEnd;

  void resetCountdown(){
    new Timer.periodic(Duration(seconds: 1), (Timer t) => setState((){
      HazizzDateTime now = HazizzDateTime.now();

      countdownToEventEnd = now.difference(eventEnd);
    }));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: MainTabBlocs().schedulesBloc.scheduleEventBloc,
      builder: (context, ScheduleEventState state){

        String text = "error";
        if(state is ScheduleEventFineState){

          logger.d("ScheduleEventFineState: currentEvent: ${state.currentEvent}, nextEvent: ${state.nextEvent}");

          var currentEvent = state.currentEvent;
          var nextEvent = state.nextEvent;

          if(currentEvent is ClassEventItem){
            String nextEventText= "ERROR";
            if(nextEvent is BreakEventItem){

              nextEventText = "${nextEvent.end.difference(nextEvent.start).inMinutes} minute break";
            }
            text = "${currentEvent.currentClass.subject} will be over: ${currentEvent.end.hour}:${currentEvent.end.minute}\n" +
                   "The next event is: $nextEventText";

            eventEnd = currentEvent.end;
            resetCountdown();

          } if(currentEvent is BreakEventItem){
            text = "Break will be over: ${currentEvent.end.hour}:${currentEvent.end.minute}";

            eventEnd = currentEvent.end;
            resetCountdown();
          }
          if(currentEvent is NoSchoolEventItem){
            text = "Tanítási szünet: ${currentEvent.end.hour}:${currentEvent.end.minute}";
          }

          if(currentEvent is AfterClassesEventItem) {
            if(currentEvent.tomorrowClass != null) {
              text = "Az óráknak vége\nHolnap: ${currentEvent.tomorrowClass.startOfClass
                  .toHazizzFormat()} - ${currentEvent.tomorrowClass.className}";
            }else{
              text = "Az óráknak vége\n"
                     "Holnap: tanítási szünet";
            }
          }
        }else if(state is ScheduleEventInitializeState){
          text = "log: state is ScheduleEventInitializeState";
        }
        return Card(
          color: Colors.red,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: InkWell(
              onTap: () {

              },
              child:
              Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                    child: Text("${countdownToEventEnd.inMinutes}:${countdownToEventEnd.inSeconds}:" + text, // "8 perc maradt a szünetből" "25 perc a szünetig"
                      style: TextStyle(
                          fontSize: 24
                      ),
                    ),
                  )
              )
          )
        );
      },
    );
  }
}
