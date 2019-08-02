import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/schedule_event_bloc.dart';

class ScheduleEventWidget extends StatelessWidget{

  ScheduleEventWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: MainTabBlocs().schedulesBloc.scheduleEventBloc,
      builder: (context, ScheduleEventState state){

        String text = "error";
        if(state is ScheduleEventFineState){
          var currentEvent = state.currentEvent;
          text = "event will be over: ${currentEvent.end.hour}:${currentEvent.end.minute}";
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
