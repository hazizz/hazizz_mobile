import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:mobile/managers/welcome_manager.dart';
import 'package:sticky_header_list/sticky_header_list.dart';

import 'package:sticky_headers/sticky_headers.dart';
import 'package:toast/toast.dart';

import '../../hazizz_localizations.dart';
import '../../hazizz_theme.dart';

class TasksPage extends StatefulWidget {

 // MainTasksBloc tasksBloc;

  TasksPage({Key key}) : super(key: key);

  String getTabName(BuildContext context){
    return locText(context, key: "tasks").toUpperCase();
  }

  @override
  _TasksPage createState() => _TasksPage();
}

class _TasksPage extends State<TasksPage> with SingleTickerProviderStateMixin , AutomaticKeepAliveClientMixin {

 // MainTasksBloc tasksBloc;

  @override
  void initState() {
    // getData();
   // tasksBloc = widget.tasksBloc;
    print("created tasks PAge");

    /*
    if(tasksBloc.currentState is ResponseError) {
      tasksBloc.dispatch(FetchData());
    }
    */
    //   tasksBloc.fetchMyTasks();

    /*
    WelcomeManager.getMainTasks().then((isNewComer){
      if(isNewComer){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            ['discover_task_create'],
          );
        });
      }
    });
    */


    super.initState();
  }

  @override
  void dispose() {
   // tasksBloc.dispose();
    super.dispose();
  }

  Widget onLoaded(List<PojoTask> tasks){
    Map<DateTime, List<PojoTask>> map = Map();


    int i = 0;
    for(PojoTask task in tasks){
      if (i == 0 || tasks[i].dueDate
          .difference(tasks[i - 1].dueDate)
          .inDays >= 1) {
        map[tasks[i].dueDate] = List();
        map[tasks[i].dueDate].add(task);

      }else{
        map[tasks[i].dueDate].add(task);
      }

      i++;
    }

    return new Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: map.keys.length+1,
              itemBuilder: (BuildContext context, int index) {

                if(index == 0){
                  return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated)));
                }

                DateTime key = map.keys.elementAt(index-1);


                return StickyHeader(
                  header: TaskHeaderItemWidget(dateTime: key),
                  content: Builder(
                      builder: (context) {
                        List<Widget> tasksList = new List();
                        int index2 = 0;
                        for(PojoTask pojoTask in map[key]){
                          index2++;
                          tasksList.add(
                              TaskItemWidget(pojoTask: pojoTask,)
                          );

                        }
                        return Column(
                            children: tasksList
                        );
                      }
                  ),
                );
              }
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new RefreshIndicator(

          child: Stack(
            children: <Widget>[
              ListView(),
              BlocBuilder(
                  bloc: MainTabBlocs().tasksBloc,
                  //  stream: tasksBloc.subject.stream,
                  builder: (_, HState state) {
                    if (state is ResponseDataLoaded) {
                      List<PojoTask> tasks = state.data;

                      return onLoaded(tasks);

                    }if (state is ResponseDataLoadedFromCache) {
                      List<PojoTask> tasks = state.data;

                      return onLoaded(tasks);

                    } else if (state is ResponseEmpty) {
                      return Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Text(locText(context, key: "no_tasks_yet")),
                              ),
                            )
                          ]
                      );
                    } else if (state is ResponseWaiting) {
                      //return Center(child: Text("Loading Data"));
                      return Center(child: CircularProgressIndicator(),);
                    }else if (state is ResponseError) {
                      //return Center(child: Text("Loading Data"));
                      if(state.errorResponse.dioError == noConnectionError){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Toast.show(locText(context, key: "info_noInternetAccess"), context, duration: 4, gravity:  Toast.BOTTOM);
                        });
                      }else{
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Toast.show(locText(context, key: "info_something_went_wrong"), context, duration: 4, gravity:  Toast.BOTTOM);
                        });
                      }

                      if(MainTabBlocs().tasksBloc.tasks!= null){
                        return onLoaded(MainTabBlocs().tasksBloc.tasks);
                      }
                      return Center(
                          child: Text(locText(context, key: "info_something_went_wrong")));
                    }
                    return Center(
                        child: Text(locText(context, key: "info_something_went_wrong")));
                  }

              ),

            ],
          ),
          onRefresh: () async{
            MainTabBlocs().tasksBloc.dispatch(FetchData()); //await getData()
            print("log: refreshing tasks");
            return;
          }
      ),
      floatingActionButton:FloatingActionButton(
        // heroTag: "hero_fab_tasks_main",
        onPressed: (){

          Navigator.pushNamed(context, "/createTask");
          //   Navigator.push(context,MaterialPageRoute(builder: (context) => EditTaskPage.createMode()));
        },
        tooltip: 'Increment',
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


