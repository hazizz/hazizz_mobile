import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/tasks/tasks_tomorrow_bloc.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';


import 'package:sticky_headers/sticky_headers.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

import '../../main.dart';


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

  @override
  void initState() {
    // getData();
    HazizzLogger.printLog("in tomorrow task page");

    if(widget.tasksBloc.currentState is ResponseError) {
    //  widget.tasksBloc.add(FetchData());
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

                  int i = 0;
                  for(PojoTask task in tasks){
                    int d = tasks[i].dueDate
                        .difference(DateTime.now())
                        .inDays;
                    if (d == 1) {
                      map[tasks[i].dueDate] = List();
                      map[tasks[i].dueDate].add(task);
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
                              content: TaskItemWidget(originalPojoTask: tasks[index],),
                            );
                          } else {
                            return TaskItemWidget(originalPojoTask: tasks[index],
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


