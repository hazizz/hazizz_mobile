import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/task_complete_state_enum.dart';
import 'package:mobile/enums/task_expired_state_enum.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';


import 'package:sticky_headers/sticky_headers.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

class GroupTasksPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTabName(BuildContext context){
    return locText(context, key: "tasks").toUpperCase();
  }

 // GroupTasksBloc groupTasksBloc;

  GroupTasksPage({Key key,}) : super(key: key);

  @override
  _GroupTasksPage createState() => _GroupTasksPage();
}

class _GroupTasksPage extends State<GroupTasksPage> with AutomaticKeepAliveClientMixin {


  TaskCompleteState currentCompletedTaskState;

  TaskExpiredState currentExpiredTaskState;


  @override
  void initState() {
    if(GroupBlocs().groupTasksBloc.currentState is TasksErrorState) {
      GroupBlocs().groupTasksBloc.dispatch(TasksFetchEvent());
    }

    currentCompletedTaskState = GroupBlocs().groupTasksBloc.currentTaskCompleteState;
    currentExpiredTaskState = GroupBlocs().groupTasksBloc.currentTaskExpiredState;

    super.initState();
  }

  void applyFilters(){
    GroupBlocs().groupTasksBloc.currentTaskCompleteState = currentCompletedTaskState;
    GroupBlocs().groupTasksBloc.currentTaskExpiredState = currentExpiredTaskState;
  }

  Widget buildItem(BuildContext context, int index, Animation animation, PojoTask pojoTask, Function onCompletedChanged){
    Animation<Offset> a = Tween<Offset>(begin: Offset(-1, 0.0), end: Offset(0, 0)).animate(
        CurvedAnimation(
          parent: animation,
          curve: //Curves.easeOutSine

          Interval(
            0.1,
            1.0,
            curve: Curves.easeOutSine,

          ),

        )
    );
    return SlideTransition(

        position: a,
        //  axis: Axis.vertical,
        child: TaskItemWidget(originalPojoTask: pojoTask, onCompletedChanged: onCompletedChanged, key: Key(pojoTask.toJson().toString()),)
    );
  }


  Map<DateTime, List<PojoTask>> map = null;

