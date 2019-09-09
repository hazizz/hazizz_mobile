import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/schedule_bloc.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/listItems/schedule_event_widget.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:toast/toast.dart';

import '../../hazizz_localizations.dart';
import '../../logger.dart';
import '../kreta_service_holder.dart';
import 'main_schedules_tab_page.dart';

class SchedulesPage extends StatefulWidget {


  SchedulesPage({Key key}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "schedule").toUpperCase();
  }

  @override
  _SchedulesPage createState() => _SchedulesPage();
}

class _SchedulesPage extends State<SchedulesPage> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {


  _SchedulesPage(){}

  TabController _tabController;
  int _currentIndex;

  int currentDayIndex;

  List<SchedulesTabPage> _tabList = [];

  List<BottomNavigationBarItem> bottomNavBarItems = [];

  bool canBuildBottomNavBar = false;

  @override
  void initState() {
    currentDayIndex = MainTabBlocs().schedulesBloc.currentDayIndex;
    _currentIndex = currentDayIndex;

    /*
    if(schedulesBloc.currentState is ResponseError) {
      print("log: here233");
      schedulesBloc.dispatch(FetchData());
    }
    */

    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }


  Widget onLoaded(PojoSchedules pojoSchedule){

    Map<String, List<PojoClass>> schedule = pojoSchedule.classes;

    Widget body;

    DateTime now = DateTime.now();

    DateTime weekStart = DateTime(now.year, now.month, now.day - now.weekday+1);

    DateTime weekEnd = DateTime(now.year, now.month, now.day + 7 - now.weekday);

    if(schedule.isEmpty){
      body = Center(child: Text(locText(context, key: "no_schedule_for_week")),);
    }else{
      if(_currentIndex > schedule.length-1){
        _currentIndex = schedule.length-1;
      }

      _tabList.clear();
      bottomNavBarItems.clear();
      int i = 0;
      for(String dayIndex in schedule.keys){
        i++;
        if( schedule[dayIndex].isNotEmpty) {
          Color currentDayColor = Colors.transparent;
          if(i == currentDayIndex ){
            currentDayColor = Colors.blue;
          }

          String dayName = locText(context, key: "days_$dayIndex");
          String dayMName = locText(context, key: "days_m_$dayIndex");
          _tabList.add(SchedulesTabPage(classes: schedule[dayIndex]));
          bottomNavBarItems.add(BottomNavigationBarItem(

            title: Container(),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(dayMName,
                style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w600, /*backgroundColor: currentDayColor*/),
              ),
            ),
            activeIcon: Text(dayName,
              style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold, /*backgroundColor: currentDayColor*/),
            ),
          ));
        }
      }
      _tabController = TabController(vsync: this, length: _tabList.length);

      if(canBuildBottomNavBar == false) {
        SchedulerBinding.instance.addPostFrameCallback((_) =>
            setState(() {
              if(this.mounted){
                canBuildBottomNavBar = true;
              }
            })
        );
      }

      // now.weekday



      body =
          Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: _tabList,
                ),
              ),

              Builder(
                builder: (context){
                  if(canBuildBottomNavBar){
                    return Container(
                        color: Theme.of(context).primaryColorDark,
                        child: BottomNavigationBar(
                          currentIndex: _currentIndex,
                          onTap: (int index){
                            setState(() {
                              _currentIndex = index;
                            });
                            _tabController.animateTo(index);
                          },
                          items: bottomNavBarItems
                        )
                    );
                  }
                  return Container();
                },
              )
            ],
          );
    }





    return Column(
        children: [
          /*
          Container(
            height: 100,
            child: DropdownMenu(
              menus: [
                Text("asd")
              ],
            ),
          ),
          */
          /*
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: ExpandablePanel(
                tapHeaderToExpand: true,
                collapsed: Container(
                  width: MediaQuery.of(context).size.width,

                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(FontAwesomeIcons.chevronLeft),
                          onPressed: (){
                            MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber-1));
                          },
                        ),
                        Text(MainTabBlocs().schedulesBloc.currentWeekNumber.toString()),

                      //  Text("${weekStart.day}-${weekEnd.day}"),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.chevronRight),
                          onPressed: (){
                            MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber+1));
                          },
                        ),
                      ],
                    )
                  ),
                ),
                expanded: Card(
                  child: Column(
                    children: <Widget>[
                      Text("date"),
                      Text("date"),
                      Text("date"),
                    ],
                  )
                ),
              ),
            ),
          ),
          */
          Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().schedulesBloc.lastUpdated)),
        //  Expanded(child: body),
          Expanded(child: body)

          // Container( width: MediaQuery.of(context).size.width,child: ScheduleEventWidget()),

        ]
    );

  }

  void previousWeek(){
    setState(() {

    });
    MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber-1));

  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,

        body: KretaServiceHolder(
          child: BlocBuilder(
            bloc: MainTabBlocs().schedulesBloc,
            builder: (context, state){
              return RefreshIndicator(
                onRefresh: () async{
                  MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent());

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
                                        MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber-1));
                                      },
                                    ),
                                    Text("${dateTimeToMonthDay(MainTabBlocs().schedulesBloc.currentWeekMonday)} - ${dateTimeToMonthDay(MainTabBlocs().schedulesBloc.currentWeekSunday)}"),

                                    //  Text("${weekStart.day}-${weekEnd.day}"),
                                    IconButton(
                                      icon: Icon(FontAwesomeIcons.chevronRight),
                                      onPressed: (){
                                        MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent(yearNumber: MainTabBlocs().schedulesBloc.currentYearNumber, weekNumber: MainTabBlocs().schedulesBloc.currentWeekNumber+1));
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
                                builder: (_, ScheduleState state) {

                                  if (state is ScheduleLoadedState) {
                                    if(state.schedules != null /*&& state.data.isNotEmpty()*/){
                                      print("hát persze hogy eljutok1");
                                      return onLoaded(state.schedules);

                                    }
                                  }else if (state is ScheduleLoadedCacheState) {
                                    if(state.data != null /*&& state.data.isNotEmpty()*/){
                                      print("hát persze hogy eljutok2");
                                      return onLoaded(state.data);

                                    }                          }
                                  else if (state is ResponseEmpty) {
                                    return Column(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 50.0),
                                              child: Text(locText(context, key: "no_schedule")),
                                            ),
                                          )
                                        ]
                                    );
                                  } else if (state is ScheduleWaitingState) {
                                    //return Center(child: Text("Loading Data"));
                                    return Center(child: CircularProgressIndicator(),);
                                  }else if(state is ScheduleErrorState ){
                                    if(state.hazizzResponse.pojoError != null && state.hazizzResponse.pojoError.errorCode == 138){
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        showKretaUnavailableSnackBar(context, scaffoldState: scaffoldState);
                                      });
                                    }
                                    else if(state.hazizzResponse.dioError == noConnectionError){
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        showNoConnectionSnackBar(context, scaffoldState: scaffoldState);
                                      });
                                    }else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          scaffoldState.currentState.showSnackBar(SnackBar(
                                            content: Text("${locText(context, key: "schedule")}: ${locText(context, key: "info_something_went_wrong")}"),
                                            duration: Duration(seconds: 3),
                                          ));
                                        });
                                        // Toast.show(locText(context, key: "info_something_went_wrong"), context, duration: 4, gravity:  Toast.BOTTOM);
                                      });
                                    }

                                    if(MainTabBlocs().schedulesBloc.classes != null){
                                      return onLoaded(MainTabBlocs().schedulesBloc.classes);
                                    }
                                    return Center(
                                        child: Text(locText(context, key: "info_something_went_wrong")));
                                  }
                                  return Center(child: Text(locText(context, key: "info_something_went_wrong")),);

                                }
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
              );
            }
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



