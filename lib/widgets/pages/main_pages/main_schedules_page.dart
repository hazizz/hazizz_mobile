import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/kreta/schedule_bloc.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/services/selected_session_helper.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/widgets/pages/kreta_pages/kreta_service_holder.dart';
import 'package:mobile/widgets/selected_session_fail_widget.dart';
import 'package:mobile/widgets/tab_widget.dart';
import 'main_schedules_tab_page.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class SchedulesPage extends TabWidget {

  SchedulesPage({Key key}) : super(key: key, tabName: "SchedulesTab");

  getUIName(BuildContext context){
    return localize(context, key: "schedule").toUpperCase();
  }

  @override
  _SchedulesPage createState() => _SchedulesPage();
}

class _SchedulesPage extends State<SchedulesPage> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {


  _SchedulesPage();

  TabController _tabController;
  int currentDayIndex;
  List<SchedulesTabPage> _tabList = [];
  List<BottomNavigationBarItem> bottomNavBarItems = [];
  bool canBuildBottomNavBar = false;

  int r = Random().nextInt(7)+1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget onLoaded(){
    void addNoClassDay(int dayIndex){
      TextDecoration d;
      if(MainTabBlocs().schedulesBloc.currentWeekNumber == MainTabBlocs().schedulesBloc.currentCurrentWeekNumber
          && MainTabBlocs().schedulesBloc.todayIndex == dayIndex
      ){
        d = TextDecoration.underline;
      }
      _tabList.add(SchedulesTabPage.noClasses(dayIndex: dayIndex));
      bottomNavBarItems.add(BottomNavigationBarItem(
        title: Container(),
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(localize(context, key: "days_m_$dayIndex"),
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w600, decoration: d /*backgroundColor: currentDayColor*/),
          ),
        ),
        activeIcon: Text(localize(context, key: "days_$dayIndex"),
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold, decoration: d /*backgroundColor: currentDayColor*/),
        ),
      ));
    }

    Map<String, List<PojoClass>> schedule = MainTabBlocs().schedulesBloc.getScheduleFromSession().classes;//pojoSchedule.classes;


    Widget body;

    DateTime now = DateTime.now();

    if(schedule.isEmpty){
      body = Center(child: Text(localize(context, key: "no_schedule_for_week")),);
    }else{

      _tabList.clear();
      bottomNavBarItems.clear();

      for(int dayIndex = 0; dayIndex <  7; dayIndex++){
        HazizzLogger.printLog("current weekday: ${now.weekday}");
        HazizzLogger.printLog("schedule.keys.toList(): ${schedule.keys.toList()}, ");
        if(!schedule.keys.toList().contains(dayIndex.toString())) {
          if(dayIndex <= 4){
            addNoClassDay(dayIndex);
          }else{
            if(now.weekday == 7 && dayIndex == 6){
              /// Saturday
              addNoClassDay((dayIndex-1));
              /// Sunday
              addNoClassDay(dayIndex);
            }else if(now.weekday == 6 && dayIndex == 5){
              addNoClassDay(dayIndex);
              if(now.weekday == 6){
                break;
              }
            }
          }
        }
        else{
          HazizzLogger.printLog("day index in iteration: $dayIndex");
          if( schedule[dayIndex.toString()].isNotEmpty) {
            String dayName = localize(context, key: "days_$dayIndex");
            String dayMName = localize(context, key: "days_m_$dayIndex");
            _tabList.add(SchedulesTabPage(
              classes: schedule[dayIndex.toString()],
              isToday: MainTabBlocs().schedulesBloc.todayIndex == dayIndex
                && MainTabBlocs().schedulesBloc.currentCurrentWeekNumber ==  MainTabBlocs().schedulesBloc.currentWeekNumber,
                dayIndex: dayIndex + r,
            ));
            TextDecoration d;
            if(MainTabBlocs().schedulesBloc.currentWeekNumber == MainTabBlocs().schedulesBloc.currentCurrentWeekNumber
                && MainTabBlocs().schedulesBloc.todayIndex == dayIndex
            ){
              d = TextDecoration.underline;
            }
            bottomNavBarItems.add(BottomNavigationBarItem(
              title: Container(),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: <Widget>[
                    Text(dayMName,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w600, decoration: d/*backgroundColor: currentDayColor*/),
                    ),
                  ],
                )
              ),
              activeIcon: Column(
                children: <Widget>[
                  Builder(
                    builder: (context){
                      return  Text(dayName,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold, decoration: d),
                      );

                    },
                  ),

                ],
              )
            ));
          }else{
            addNoClassDay(dayIndex);
          }
        }
      }

      HazizzLogger.printLog("_tabList.length, MainTabBlocs().schedulesBloc.todayIndex:  ${ _tabList.length}, ${MainTabBlocs().schedulesBloc.todayIndex}");

      _tabController = TabController(vsync: this, length: _tabList.length, initialIndex: MainTabBlocs().schedulesBloc.todayIndex);

      if(canBuildBottomNavBar == false) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if(this.mounted){
            setState(() {
              canBuildBottomNavBar = true;
            });
          }
        }
        );
      }

      body = Column(
        children: <Widget>[
          Expanded(child: _tabList[MainTabBlocs().schedulesBloc.currentDayIndex]),
        ],
      );
    }

    return Column(
      children: [
        Text(MainTabBlocs().schedulesBloc.lastUpdated.dateTimeToLastUpdatedFormatLocalized(context)),
        Expanded(child: body)
      ]
    );

  }

  void previousWeek(){
    MainTabBlocs().schedulesBloc.add(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber-1));
  }
  
  ScheduleState lastState = ScheduleInitialState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          BlocBuilder(
            bloc: MainTabBlocs().schedulesBloc,
            builder: (context, state){
              HazizzLogger.printLog("juhééé: " + state.toString());
              if(state is ScheduleLoadedState){
                if(doesContainSelectedSession(state.failedSessions)){
                  return SelectedSessionFailWidget();
                }
              }
              else if(state is ScheduleLoadedCacheState){
                if(doesContainSelectedSession(state.failedSessions)){
                  return SelectedSessionFailWidget();
                }
              }

              if(state is ScheduleWaitingState || state is ScheduleLoadedCacheState){
                return LinearProgressIndicator(value: null,);
              }
              return Container();
            },
          ),
          Expanded(
            child: KretaServiceHolder(
              child: BlocBuilder(
                  bloc: MainTabBlocs().schedulesBloc,
                  builder: (context, state){
                    return GestureDetector (
                      onTap: () { /* do nothing*/ },
                      child: RefreshIndicator(
                        onRefresh: () async{
                          MainTabBlocs().schedulesBloc.add(ScheduleFetchEvent());
                        }, 
                        child: Stack(
                          children: <Widget>[
                            ListView(),
                            Column(
                              children: <Widget>[
                                Card(
                                  child: BlocBuilder(
                                    bloc: MainTabBlocs().schedulesBloc,
                                    builder: (_, state){
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(FontAwesomeIcons.chevronLeft),
                                            onPressed: (){
                                              MainTabBlocs().schedulesBloc.previousWeek();
                                            },
                                          ),

                                          Column(
                                            children: <Widget>[
                                              Builder(
                                                builder: (context){
                                                  if(MainTabBlocs().schedulesBloc.selectedWeekIsCurrent){
                                                    return Text(localize(context, key: "current_week"), style: TextStyle(fontSize: 16),);
                                                  }else if(MainTabBlocs().schedulesBloc.selectedWeekIsPrevious){
                                                    return Text(localize(context, key: "previous_week"), style: TextStyle(fontSize: 16));
                                                  }
                                                  else if(MainTabBlocs().schedulesBloc.selectedWeekIsNext){
                                                    return Text(localize(context, key: "next_week"), style: TextStyle(fontSize: 16));
                                                  }
                                                  return Container();
                                                },
                                              ),
                                              Text("${MainTabBlocs().schedulesBloc.currentWeekMonday.dateTimeToMonthDay} - ${MainTabBlocs().schedulesBloc.currentWeekSunday.dateTimeToMonthDay}", style: TextStyle(fontSize: 18),),
                                            ],
                                          ),

                                          //  Text("${weekStart.day}-${weekEnd.day}"),
                                          IconButton(
                                            icon: Icon(FontAwesomeIcons.chevronRight),
                                            onPressed: (){
                                              MainTabBlocs().schedulesBloc.nextWeek();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                ),
                                Expanded(
                                  child: BlocBuilder(
                                      bloc:  MainTabBlocs().schedulesBloc,
                                      condition: (ScheduleState beforeState, ScheduleState state){
                                        if(beforeState is ScheduleLoadedState && state is ScheduleLoadedState){
                                          //return false;
                                        }
                                        return true;
                                      },
                                      builder: (_, ScheduleState state) {

                                        HazizzLogger.printLog("ScheduleState: ${state}");
                                        if (state is ScheduleWaitingState || (state is ScheduleLoadedCacheState && lastState is ScheduleWaitingState)) {
                                          //return Center(child: Text("Loading Data"));
                                          return Center(child: CircularProgressIndicator(),);
                                        }
                                        lastState = state;

                                        if (state is ScheduleLoadedState) {
                                          if(MainTabBlocs().schedulesBloc.classes?.classes != null/*state.schedules != null && state.data.isNotEmpty()*/){
                                            if (doesContainSelectedSession(state.failedSessions)) {
                                              return Container();
                                            }
                                            return onLoaded();
                                          }
                                        }else if (state is ScheduleLoadedCacheState) {
                                          if(MainTabBlocs().schedulesBloc.classes?.classes != null/*state.data != null && state.data.isNotEmpty()*/){
                                            if (doesContainSelectedSession(state.failedSessions)) {
                                              return Container();
                                            }
                                            return onLoaded();

                                          }
                                        }
                                        else if (state is ResponseEmpty) {
                                          return Column(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 50.0),
                                                  child:  AutoSizeText(
                                                    localize(context, key: "no_schedule"),
                                                    style: TextStyle(fontSize: 17),
                                                    textAlign: TextAlign.center,
                                                    maxFontSize: 17,
                                                    minFontSize: 14,
                                                  ),
                                                ),
                                              )
                                            ]
                                          );
                                        }else if(state is ScheduleErrorState ){
                                          if(state.hazizzResponse.pojoError != null && state.hazizzResponse.pojoError.errorCode == 138){
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              showKretaUnavailableFlushBar(context);
                                            });
                                          }
                                          else if(state.hazizzResponse.dioError == noConnectionError){

                                          }else{
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              Flushbar(
                                                icon: Icon(FontAwesomeIcons.exclamation, color: Colors.red,),

                                                message: "${localize(context, key: "schedule")}: ${localize(context, key: "info_something_went_wrong")}",
                                                duration: 3.seconds,
                                              );
                                            });
                                          }

                                          if(MainTabBlocs().schedulesBloc.classes != null){
                                            return onLoaded();
                                          }
                                          return Center(
                                              child: Text(localize(context, key: "info_something_went_wrong")));
                                        }
                                        return Center(child: Text(localize(context, key: "info_something_went_wrong")),);
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              )
            ),
          )
        ],
      ),
      bottomNavigationBar: Builder(
        builder: (context){
          if(canBuildBottomNavBar){
            return Container(
              color: Theme.of(context).primaryColorDark,
              child: BottomNavigationBar(
                currentIndex: MainTabBlocs().schedulesBloc.currentDayIndex,
                onTap: (int index){
                  setState(() {
                    MainTabBlocs().schedulesBloc.currentDayIndex = index;
                    HazizzLogger.printLog("currentDayIndex: ${MainTabBlocs().schedulesBloc.currentDayIndex}");
                    _tabController.animateTo(index);
                    HazizzLogger.printLog("_tabController.index: ${_tabController.index}");
                  });
                },
                items: bottomNavBarItems
              )
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}



