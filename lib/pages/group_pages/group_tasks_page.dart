import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/tasks_bloc.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';


import 'package:sticky_headers/sticky_headers.dart';

import '../../hazizz_localizations.dart';

class GroupTasksPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTabName(BuildContext context){
    return locText(context, key: "tasks").toUpperCase();
  }

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
    if(groupTasksBloc.currentState is ResponseError) {
      groupTasksBloc.dispatch(FetchData());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  floatingActionButton: FloatingActionButton(onPressed: null, child: Icon(Icons.add),),
        floatingActionButton:FloatingActionButton(
          // heroTag: "hero_fab_tasks_main",
          onPressed: (){

            Navigator.pushNamed(context, "/createTask");
          },
          tooltip: 'Increment',
          child: Icon(FontAwesomeIcons.plus),
        ),
        body: RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    ListView(),
                    BlocBuilder(
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
                                      content: TaskItemWidget(originalPojoTask: tasks[index],),
                                    );
                                  } else {
                                    return
                                      TaskItemWidget(originalPojoTask: tasks[index],
                                      );
                                  }
                                }
                            );
                          } else if (state is ResponseEmpty) {


                            return Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Text(locText(context, key: "no_tasks_in_group_yet")),
                                    ),
                                  )
                                ]
                            );
                          } else if (state is ResponseWaiting) {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return Center(
                              child: Text(locText(context, key: "info_something_went_wrong")));
                        }
                    ),

                  ],
                ),
                onRefresh: () async => groupTasksBloc.dispatch(FetchData()) //await getData()
            ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


