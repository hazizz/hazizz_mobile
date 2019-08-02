import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/listItems/schedule_event_widget.dart';

import '../../hazizz_localizations.dart';
import 'main_schedules_tab_page.dart';

class SchedulesPage extends StatefulWidget {


  SchedulesPage({Key key}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "schedule");
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

    print("created schedules PAge");


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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          print("log: refreshing: schedulesBloc");
          MainTabBlocs().schedulesBloc.dispatch(FetchData());
        },
      child: Scaffold(
          body: new RefreshIndicator(
              child: Stack(
                children: <Widget>[
                  ListView(),
                  BlocBuilder(
                      bloc:  MainTabBlocs().schedulesBloc,
                      builder: (_, HState state) {
                        print("schedule state: $state");
                        if (state is ResponseDataLoaded) {
                          Map<String, List<PojoClass>> schedule = state.data.classes;

                          _tabList.clear();
                          bottomNavBarItems.clear();
                          int i = 0;
                          for(String dayIndex in schedule.keys){
                            i++;
                            if( schedule[dayIndex].isNotEmpty) {
                              Color currentDayColor;
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
                                    style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: "Montserrat", backgroundColor: currentDayColor),
                                  ),
                                ),
                                activeIcon: Text(dayName,
                                  style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold, backgroundColor: currentDayColor),
                                ),
                              ));
                            }
                          }
                          _tabController = TabController(vsync: this, length: _tabList.length);

                          if(canBuildBottomNavBar == false) {
                            SchedulerBinding.instance.addPostFrameCallback((_) =>
                              setState(() {
                                canBuildBottomNavBar = true;
                              })
                            );
                          }

                          return Stack(
                            children: [
                              TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: _tabList,
                              ),
                              Positioned(
                                bottom: 0,
                                child:
                                Container( width: MediaQuery.of(context).size.width,child: ScheduleEventWidget()),
                              )
                            ]
                          );
                        } else if (state is ResponseEmpty) {
                          return Center(child: Text("Empty"));
                        } else if (state is ResponseWaiting) {
                          //return Center(child: Text("Loading Data"));
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return Row(
                            children: [Expanded(child: Text("Uchecked State: ${state.toString()}"))]);
                      }
                  ),
                ],
              ),
              onRefresh: () async {
                print("log: refreshing: schedulesBloc");
                MainTabBlocs().schedulesBloc.dispatch(FetchData());
              }
          ),
          bottomNavigationBar: BlocBuilder(
            bloc:  MainTabBlocs().schedulesBloc,
            builder: (_, HState state) {

              if (state is ResponseDataLoaded) {
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
                }else{
                  return Container();
                }
              }else{
                return Container();
              }
            }
          ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



