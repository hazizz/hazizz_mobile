import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/schedule_event_bloc.dart';

import '../logger.dart';

class ScheduleEventWidget extends StatelessWidget{

  ScheduleEventWidget();

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

          text = "event will be over: ${currentEvent.end.hour}:${currentEvent.end.minute}";

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
                  print("tap tap");
                },
                child:
                Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Text(text, // "8 perc maradt a szünetből" "25 perc a szünetig"
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
