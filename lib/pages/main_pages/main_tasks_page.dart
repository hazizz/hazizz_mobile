import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:sticky_header_list/sticky_header_list.dart';

import 'package:sticky_headers/sticky_headers.dart';

import '../../hazizz_localizations.dart';

class TasksPage extends StatefulWidget {

 // MainTasksBloc tasksBloc;

  TasksPage({Key key}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "tasks");
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


                                        /*Stack(
Slidable(),
Container(color: Colors.transparent, width: MediaQuery.of(context).size.width * 0.027),
)*/

/*
                                        Slidable(

                                          child: TaskItemWidget(pojoTask: pojoTask,),
                                          actionPane: SlidableDrawerActionPane(),
                                          actions: <Widget>[
                                            IconSlideAction(
                                              caption: 'Archive',
                                              color: Colors.blue,
                                              icon: Icons.archive,
                                            ),
                                            IconSlideAction(
                                              caption: 'Share',
                                              color: Colors.indigo,
                                              icon: Icons.share,
                                            ),
                                          ],
                                        )
                                        */





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


                      return new ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0 || tasks[index].dueDate
                                .difference(tasks[index - 1].dueDate)
                                .inDays > 0) {
                              return new StickyHeader(
                                header: TaskHeaderItemWidget(
                                    dateTime: tasks[index].dueDate),
                                content: TaskItemWidget(pojoTask: tasks[index],),
                              );
                            } else {
                              return TaskItemWidget(pojoTask: tasks[index],
                              );
                            }
                          }
                      );


                      return new StickyList.builder(
                          itemCount: tasks.length,
                          builder: (BuildContext context, int index) {
                            if (index == 0 || tasks[index].dueDate
                                .difference(tasks[index - 1].dueDate)
                                .inDays > 0) {
                              return new HeaderRow(
                                  child: Column(
                                      children: [
                                        TaskHeaderItemWidget(dateTime: tasks[index].dueDate),
                                        TaskItemWidget(pojoTask: tasks[index])
                                      ]
                                  ));
                            } else {
                              return RegularRow(child: TaskItemWidget(pojoTask: tasks[index]),
                              );
                            }
                          }
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

            ],
          ),
          onRefresh: () async{
            MainTabBlocs().tasksBloc.dispatch(FetchData()); //await getData()
            print("log: refreshing tasks");
            return;
          }
      ),
      floatingActionButton:
      FloatingActionButton(
        heroTag: "hero_task_edit",
        onPressed: (){

          Navigator.pushNamed(context, "/createTask");
       //   Navigator.push(context,MaterialPageRoute(builder: (context) => EditTaskPage.createMode()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


