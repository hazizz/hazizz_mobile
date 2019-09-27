import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/schedule_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/listItems/class_item_widget.dart';
import 'package:mobile/widgets/schedule_event_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/custom/hazizz_time_of_day.dart';


class SchedulesTabPage extends StatefulWidget {

  List<PojoClass> classes;

  bool noClasses = false;

  bool isToday = false;

  SchedulesTabPage({Key key, @required this.classes, this.isToday = false}) : super(key: key){
  }

  SchedulesTabPage.noClasses({Key key,this.isToday = false}) : super(key: key){
    noClasses = true;
  }

  @override
  _SchedulesTabPage createState() => _SchedulesTabPage();
}

class _SchedulesTabPage extends State<SchedulesTabPage> with TickerProviderStateMixin {

  _SchedulesPage(){}

  HazizzTimeOfDay now = HazizzTimeOfDay.now();

  void updateTime(){
    setState(() {
      now = HazizzTimeOfDay.now();
    });
  }

  void updateEveryMinute(){
    Timer(Duration(minutes: 1), () {
      if(this.mounted) {
        updateTime();
        updateEveryMinute();
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        updateEveryMinute();
      });
    }
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.noClasses){
      return Stack(
        children: <Widget>[
          Center(child: Text(locText(context, key: "no_classes_today"))),
          Builder(
            builder: (context){
              if(MainTabBlocs().schedulesBloc.currentDayIndex >= 5) {
                return Positioned(
                    right: 0, bottom: 10,
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text(
                              locText(context, key: "next_week").toLowerCase()),
                          Icon(FontAwesomeIcons.chevronRight)
                        ],
                      ),
                      onPressed: () {
                        MainTabBlocs().schedulesBloc.dispatch(
                            ScheduleFetchEvent(
                                yearNumber: MainTabBlocs().schedulesBloc
                                    .currentYearNumber,
                                weekNumber: MainTabBlocs().schedulesBloc
                                    .currentWeekNumber + 1));
                      },
                    )
                );
              }
              return Container();
            },
          )
        ],
      );
    }

    HazizzLogger.printLog("it is today: ${widget.isToday}");

    List<Widget> listItems = [];

    for(PojoClass c in widget.classes){
      listItems.add(ClassItemWidget(pojoClass: c));
    }

    int i = 0;
    if(widget.isToday){
      // megnézi az időt


     // now = HazizzTimeOfDay(hour: 8, minute: 20);

      for(; i < widget.classes.length; i++){

        PojoClass previousClass = i-1 >= 0 ? widget.classes[i-1]:  null;
        PojoClass currentClass = widget.classes[i];
        PojoClass nextClass = i+1 <= widget.classes.length-1 ? widget.classes[i+1]: null;

        if(currentClass.startOfClass <= now && currentClass.endOfClass > now){
          // megy az óra
          listItems[i] = ClassItemWidget.isCurrentEvent(pojoClass: widget.classes[i],);
        }
        else if(currentClass.startOfClass > now && previousClass == null){
          // óra elött, nem kezdödött el a suli

          listItems.insert(0, ScheduleEventWidget.beforeClasses(context));
          i = 0;//i-1;
          break;
        }

        else if(currentClass.startOfClass > now && previousClass.endOfClass < now){
          // óra elött
          // i < 0 ? i = 0: i-1
          listItems.insert(i-1, ScheduleEventWidget.breakTime(context));
          i = i-1;
          break;

        }
        else if(currentClass.endOfClass < now && nextClass == null){
          // óra után, sulinak vége
          listItems.insert(i+1,ScheduleEventWidget.afterClasses(context));
          i = i+1;
          break;

        }
        else if(currentClass.endOfClass < now && nextClass.startOfClass > now){
          // óra után
          listItems.insert(i+1, ScheduleEventWidget.breakTime(context));
          i = i+1;
          break;

        }
      }
    }
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index){
        Widget c = listItems[index];
        if(index >= listItems.length-1){
          return addScrollSpace(c);
        }
        return c;
    });
  }
}


