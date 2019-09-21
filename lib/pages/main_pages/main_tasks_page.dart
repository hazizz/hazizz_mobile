import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/tasks_bloc.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/enums/task_complete_state_enum.dart';
import 'package:mobile/enums/task_expired_state_enum.dart';
import 'package:mobile/listItems/task_header_item_widget.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:mobile/managers/welcome_manager.dart';
import 'package:mobile/widgets/flushbars.dart';
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



  final GlobalKey<AnimatedListState> _listKey = GlobalKey();


  TaskCompleteState currentCompletedTaskState;

  TaskExpiredState currentExpiredTaskState;


  @override
  void initState() {

    currentCompletedTaskState = MainTabBlocs().tasksBloc.currentTaskCompleteState;
    currentExpiredTaskState = MainTabBlocs().tasksBloc.currentTaskExpiredState;

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


  void applyFilters(){
    MainTabBlocs().tasksBloc.currentTaskCompleteState = currentCompletedTaskState;
    MainTabBlocs().tasksBloc.currentTaskExpiredState = currentExpiredTaskState;
  }

  @override
  void dispose() {
    // tasksBloc.dispose();
    super.dispose();
  }

  Map<DateTime, List<PojoTask>> map = null;


  Widget onLoaded(Map<DateTime, List<PojoTask>> m){

    map = m;

    print("REBUILD, BIIP BOOp");

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

                      MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
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
                  itemCount: map.keys.length+1,
                  itemBuilder: (BuildContext context, int index) {



                    if(index == 0){
                      return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated)));
                    }

                    List<GlobalKey<AnimatedListState>> listKeyList = new List(map.keys.length);
                    for(int i = 0; i < listKeyList.length; i++){
                      listKeyList[i] =  GlobalKey();
                    }


                    DateTime key = map.keys.elementAt(index-1);
                    print("new key: ${key.toString()}");

                    return StickyHeader(

                      //  key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                      //key: Key(Random().nextInt(2000000).toString()),
                      header: TaskHeaderItemWidget(key: Key(Random().nextInt(2000000).toString()), dateTime: key),
                      content: Builder(
                          builder: (context) {
                            //  List<Widget> tasksList = new List();

                            /*
                        List<Widget> tasksList = new List();

                        for(PojoTask pojoTask in map[key]){
                         // tasksList.add( pojoTask
                          //  buildItem(context, index, animation, pojoTask)
                              tasksList.add(TaskItemWidget(originalPojoTask: pojoTask, key: Key(pojoTask.toJson().toString())),
                          );
                        }
                        */

                            // return Column(children: tasksList,);


                            //  Function onCompletedChanged;

                            /*
                        return ListView.builder(
                         // itemExtent: ,
                         // addRepaintBoundaries: false,
                       //   cacheExtent: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: map[key].length,
                          itemBuilder: (context, index){
                            return TaskItemWidget(originalPojoTask: map[key][index], onCompletedChanged: (){
                              var removedItem = map[key][index];


                              setState(() {
                                map[key].remove(removedItem);
                                MainTabBlocs().tasksBloc.tasks[key].remove(removedItem);
                                MainTabBlocs().tasksBloc.tasksRaw.remove(removedItem);

                                if(map[key].isEmpty){

                                  setState(() {
                                    print("oof22: ${map}");
                                    map.remove(key);
                                    MainTabBlocs().tasksBloc.tasks.remove(key);
                                    print("oof32: ${map}");
                                  });
                                }
                              });

                              //MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
                            },key: Key(map[key][index].toJson().toString()),);
                          },
                        );
                        */

                            return AnimatedList(
                              key: listKeyList[index-1],
                              //   key: Key(Random().nextInt(2000000).toString()),
                              shrinkWrap: true,
                              initialItemCount: map[key].length,

                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2, animation) => buildItem(context, index2, animation, map[key][index2], (){

                                print("bro: me: ${currentCompletedTaskState}");

                                if(currentCompletedTaskState != TaskCompleteState.BOTH){
                                  print("bro: im trigered");

                                  // var removedItem = map[key].removeAt(index2);
                                  var removedItem = map[key][index2];

                                  listKeyList[index-1].currentState.removeItem(index2, (context2, animation2){
                                    animation2.addStatusListener((AnimationStatus animationStatus){
                                      print("oof22: anim: ${animationStatus.toString()}");
                                      if(animationStatus == AnimationStatus.dismissed){
                                        print("oof: ${map[key]}");
                                        MainTabBlocs().tasksBloc.dispatch(TasksRemoveItemEvent( mapKey: key, index: index2));

                                        /*
                                    setState(() {
                                      map[key].remove(removedItem);
                                      MainTabBlocs().tasksBloc.tasks[key].remove(removedItem);
                                      MainTabBlocs().tasksBloc.tasksRaw.remove(removedItem);
                                      MainTabBlocs().tasksBloc.dispatch(TasksRemoveItemEvent());
                                    });
                                    */

                                        /*
                                    if(map[key].isEmpty){

                                      setState(() {
                                        print("oof22: ${map}");
                                        map.remove(key);
                                        MainTabBlocs().tasksBloc.tasks.remove(key);
                                        print("oof32: ${map}");
                                      });
                                    }
                                    */
                                      }
                                    });
                                    return buildItem(context2, index2, animation2, removedItem, (){});
                                  },
                                      duration:  Duration(milliseconds: 500)
                                  );
                                  /*
                                print("oof: ${map[key]}");
                                if(map[key].isEmpty){

                                  setState(() {
                                    print("oof22: ${map}");
                                    map.remove(key);
                                    print("oof32: ${map}");
                                  });
                                }
                                */
                                }
                              }),
                            );
                          }
                      ),
                    );
                  }
              );
            }
          }),
        )
      ],
    );
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

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: new RefreshIndicator(

          child: Stack(
            children: <Widget>[
              ListView(),
              BlocBuilder(
                  bloc: MainTabBlocs().tasksBloc,
                  //  stream: tasksBloc.subject.stream,
                  builder: (_, TasksState state) {
                    if (state is TasksLoadedState) {
                     /* WidgetsBinding.instance.addPostFrameCallback((_) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Baaaaaaaa'),
                          duration: Duration(seconds: 3),
                        ));
                        // Toast.show("FIXIN", context, duration: 4, gravity:  Toast.BOTTOM);
                        scaffoldState.currentState.showSnackBar(SnackBar(
                          content: Text('Button moved to separate widget'),
                          duration: Duration(seconds: 3),
                        ));
                        Toast.show("FIXIN", context, duration: 4, gravity:  Toast.BOTTOM);

                        // Toast.show(locText(context, key: "info_something_went_wrong"), context, duration: 4, gravity:  Toast.BOTTOM);
                      });
                      */

                      Map<DateTime, List<PojoTask>> tasks = state.tasks;

                      print("onLoaded asdasd");
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
                          showNoConnectionFlushBar(context, scaffoldState: scaffoldState);
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
            applyFilters();
            MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent()); //await getData()
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