import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/comment_section_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/tasks_bloc.dart';
import 'package:mobile/blocs/view_task_bloc.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';

import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/widgets/comment_section_widget.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/tag_chip.dart';
import 'package:snappable/snappable.dart';

import '../communication/requests/request_collection.dart';
import '../hazizz_date.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';
import '../hazizz_theme.dart';
import '../request_sender.dart';
import 'main_pages/main_tasks_page.dart';

class ViewTaskPage extends StatefulWidget {

//  CommentSectionBloc commentSectionBloc;

  CommentSectionWidget commentSectionWidget = CommentSectionWidget();

  int taskId;
  PojoTask pojoTask;

  ViewTaskPage({Key key, this.taskId}) : super(key: key){
  }

  ViewTaskPage.fromPojo({Key key, this.pojoTask}) : super(key: key){
    taskId = pojoTask.id;
    HazizzLogger.printLog("HazizzLog: created ViewTaskPage.fromPojo");
  }

  @override
  _ViewTaskPage createState() => _ViewTaskPage();
}

class _ViewTaskPage extends State<ViewTaskPage> {

  ScrollController _scrollController = ScrollController();

  static final AppBar appBar = AppBar(
    title: Text("what's my purpose?"),
  );

  static final double padding = 8;


  bool completed = true;
  bool isFirstTime = true;

  String _subject = "";
  String _group = "";
  String _creator = "";
  //String _type = "";
  List<PojoTag> _tags = List();
  String _deadline = "";
  String _description = "";
  String _title = "";
  PojoTag mainTag = null;

  List<PojoTask> task_data = List();

  bool showComments = false;

  PojoTask pojoTask;

