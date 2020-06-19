import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/task_complete_state_enum.dart';
import 'package:mobile/enums/task_expired_state_enum.dart';
import 'package:mobile/widgets/ad_widget.dart';
import 'package:mobile/widgets/listItems/task_header_item_widget.dart';
import 'package:mobile/widgets/listItems/task_item_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';
import 'package:mobile/widgets/tab_widget.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class TasksPage extends TabWidget {
  TasksPage({Key key}) : super(key: key, tabName: "TasksTab");

  getUIName(BuildContext context){
    return localize(context, key: "tasks").toUpperCase();
  }

  @override
  _TasksPage createState() => _TasksPage();
}

class _TasksPage extends State<TasksPage>
    with TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin{

  TaskCompleteStateEnum currentCompletedTaskState;

  TaskExpiredStateEnum currentExpiredTaskState;

  @override
  void initState() {
    currentCompletedTaskState = MainTabBlocs().tasksBloc.currentTaskCompleteState;
    currentExpiredTaskState = MainTabBlocs().tasksBloc.currentTaskExpiredState;

    super.initState();
  }


  void applyFilters(){
    MainTabBlocs().tasksBloc.currentTaskCompleteState = currentCompletedTaskState;
    MainTabBlocs().tasksBloc.currentTaskExpiredState = currentExpiredTaskState;
  }

  @override
  void dispose() {
    super.dispose();
  }




  Widget onLoaded(Map<DateTime, List<PojoTask>> map){
	//	Map<DateTime, List<PojoTask>> map = m;

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
                    DropdownMenuItem(child: Text(localize(context, key: "complete")), value: TaskCompleteStateEnum.COMPLETED, ),
                    DropdownMenuItem(child: Text(localize(context, key: "incomplete")), value: TaskCompleteStateEnum.UNCOMPLETED,),
                    DropdownMenuItem(child: Text(localize(context, key: "both")), value: TaskCompleteStateEnum.BOTH, ),

                  ],
                ),

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
                      DropdownMenuItem(child: Text(localize(context, key: "expired")), value: TaskExpiredStateEnum.EXPIRED,),
                      DropdownMenuItem(child: Text(localize(context, key: "active")), value: TaskExpiredStateEnum.UNEXPIRED,)
                    ],
                  ),
                ),
                Spacer(),

                FlatButton(child: Text(localize(context, key: "apply").toUpperCase(), style: TextStyle(fontSize: 13),),
                  onPressed: (){

                    applyFilters();

                    MainTabBlocs().tasksBloc.add(TasksFetchEvent());
                  },
                )
              ],
            ),
          )
        ),

        Expanded(
          child: Builder(builder: (context){
            if(map.keys == null || map.keys.isEmpty){
              return Center(child: Text(localize(context, key: "no_tasks")),);
            }else{
              int itemCount = map.keys.length+1;
              return ListView.separated(
                  addAutomaticKeepAlives: false,
                  itemCount: itemCount,
                  separatorBuilder: (context, index ){
                    return showAd(context, show: (itemCount<3 && index == itemCount-1) || (index!=0 && index%3==0), showHeader: true);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if(index == 0){
                      return Center(child: Text(MainTabBlocs().tasksBloc.lastUpdated.dateTimeToLastUpdatedFormatLocalized(context)));
                    }

                    List<GlobalKey<AnimatedListState>> listKeyList = new List(map.keys.length);

                    listKeyList.forEach((e) => e = GlobalKey());

                    DateTime key = map.keys.elementAt(index-1);

                    Widget s = StickyHeader(
                      header: TaskHeaderItemWidget(dateTime: key),
                      content: Builder(
                        builder: (context) {
                          return Column(
                            children: <Widget>[
                              AnimatedList(
                                key: listKeyList[index-1],
                                //   key: Key(Random().nextInt(2000000).toString()),
                                shrinkWrap: true,
                                initialItemCount: map[key].length,

                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index2, animation){
                                  if(map[key].length-1 < index2) return Container();
                                  return buildItem(context, index2, animation, map[key][index2], (){
                                    if(currentCompletedTaskState != TaskCompleteStateEnum.BOTH){
                                      var removedItem = map[key][index2];
                                      listKeyList[index-1].currentState.removeItem(index2, (context2, animation2){
                                        animation2.addStatusListener((AnimationStatus animationStatus){
                                          if(animationStatus == AnimationStatus.dismissed){
                                            MainTabBlocs().tasksBloc.add(TasksRemoveItemEvent( mapKey: key, index: index2));
                                          }
                                        });
                                        return buildItem(context2, index2, animation2, removedItem, (){});
                                      },
                                          duration: 500.milliseconds
                                      );
                                    }
                                  });
                                }

                              ),
                            ],
                          );
                        }
                      ),
                    );

                    if(index == itemCount-1 /*|| true*/){
                      return addScrollSpace(s);
                    }
                    return s;
                  }
              );
            }
          }),
        ),
      ],
    );
  }

  Widget buildItem(BuildContext context, int index, Animation animation, PojoTask pojoTask, Function onCompletedChanged){
    Animation<Offset> a = Tween<Offset>(begin: Offset(-1, 0.0), end: Offset(0, 0)).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(
            0.1,
            1.0,
            curve: Curves.easeOutSine,
          ),
        )
    );
    return SlideTransition(
        position: a,
        child: TaskItemWidget(originalPojoTask: pojoTask, onCompletedChanged: onCompletedChanged, key: Key(pojoTask.toJson().toString()),)
       // child: TaskItemWidget(originalPojoTask: pojoTask, onCompletedChanged: onCompletedChanged, key: Key(pojoTask.toJson().toString()),)
    );
  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldState,
      body: Column(
        children: <Widget>[
          BlocBuilder(
            bloc: MainTabBlocs().tasksBloc,
            builder: (context, state){
              if(state is TasksWaitingState || state is TasksLoadedCacheState){
                return LinearProgressIndicator(
                  value: null,
                );
              }
              return Container();
            },
          ),
          Expanded(
            child: new RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    ListView(),
                    BlocBuilder(
                        bloc: MainTabBlocs().tasksBloc,
                        //  stream: tasksBloc.subject.stream,
                        builder: (_, TasksState state) {
                          if (state is TasksLoadedState) {
                          //  Map<DateTime, List<PojoTask>> tasks = state.tasks;

                            HazizzLogger.printLog("onLoaded asdasd");
                            return onLoaded(state.tasks);

                          }if (state is TasksLoadedCacheState) {
                           // Map<DateTime, List<PojoTask>> tasks = state.tasks;

                            return onLoaded(state.tasks);

                          } else if (state is ResponseEmpty) {
                            return Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Text(localize(context, key: "no_tasks_yet")),
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

                            }else{
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Flushbar(
                                  icon: Icon(FontAwesomeIcons.exclamation, color: Colors.red,),

                                  message: "${localize(context, key: "tasks")}: ${localize(context, key: "info_something_went_wrong")}",
                                  duration: 3.seconds,
                                );
                              });
                            }
                            if(MainTabBlocs().tasksBloc.tasks!= null){
                              return onLoaded(MainTabBlocs().tasksBloc.tasks);
                            }
                            return Center(
                                child: Text(localize(context, key: "info_something_went_wrong")));
                          }
                          return Center(
                              child: Text(localize(context, key: "info_something_went_wrong")));
                        }
                    ),
                  ],
                ),
                onRefresh: () async{
                  applyFilters();
                  MainTabBlocs().tasksBloc.add(TasksFetchEvent()); //await getData()
                  HazizzLogger.printLog("log: refreshing tasks");
                  return;
                }
            ),
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "1",
        onPressed: (){
          Navigator.pushNamed(context, "/createTask");
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}