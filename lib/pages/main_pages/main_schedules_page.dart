import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/listItems/schedule_event_widget.dart';
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
              style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: "Montserrat", /*backgroundColor: currentDayColor*/),
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



    return Column(
        children: [
          Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().schedulesBloc.lastUpdated)),
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

          // Container( width: MediaQuery.of(context).size.width,child: ScheduleEventWidget()),

        ]
    );

  }

  @override
  Widget build(BuildContext context) {
    return KretaServiceHolder(
        child: BlocBuilder(
          bloc: MainTabBlocs().schedulesBloc,
          builder: (context, state){
            return RefreshIndicator(
              onRefresh: () async{
                MainTabBlocs().schedulesBloc.dispatch(FetchData());

              },
              child: Stack(
                  children: <Widget>[
                    ListView(),
                    BlocBuilder(
                        bloc:  MainTabBlocs().schedulesBloc,
                        builder: (_, HState state) {

                          if (state is ResponseDataLoaded) {
                            return onLoaded(state.data);
                          }else if (state is ResponseDataLoadedFromCache) {
                            return onLoaded(state.data);
                          }
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
                          } else if (state is ResponseWaiting) {
                            //return Center(child: Text("Loading Data"));
                            return Center(child: CircularProgressIndicator(),);
                          }else if(state is ResponseError ){
                            if(state.errorResponse.pojoError != null && state.errorResponse.pojoError.errorCode == 138){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Toast.show(locText(context, key: "kreta_server_unavailable"), context, duration: 4, gravity:  Toast.BOTTOM);
                              });
                            }
                            else if(state.errorResponse.dioError == noConnectionError){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Toast.show(locText(context, key: "info_noInternetAccess"), context, duration: 4, gravity:  Toast.BOTTOM);
                              });
                            }else{
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Toast.show(locText(context, key: "info_something_went_wrong"), context, duration: 4, gravity:  Toast.BOTTOM);
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
                  ],
                ),
            );
          }
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