  void processData(BuildContext context, PojoTask pojoTask){
    widget.pojoTask = pojoTask;
    setState(() {
      _subject = pojoTask.subject != null ? pojoTask.subject.name : null;
      _group = pojoTask.group?.name;

      _creator = pojoTask.creator.displayName;

     // _type = pojoTask.tags[0].getDisplayName(context);

      for(PojoTag t in pojoTask.tags){
        if(mainTag == null){
          for(PojoTag defT in PojoTag.defaultTags){
            if(t.name ==  defT.name){
              mainTag = t;
            }
          }
        }
      }
      _tags = pojoTask.tags;


      DateTime date_deadline =  pojoTask.dueDate;
      _deadline = hazizzShowDateFormat(date_deadline);//"${date_deadline.day}.${date_deadline.month}.${date_deadline.year}";
      _description = pojoTask.description;
      _title = pojoTask.title;


      tagWidgets = List();


      for(PojoTag t in pojoTask.tags){
        if(mainTag == null ||  t.name != mainTag.name){
          tagWidgets.add(
              TagChip(child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 21, ),),
                hasCloseButton: false,
              )
          );
        }
      }

      if(isFirstTime){
        completed = pojoTask.completed;
        isFirstTime = false;
      }


    });
  }

  List<Widget> tagWidgets;

  bool imTheAuthor = false;


  final snapKey = GlobalKey<SnappableState>();

  @override
  void initState() {
   // getData();


    pojoTask = widget.pojoTask;

    InfoCache.getMyId().then((int result){
      if(pojoTask.creator.id == result){
        setState(() {
          imTheAuthor = true;
        });
      }
    });

    ViewTaskBloc().reCreate(pojoTask: pojoTask);







    super.initState();
  }

  /*
  setComplete(bool c){
    setState(() {
      HazizzLogger.printLog("obungaööö: $c");

      completed = c;
    });
  }
  */




  @override
  Widget build(BuildContext context) {

    if(pojoTask != null) {
      processData(context, pojoTask);
    }




    return Hero(
        tag: "hero_task${pojoTask.id}",
        child: WillPopScope(
          onWillPop: (){
            Navigator.pop(context, pojoTask);
            return Future.value(false);
          },
          child: Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(onPressed: (){
              Navigator.pop(context, pojoTask);
            },),
            title: Text(locText(context, key: "view_task")),
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                onSelected: (value) async {
                  if(value == "report"){
                    bool success = await showReportDialog(context, reportType: ReportTypeEnum.TASK, id: widget.pojoTask.id, name: "");
                    if(success != null && success){
                      showReportSuccessFlushBar(context, what: locText(context, key: "task"));

                    }

                  }

                  if(value == "snap"){
                    snapKey.currentState.snap();

                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "report",
                      child: Text(locText(context, key: "report"),
                        style: TextStyle(color: HazizzTheme.red),
                      ),
                    )
                  ];
                },
              )
            ],
          ),
          body:Snappable(
            key: snapKey,
            child: RefreshIndicator(
              onRefresh: () async{
               // widget.commentSectionWidget.commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());
                ViewTaskBloc().commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());

              },
              child: Stack(
                children: [ListView(
                  controller: _scrollController,
                  children: [ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                      maxHeight: (MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3)*2,

                      minWidth: MediaQuery.of(context).size.width,
                      maxWidth: MediaQuery.of(context).size.width,

                    ),
                    /*
                    width: MediaQuery.of(context).size.width,
                    // valamiért 3* kell megszorozni a paddingot hogy jó legyen
                    height: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                    */

                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 100,
                              child:new Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                      color: mainTag != null ? mainTag.getColor(): Theme.of(context).primaryColor,
                                      //  width: 400,

                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 6, bottom: 6),
                                              child: Builder(builder: (context){


                                                HazizzLogger.printLog("HazizzLog: redrawing coz completed: $completed");
                                                IconData iconData;
                                                if(completed){


                                                  return IconButton(
                                                      icon: Icon(FontAwesomeIcons.checkSquare, size: 32,),
                                                      onPressed: () async {
                                                        setState(() {
                                                          completed = false;
                                                          pojoTask.completed = false;

                                                        });
                                                        HazizzResponse hazizzResponse = await RequestSender().getResponse(SetTaskCompleted(p_taskId: pojoTask.id, setCompleted: false));
                                                        if(hazizzResponse.isError){
                                                          setState(() {
                                                            completed = true;
                                                            pojoTask.completed = true;

                                                          });
                                                        }
                                                      }
                                                  );
                                                }
                                                return IconButton(
                                                    icon: Icon(FontAwesomeIcons.square, size: 32,),
                                                    onPressed: () async {
                                                      setState(() {
                                                       completed = true;
                                                        pojoTask.completed = true;

                                                      });
                                                      HazizzResponse hazizzResponse = await RequestSender().getResponse(SetTaskCompleted(p_taskId: pojoTask.id, setCompleted: true));
                                                      if(hazizzResponse.isError){
                                                        setState(() {
                                                          completed = false;
                                                          pojoTask.completed = false;

                                                        });
                                                      }
                                                    }
                                                 );
                                              }),
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Builder(
                                                builder: (context){
                                                  if(mainTag != null){
                                                    return Padding(
                                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2),
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          new Flexible(
                                                              child: Text(mainTag.getDisplayName(context),
                                                                style: TextStyle(
                                                                    fontSize: 36,
                                                                    fontWeight: FontWeight.w800
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              ),


                                              Wrap(
                                                alignment: WrapAlignment.start,
                                                //  runAlignment: WrapAlignment.start,

                                                spacing: 8,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: tagWidgets,
                                              ),

                                              GestureDetector(
                                                onTap: (){
                                                  showUserDialog(context, creator: pojoTask.creator);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 2),
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 8.0, left: 3),
                                                        child: Icon(FontAwesomeIcons.userAlt),
                                                      ),
                                                      new Flexible(
                                                          child: Text(pojoTask.creator.displayName,
                                                            style: TextStyle(
                                                                fontSize: 20
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Builder(
                                                builder: (context){
                                                  if(pojoTask.group != null){
                                                    return GestureDetector(
                                                      onTap: (){
                                                        Navigator.pushNamed(context, "/group/groupId", arguments: widget.pojoTask.group);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 2),
                                                        child: new Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 11.0),
                                                              child: Icon(FontAwesomeIcons.users),
                                                            ),
                                                            new Flexible(
                                                                child: Text(pojoTask.group.name,
                                                                  style: TextStyle(
                                                                      fontSize: 21
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 4),
                                                child: new Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0, left: 3),
                                                      child: Icon(FontAwesomeIcons.calendarTimes),
                                                    ),

                                                    new Flexible(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 4.0),
                                                        child: Text(_deadline,
                                                          style: TextStyle(
                                                              fontSize: 20
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ),
                                    Stack(
                                      children: <Widget>[

                                        Column(
                                          children: <Widget>[
                                            _subject != null ? Padding(
                                              padding: const EdgeInsets.only( left: 0,top: 0),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  new Flexible(
                                                    child:
                                                    new Container(
                                                      // color: PojoType.getColor(pojoTask.type),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                                          color: mainTag != null ? mainTag.getColor(): Theme.of(context).primaryColor,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 0),
                                                          child: Text(pojoTask.subject.name,
                                                            style: TextStyle(fontSize: 32),
                                                          ),
                                                        )
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ) : Container(),
                                            Padding(
                                              padding: const EdgeInsets.only( left: 10,top: 5),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  new Flexible(
                                                    child: new Text(_title,
                                                      style: TextStyle(
                                                        //  fontFamily: "ShortStack",
                                                          fontSize: 33
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only( left: 20, right: 20, top: 4),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  new Flexible(
                                                      child: Text(_description,

                                                        style: TextStyle(
                                                          // fontFamily: shortStackFont,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 26
                                                        ),
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),


                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      BlocBuilder(
                                          bloc: ViewTaskBloc().commentBlocs.commentSectionBloc,
                                          builder: (context, state){

                                            Widget chip = Container();

                                            if(state is CommentSectionLoadedState){
                                              chip = Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50.0),

                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                                                  child: Text(state.items.length.toString()),
                                                ), color: Colors.red,
                                              );
                                            }

                                            return Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 3.0, right: 3),
                                                  child: FlatButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        showComments = true;
                                                      });
                                                      await Future.delayed(const Duration(milliseconds: 50));
                                                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.ease, duration: Duration(milliseconds: 340));
                                                    },

                                                     child: Text(locText(context, key: "comments").toUpperCase(), style: theme(context).textTheme.button)

                                                  ),
                                                ),
                                                Positioned(top: 0, right: 0,
                                                  child: chip,
                                                )

                                              ],
                                            );

                                        }
                                      ),
                                      Builder(
                                          builder: (context){
                                            if(imTheAuthor){

                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  FlatButton(
                                                    onPressed: () async {
                                                      var editedTask = await Navigator.of(context).pushNamed( "/editTask", arguments: pojoTask);
                                                      if(editedTask != null && editedTask is PojoTask){
                                                        setState(() {
                                                          pojoTask = editedTask;
                                                          processData(context, pojoTask);
                                                        });
                                                        MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
                                                      }
                                                    },
                                                    child: Text(locText(context, key: "edit").toUpperCase(), style: theme(context).textTheme.button,),
                                                  ),
                                                  FlatButton(
                                                    child: Text(locText(context, key: "delete").toUpperCase(), style: theme(context).textTheme.button),
                                                    onPressed: () async {
                                                      if(await showDeleteTaskDialog(context, taskId: widget.taskId)){
                                                        HazizzLogger.printLog("HazizzLog: showDeleteTaskDialog : success");
                                                        MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
                                                        Navigator.of(context).pop();

                                                      }else{
                                                        HazizzLogger.printLog("HazizzLog: showDeleteTaskDialog: no success");

                                                      }

                                                    },

                                                  ),
                                                ],
                                              );
                                            }
                                            else return Container();
                                          }
                                      )
                                    ],
                                  ),
                              ]
                            ),
                        ),


                    ),
                  ),
                  Builder(
                    builder: (BuildContext context){
                      if(showComments) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          // valamiért 3* kell megszorozni a paddingot hogy jó legyen
                          //  height: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                          child: Padding(
                              padding: EdgeInsets.all(padding),
                              child:
                              widget.commentSectionWidget
                          ),
                        );
                      }
                      return Container();
                    },
                  )
                  ],
                ),
              ]
              ),
            ),
          )
      ),
        )
    );
  }
}
