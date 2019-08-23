import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/comment_section_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/view_task_bloc.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';

import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/widgets/comment_section_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/tag_chip.dart';

import '../hazizz_date.dart';
import '../hazizz_fonts.dart';
import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';

class ViewTaskPage extends StatefulWidget {

//  CommentSectionBloc commentSectionBloc;

  CommentSectionWidget commentSectionWidget = CommentSectionWidget();

  int taskId;
  PojoTask pojoTask;

  ViewTaskPage({Key key, this.taskId}) : super(key: key){
  }

  ViewTaskPage.fromPojo({Key key, this.pojoTask}) : super(key: key){
    taskId = pojoTask.id;
    print("log: recreated blocs");
  }

  @override
  _ViewTaskPage createState() => _ViewTaskPage();
}

class _ViewTaskPage extends State<ViewTaskPage> {

  ScrollController _scrollController = ScrollController();

  static final AppBar appBar = AppBar(
    title: Text("Edit Task"),
  );

  static final double padding = 8;


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
        if(t.name != mainTag.name){
          tagWidgets.add(
              TagChip(child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 21, ),),
                hasCloseButton: false,
              )
          );
        }
      }


    });
  }

  List<Widget> tagWidgets;

  bool imTheAuthor = false;
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


  @override
  Widget build(BuildContext context) {

    if(pojoTask != null) {
      processData(context, pojoTask);
    }





    return Hero(
        tag: "hero_task${pojoTask.id}",
        child: Scaffold(
        appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text("View Task"),
        ),
        body:RefreshIndicator(
          onRefresh: () async{
           // widget.commentSectionWidget.commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());
            ViewTaskBloc().commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());

          },
          child: Stack(
            children: [ListView(
              controller: _scrollController,
              children: [Container(
                width: MediaQuery.of(context).size.width,
                // valamiért 3* kell megszorozni a paddingot hogy jó legyen
                height: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,

                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child:
                      Container(
                        /*
                        actionExtentRatio: 0.25,
                        actionPane: SlidableBehindActionPane (),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Done',
                            color: Colors.green,
                            icon: Icons.check,
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Done',
                            color: Colors.green,
                            icon: Icons.check,
                          ),
                        ],
                        */
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 100,
                          child: new RefreshIndicator(
                          onRefresh: (){
                         //   getData();
                          },
                          child: new Container(
                              child: new Column(
                               //   mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: mainTag != null ? mainTag.getColor(): Theme.of(context).primaryColor,
                                  //  width: 400,

                                    child: Column(
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


                                        Padding(
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
                                                      fontSize: 23
                                                  ),
                                                )
                                              ),
                                            ],
                                          ),
                                        ),

                                        Builder(
                                          builder: (context){
                                            if(pojoTask.group != null){
                                              return Padding(
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
                                                              fontSize: 23
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

                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 4),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0, left: 3),
                                                child: Icon(FontAwesomeIcons.calendarAlt),
                                              ),

                                              new Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(_deadline,
                                                    style: TextStyle(
                                                        fontSize: 23
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                                                        padding: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 6),
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
                                                        fontFamily: "ShortStack",
                                                        fontSize: 30
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
                                                          fontFamily: shortStackFont,
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

                                  Expanded(
                                   // flex: 1,
                                    child:
                                      Align(
                                        alignment: FractionalOffset.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            FlatButton(
                                              onPressed: () async {
                                                setState(() {
                                                  showComments = true;
                                                });
                                                await Future.delayed(const Duration(milliseconds: 50));
                                                _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.ease, duration: Duration(milliseconds: 340));
                                              },
                                              child: Text(locText(context, key: "comments").toUpperCase(), style: theme(context).textTheme.button),
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
                                                            MainTabBlocs().tasksBloc.dispatch(FetchData());
                                                          }
                                                        },
                                                        child: Text(locText(context, key: "edit").toUpperCase(), style: theme(context).textTheme.button,),
                                                      ),
                                                      FlatButton(
                                                        child: Text(locText(context, key: "delete").toUpperCase(), style: theme(context).textTheme.button),
                                                        onPressed: () async {
                                                          if(await showDeleteDialog(context, taskId: widget.taskId)){
                                                            print("success");
                                                            MainTabBlocs().tasksBloc.dispatch(FetchData());
                                                            Navigator.of(context).pop();

                                                          }else{
                                                            print("no success");

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
                                      )

                                  ),


                                ]
                              ),
                          )
                        ),
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
        )
      )
    );
  }
}
