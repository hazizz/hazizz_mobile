import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/listItems/TaskHeaderItemWidget.dart';
import 'package:mobile/listItems/TaskItemWidget.dart';


import 'package:sticky_headers/sticky_headers.dart';

import '../../hazizz_localizations.dart';


class TasksPage extends StatefulWidget {

  MainTasksBloc tasksBloc;

  TasksPage({Key key, @required this.tasksBloc}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "tasks");
  }

  @override
  _TasksPage createState() => _TasksPage(tasksBloc);
}

class _TasksPage extends State<TasksPage> with SingleTickerProviderStateMixin {

  final MainTasksBloc tasksBloc;

  _TasksPage(this.tasksBloc){

  }


  //List<PojoTask> task_data = List();

  // lényegében egy onCreate
  @override
  void initState() {
    // getData();
    if(tasksBloc.currentState is ResponseError) {
      tasksBloc.dispatch(FetchData());
    }
    //   tasksBloc.fetchMyTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new RefreshIndicator(
          child: BlocBuilder(
              bloc: tasksBloc,
              //  stream: tasksBloc.subject.stream,
              builder: (_, HState state) {
                if (state is ResponseDataLoaded) {
                  List<PojoTask> tasks = state.data;
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
              tasksBloc.dispatch(FetchData()) //await getData()
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
}


