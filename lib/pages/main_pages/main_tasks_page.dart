import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:sticky_header_list/sticky_header_list.dart';

import 'package:sticky_headers/sticky_headers.dart';

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



    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        ['featureId1'],
      );
    });


    super.initState();
  }

  @override
  void dispose() {
   // tasksBloc.dispose();
    super.dispose();
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

                      Map<DateTime, List<PojoTask>> map = Map();

                      int count = 0;

                      int i = 0;
                      for(PojoTask task in tasks){
                        if (i == 0 || tasks[i].dueDate
                            .difference(tasks[i - 1].dueDate)
                            .inDays > 0) {
                          map[tasks[i].dueDate] = List();
                          map[tasks[i].dueDate].add(task);

                          count +=2;
                        }else{
                          map[tasks[i].dueDate].add(task);
                          count++;
                        }

                        i++;
                      }

                      return new ListView.builder(
                          itemCount: map.keys.length,
                          itemBuilder: (BuildContext context, int index) {

                            DateTime key = map.keys.elementAt(index);

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
                      );


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
                    }
                    return Center(
                        child: Text("Uchecked State: ${state.toString()}"));
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
      floatingActionButton:
        DescribedFeatureOverlay(
          child: FloatingActionButton(
           // heroTag: "hero_fab_tasks_main",
            onPressed: (){

              Navigator.pushNamed(context, "/createTask");
           //   Navigator.push(context,MaterialPageRoute(builder: (context) => EditTaskPage.createMode()));
            },
            tooltip: 'Increment',
            child: Icon(FontAwesomeIcons.plus),
          ),
          featureId: 'featureId1',
          icon: FontAwesomeIcons.plus,
          color: HazizzTheme.purple,
          contentLocation: ContentOrientation.above, // look at note
          title: 'Just how you want it',
          description: 'Tap the menu icon to switch account, change s'
        ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


