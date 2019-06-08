import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hazizz_mobile/blocs/group_bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/blocs/tasks_bloc.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/listItems/TaskHeaderItemWidget.dart';
import 'package:hazizz_mobile/listItems/TaskItemWidget.dart';

import 'package:sticky_headers/sticky_headers.dart';

class GroupTasksPage extends StatefulWidget {
  // This widget is the root of your application.

  static final String tabName = "Tasks";

  GroupTasksBloc groupTasksBloc;

  GroupTasksPage({Key key, @required this.groupTasksBloc}) : super(key: key);

  @override
  _GroupTasksPage createState() => _GroupTasksPage(groupTasksBloc);
}

class _GroupTasksPage extends State<GroupTasksPage> with AutomaticKeepAliveClientMixin {

  GroupTasksBloc groupTasksBloc;

  _GroupTasksPage(this.groupTasksBloc);

  @override
  void initState() {
    groupTasksBloc.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: null, child: Icon(Icons.add),),
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: groupTasksBloc,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    List<PojoTask> tasks = state.data;
                    return new ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0 ||
                              tasks[index].dueDate.difference(tasks[index - 1].dueDate).inDays > 0) {
                            return new StickyHeader(
                              header: TaskHeaderItemWidget(dateTime: tasks[index].dueDate),
                              content: TaskItemWidget(pojoTask: tasks[index],),
                            );
                          } else {
                            return
                              TaskItemWidget(pojoTask: tasks[index],
                              );
                          }
                        }
                    );
                  } else if (state is ResponseEmpty) {
                      return Center(child: Text("Empty"));
                  } else if (state is ResponseWaiting) {
                      return Center(child: CircularProgressIndicator(),);
                  }
                  return Center(
                      child: Text("Uchecked State: ${state.toString()}"));
                }

            ),
            onRefresh: () async => groupTasksBloc.dispatch(FetchData()) //await getData()
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


