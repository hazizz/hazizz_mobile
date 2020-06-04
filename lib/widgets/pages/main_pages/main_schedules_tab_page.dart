import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/schedule_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/widgets/ad_widget.dart';
import 'package:mobile/widgets/listItems/class_item_widget.dart';
import 'package:mobile/widgets/schedule_event_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';
import 'package:mobile/extension_methods/time_of_day_extension.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class SchedulesTabPage extends StatefulWidget {
  final List<PojoClass> classes;

  final bool noClasses;
  final bool isToday;

  final int dayIndex;

  SchedulesTabPage({Key key, @required this.classes, this.isToday = false, this.dayIndex})
    : assert(classes != null),
      noClasses = false,
      super(key: key);

  SchedulesTabPage.noClasses({Key key,this.isToday = false, this.dayIndex})
    : classes = null, noClasses = true,
      super(key: key);

  @override
  _SchedulesTabPage createState() => _SchedulesTabPage();
}

class _SchedulesTabPage extends State<SchedulesTabPage> with TickerProviderStateMixin {

  int elekTapCount = 0;

  TimeOfDay now = TimeOfDay.now();


  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionListener = ItemPositionsListener.create();

  int currentEventIndex = 0;

  void updateTime(){
    setState(() {
      now = TimeOfDay.now();
    });
  }

  void updateEveryMinute(){
    Timer(1.minutes, () {
      if(this.mounted) {
        updateTime();
        updateEveryMinute();
      }
    });
  }

  void scrollTo({int index}){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(index != null) currentEventIndex = index;
      print("scrolling to index $currentEventIndex");
      itemScrollController?.scrollTo(
        index: currentEventIndex,
        duration: 600.milliseconds,
        curve: Curves.easeInOutCubic
      );
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mounted){
        setState(() {
          updateEveryMinute();
        });
      }
      scrollTo();
    });
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
          Positioned(
            left: MediaQuery.of(context).size.width/2 - 110,
            top: MediaQuery.of(context).size.height/5,
            child: Container(
             // color: Colors.red,
              child: Column(
                children: <Widget>[
                  Text(localize(context, key: "no_classes_today")),
                  Container(
                    height: 150,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: (){
                        elekTapCount++;
                        if(elekTapCount >= 4){
                          showToast(
                            "elek_woken_up".localize(context),
                            duration: 4.seconds,
                            animation: StyledToastAnimation.slideFromTopFade,
                            reverseAnimation: StyledToastAnimation.slideToBottomFade,
                          );
                          elekTapCount = 0;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SvgPicture.asset(
                          "assets/images/elek_sleep.svg",
                          fit: BoxFit.scaleDown,
                          height: 120,
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Builder(
            builder: (context){
              if(MainTabBlocs().schedulesBloc.currentDayIndex >= 5) {
                return Positioned(
                  right: 0, bottom: 10,
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                            localize(context, key: "next_week").toLowerCase()),
                        Icon(FontAwesomeIcons.chevronRight)
                      ],
                    ),
                    onPressed: () {
                      MainTabBlocs().schedulesBloc.add(
                        ScheduleFetchEvent(
                          yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber,
                          weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber + 1
                      ));
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

    HazizzLogger.printLog("bojj: " + widget.classes.toString());


    List<Widget> listItems = [];

    if(widget.classes != null){
      for(PojoClass c in widget.classes){
        listItems.add(ClassItemWidget(pojoClass: c));
      }
    }

    if(widget.isToday){
      /// megnézi az időt
      for(int i = 0; i < widget.classes.length; i++){

        PojoClass previousClass = i-1 >= 0 ? widget.classes[i-1]:  null;
        PojoClass currentClass = widget.classes[i];
        PojoClass nextClass = i+1 <= widget.classes.length-1 ? widget.classes[i+1]: null;

        if(currentClass.startOfClass <= now && currentClass.endOfClass > now){
          /// megy az óra

          listItems[i] = ClassItemWidget.isCurrentEvent(pojoClass: widget.classes[i],);
          scrollTo(index: i);
        }
        else if(currentClass.startOfClass > now && previousClass == null){
          /// óra elött, nem kezdödött el a suli
          listItems.insert(0, ScheduleEventWidget.beforeClasses(context, currentClass.startOfClass));
          i = 0;//i-1;
          scrollTo(index: i);
          break;
        }

        else if(currentClass.startOfClass > now && previousClass.endOfClass < now){
          /// óra elött
          listItems.insert(i-1, ScheduleEventWidget.breakTime(context, currentClass.startOfClass));
          i = i-1;
          scrollTo(index: i);
          break;
        }
        else if(currentClass.endOfClass < now && nextClass == null){
          /// óra után, sulinak vége
          listItems.insert(i+1,ScheduleEventWidget.afterClasses(context));
          i = i+1;
          scrollTo(index: i);
          break;
        }
        else if(currentClass.endOfClass < now && nextClass.startOfClass > now){
          /// óra után
          listItems.insert(i+1, ScheduleEventWidget.breakTime(context, nextClass.startOfClass));
          i = i+1;
          scrollTo(index: i);
          break;
        }
      }
    }
    int itemCount = listItems.length+1;
    return ScrollablePositionedList.separated(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionListener,
      itemCount: itemCount,
      separatorBuilder: (context, index){
        return Container();
      },
      itemBuilder: (context, index){
        if(index == itemCount-1){
          return addScrollSpace(showAd(context, show: widget.dayIndex % 2  == 0),
              space: widget.isToday ? (currentEventIndex+1) * 46.0 : 70
          );
        }
        return listItems[index];
    });
  }
}


