import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';

import '../../hazizz_localizations.dart';
import 'main_schedules_tab_page.dart';

class SchedulesPage extends StatefulWidget {

  MainSchedulesBloc schedulesBloc;

  SchedulesPage({Key key, this.schedulesBloc}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "schedule");
  }

  @override
  _SchedulesPage createState() => _SchedulesPage(schedulesBloc);
}

class _SchedulesPage extends State<SchedulesPage> with TickerProviderStateMixin {

  final MainSchedulesBloc schedulesBloc;

  _SchedulesPage(this.schedulesBloc){}

  TabController _tabController;
  int _currentIndex = 0;

  List<SchedulesTabPage> _tabList = [];

  List<BottomNavigationBarItem> bottomNavBarItems = [];

  bool canBuildBottomNavBar = false;

  @override
  void initState() {
    // getData();
   // schedulesBloc.dispatch(FetchData());
    //   schedulesBloc.fetchMyTasks();
    if(schedulesBloc.currentState is ResponseError) {
      print("log: here233");
      schedulesBloc.dispatch(FetchData());
    }


    _currentIndex = DateTime.now().weekday-1;
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: schedulesBloc,
                builder: (_, HState state) {
                  print("schedule state: $state");
                  if (state is ResponseDataLoaded) {
                    Map<String, List<PojoClass>> schedule = state.data.classes;

                    _tabList.clear();
                    bottomNavBarItems.clear();

                //    print("log: days array:  ${locTextFromList(context, key: "days_${2}")}");
                    
                    for(String dayIndex in schedule.keys){
                      if( schedule[dayIndex].isNotEmpty) {
                        String dayName = locText(context, key: "days_$dayIndex");
                        _tabList.add(SchedulesTabPage(classes: schedule[dayIndex]));
                        bottomNavBarItems.add(BottomNavigationBarItem(
                            title: Container(),
                            icon: Text(dayName[0].toUpperCase(),
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            ),
                            activeIcon: Text(dayName,
                              style: TextStyle(color: Colors.red, fontSize: 28),
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


                    return TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: _tabList,
                    );



                  } else if (state is ResponseEmpty) {
                    return Center(child: Text("Empty"));
                  } else if (state is ResponseWaiting) {
                    //return Center(child: Text("Loading Data"));
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Center(
                      child: Text("Uchecked State: ${state.toString()}"));
                }
            ),
            onRefresh: () async =>
                schedulesBloc.dispatch(FetchData()) //await getData()
        ),
        bottomNavigationBar: BlocBuilder(
          bloc: schedulesBloc,
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
    );
  }
}



