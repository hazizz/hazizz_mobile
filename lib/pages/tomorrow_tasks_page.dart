import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/tasks_tomorrow_bloc.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:sticky_header_list/sticky_header_list.dart';

import 'package:sticky_headers/sticky_headers.dart';

import '../hazizz_localizations.dart';
import '../main.dart';



class TasksTomorrowPage extends StatefulWidget {

  TomorrowTasksBloc tasksBloc = TomorrowTasksBloc();

  List<PojoTask> tasksTomorrow;

  TasksTomorrowPage({Key key, this.tasksTomorrow}) : super(key: key){
    if(tasksTomorrow != null){
      tasksBloc.dispatch(TasksTomorrowLoadedEvent(items: tasksTomorrow));
    }else if(tasksForTomorrow != null){
      tasksBloc.dispatch(TasksTomorrowLoadedEvent(items: tasksTomorrow));
    }else{
      tasksBloc.dispatch(TasksTomorrowFetchEvent());
    }
  }

  getTitleName(BuildContext context){
    return locText(context, key: "title_tasks_tomorrow");
  }

  @override
  _TasksTomorrowPage createState() => _TasksTomorrowPage();
}

class _TasksTomorrowPage extends State<TasksTomorrowPage> with SingleTickerProviderStateMixin , AutomaticKeepAliveClientMixin {


  _TasksTomorrowPage(){

  }

  @override
  void initState() {
    // getData();
    print("created tasks PAge");

    if(widget.tasksBloc.currentState is ResponseError) {
    //  widget.tasksBloc.dispatch(FetchData());
    }
    //   widget.tasksBloc.fetchMyTasks();
    super.initState();
  }

  @override
  void dispose() {
    widget.tasksBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Text(widget.getTitleName(context)),
      ),
      body: new RefreshIndicator(
          child: BlocBuilder(
              bloc: widget.tasksBloc,
              //  stream: widget.tasksBloc.subject.stream,
              builder: (_, HState state) {
                if (state is TasksTomorrowLoadedState) {
                  List<PojoTask> tasks = state.items;

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



                } else if (state is TasksTomorrowInitialState) {
                  return Container();
                } else if (state is TasksTomorrowWaitingState) {
                  return Center(child: CircularProgressIndicator(),);
                }
                return Center(
                    child: Text(locText(context, key: "info_something_went_wrong")));
              }

          ),
          onRefresh: () async =>
              widget.tasksBloc.dispatch(TasksTomorrowFetchEvent()) //await getData()
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