  Widget onLoaded(Map<DateTime, List<PojoTask>> m){

    map = m;

    HazizzLogger.printLog("REBUILD, BIIP BOOp");

    return new Column(
      children: <Widget>[

        Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //  Text("Feladatok:"),

                  DropdownButton(
                    value: currentCompletedTaskState,
                    onChanged: (value){
                      setState(() {
                        currentCompletedTaskState = value;
                      });
                    },
                    items: [
                      DropdownMenuItem(child: Text(locText(context, key: "complete")), value: TaskCompleteState.COMPLETED, ),
                      DropdownMenuItem(child: Text(locText(context, key: "incomplete")), value: TaskCompleteState.UNCOMPLETED,),
                      DropdownMenuItem(child: Text(locText(context, key: "both")), value: TaskCompleteState.BOTH, ),

                    ],
                  ),
                  // Text("Feladatok:"),

                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: DropdownButton(
                      value: currentExpiredTaskState,
                      onChanged: (value){
                        setState(() {
                          currentExpiredTaskState = value;
                        });
                      },
                      items: [
                        DropdownMenuItem(child: Text(locText(context, key: "expired")), value: TaskExpiredState.EXPIRED,),
                        DropdownMenuItem(child: Text(locText(context, key: "active")), value: TaskExpiredState.UNEXPIRED,)
                      ],
                    ),
                  ),
                  Spacer(),

                  FlatButton(child: Text(locText(context, key: "apply").toUpperCase(), style: TextStyle(fontSize: 13),),
                    onPressed: (){

                      applyFilters();

                      GroupBlocs().groupTasksBloc.dispatch(TasksFetchEvent());
                    },
                  )
                ],
              ),
            )
        ),

        Expanded(
          child: Builder(builder: (context){
            if(map.keys == null || map.keys.isEmpty){
              return Center(child: Text(locText(context, key: "no_tasks")),);


            }else{

              return ListView.builder(
                //  physics: BouncingScrollPhysics(),
                  itemCount: map.keys.length+1,
                  itemBuilder: (BuildContext context, int index) {



                    if(index == 0){
                      return Center(child: Text(dateTimeToLastUpdatedFormat(context, GroupBlocs().groupTasksBloc.lastUpdated)));
                    }

                    List<GlobalKey<AnimatedListState>> listKeyList = new List(map.keys.length);
                    for(int i = 0; i < listKeyList.length; i++){
                      listKeyList[i] =  GlobalKey();
                    }


                    DateTime key = map.keys.elementAt(index-1);
                    HazizzLogger.printLog("new key: ${key.toString()}");


                    Widget s = StickyHeader(

                      //  key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                      //key: Key(Random().nextInt(2000000).toString()),
                      header: TaskHeaderItemWidget(key: Key(Random().nextInt(2000000).toString()), dateTime: key),
                      content: Builder(
                          builder: (context) {

                            return AnimatedList(
                              key: listKeyList[index-1],
                              //   key: Key(Random().nextInt(2000000).toString()),
                              shrinkWrap: true,
                              initialItemCount: map[key].length,

                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2, animation) => buildItem(context, index2, animation, map[key][index2], (){

                                HazizzLogger.printLog("bro: me: ${currentCompletedTaskState}");

                                if(currentCompletedTaskState != TaskCompleteState.BOTH){
                                  HazizzLogger.printLog("bro: im trigered");

                                  // var removedItem = map[key].removeAt(index2);
                                  var removedItem = map[key][index2];

                                  listKeyList[index-1].currentState.removeItem(index2, (context2, animation2){
                                    animation2.addStatusListener((AnimationStatus animationStatus){
                                      HazizzLogger.printLog("oof22: anim: ${animationStatus.toString()}");
                                      if(animationStatus == AnimationStatus.dismissed){
                                        HazizzLogger.printLog("oof: ${map[key]}");
                                        GroupBlocs().groupTasksBloc.dispatch(TasksRemoveItemEvent( mapKey: key, index: index2));
                                      }
                                    });
                                    return buildItem(context2, index2, animation2, removedItem, (){});
                                  },
                                      duration:  Duration(milliseconds: 500)
                                  );
                                  /*
                                HazizzLogger.printLog("oof: ${map[key]}");
                                if(map[key].isEmpty){

                                  setState(() {
                                    HazizzLogger.printLog("oof22: ${map}");
                                    map.remove(key);
                                    HazizzLogger.printLog("oof32: ${map}");
                                  });
                                }
                                */
                                }
                              }),
                            );
                          }
                      ),
                    );

                    if(index >= (map.keys.length) /*|| true*/){
                      return addScrollSpace(s);
                    }

                    return s;
                  }
              );
            }
          }),
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
                  bloc: GroupBlocs().groupTasksBloc,
                  //  stream: tasksBloc.subject.stream,
                  builder: (_, TasksState state) {
                    if (state is TasksLoadedState) {
                      Map<DateTime, List<PojoTask>> tasks = state.tasks;

                      HazizzLogger.printLog("onLoaded asdasd");
                      return onLoaded(tasks);

                    }if (state is TasksLoadedCacheState) {
                      Map<DateTime, List<PojoTask>> tasks = state.tasks;

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
                    } else if (state is TasksWaitingState) {
                      //return Center(child: Text("Loading Data"));
                      return Center(child: CircularProgressIndicator(),);
                    }else if (state is TasksErrorState) {
                      //return Center(child: Text("Loading Data"));
                      if(state.hazizzResponse.dioError == noConnectionError){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showNoConnectionFlushBar(context);
                        });
                      }else{
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Flushbar(
                            icon: Icon(FontAwesomeIcons.exclamation, color: Colors.red,),

                            message: "${locText(context, key: "tasks")}: ${locText(context, key: "info_something_went_wrong")}",
                            duration: Duration(seconds: 3),
                          );
                        });
                      }

                      if(GroupBlocs().groupTasksBloc.tasks!= null){
                        return onLoaded(GroupBlocs().groupTasksBloc.tasks);
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
            applyFilters();
            GroupBlocs().groupTasksBloc.dispatch(TasksFetchEvent()); //await getData()
            HazizzLogger.printLog("log: refreshing tasks");
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

    /*return Scaffold(
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

    );*/
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


