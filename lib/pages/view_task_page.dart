import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/blocs/comment_section_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/view_task_bloc.dart';
import 'package:mobile/communication/pojos/PojoType.dart';

import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/widgets/comment_section_widget.dart';

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
   // commentSectionBloc = CommentSectionBloc(taskId: taskId);
   // commentSectionWidget = CommentSectionWidget(taskId: taskId,);
  }

  ViewTaskPage.fromPojo({Key key, this.pojoTask}) : super(key: key){
   // taskId = pojoTask.id;
    print("log: recreated blocs");


    // commentSectionBloc = CommentSectionBloc(taskId: taskId);
   // commentSectionWidget = CommentSectionWidget(taskId: taskId,);
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
   String _type = "";
   String _deadline = "";
   String _description = "";
   String _title = "";

  List<PojoTask> task_data = List();

  bool showComments = false;

  void processData(PojoTask pojoTask){
    widget.pojoTask = pojoTask;
    setState(() {
      _subject = pojoTask.subject != null ? pojoTask.subject.name : null;
      _group = pojoTask.group.name;

      _creator = pojoTask.creator.displayName;

      _type = pojoTask.type.name;
      DateTime date_deadline =  pojoTask.dueDate;
      _deadline = hazizzShowDateFormat(date_deadline);//"${date_deadline.day}.${date_deadline.month}.${date_deadline.year}";
      _description = pojoTask.description;
      _title = pojoTask.title;
    });
  }

  bool imTheAuthor = false;
  // lényegében egy onCreate
  @override
  void initState() {
   // getData();


    InfoCache.getMyId().then((int result){
      if(widget.pojoTask.creator.id == result){
        setState(() {
          imTheAuthor = true;
        });
      }
    });

    ViewTaskBloc().reCreate(pojoTask: widget.pojoTask);



    if(widget.pojoTask != null) {
      processData(widget.pojoTask);
    }



    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_task${widget.pojoTask.id}",
        child: Scaffold(
        appBar: AppBar(
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
                      Slidable(
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
                                    color: PojoType.getColor(widget.pojoTask.type),
                                  //  width: 400,

                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              new Flexible(
                                                child: Text(_type,
                                                  style: TextStyle(
                                                    fontSize: 36
                                                  ),
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2),                              child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              new Flexible(
                                                child: Text(widget.pojoTask.creator.displayName,
                                                  style: TextStyle(
                                                      fontSize: 23
                                                  ),
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2),                              child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            new Flexible(
                                                child: Text(widget.pojoTask.group.name,
                                                  style: TextStyle(
                                                      fontSize: 23
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 4),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              new Flexible(
                                                child: Text(_deadline,
                                                  style: TextStyle(
                                                      fontSize: 23
                                                  ),
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    ),

                                  Stack(
                                    children: <Widget>[

                                      /*
                                      new SizedBox(
                                        width: double.infinity,
                                      //   height: double.infinity,
                                        child: CustomPaint(
                                          size: Size(300, 150),
                                          foregroundPainter: NoteBookPainter(),
                                        ),
                                      ),
                                      */


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
                                                          color: PojoType.getColor(widget.pojoTask.type)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 6),
                                                        child: Text(widget.pojoTask.subject.name,
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

                                      /*
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only( left: 10,top: 5, right: 10),
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new Flexible(
                                                  child: new RichText(
                                                    text: TextSpan(
                                                      text: " " * 500,

                                                      style:  TextStyle(
                                                        fontFamily: "ShortStack",
                                                        decorationColor: Colors.black,
                                                        color: Colors.transparent,
                                                        fontSize: 30,
                                                        decoration: TextDecoration.underline
                                                      ),

                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only( left: 0, right: 0, top: 4),
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new Flexible(
                                                      child: RichText(
                                                      text: TextSpan(
                                                        text: "a" * 500,
                                                        style:  TextStyle(
                                                          decorationThickness: 2,
                                                            decorationColor: Colors.black54,
                                                            color: Colors.transparent,
                                                            fontSize: 26,
                                                            decoration: TextDecoration.underline
                                                        ),
                                                      ),
                                                    ),
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      */
                                    ],
                                  ),
                                  /*
                                  _subject != null ? Padding(
                                    padding: const EdgeInsets.only( left: 10,top: 5),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        new Flexible(
                                          child:
                                          new Text(_subject,
                                            style: TextStyle(
                                                fontSize: 36
                                            ),
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
                                                fontSize: 26
                                            ),
                                          )
                                          )
                                      ],
                                    ),
                                  ),
                                  */

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
                                                        onPressed: (){
                                                          Navigator.pushNamed(context, "/editTask", arguments: widget.pojoTask);
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

  /*
  Future<bool> showDeleteDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 130.0,
                  width: 200.0,
                  decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                         // Container(height: 100.0),
                          Container(
                            height: 80.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                color: Colors.red),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Are you sure you want to delete this task?",
                              style: TextStyle(

                                fontFamily: 'Quicksand',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),

                        ],
                      ),
                    //  SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              child: Center(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.0,
                                      color: Colors.teal),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.transparent
                          ),
                          FlatButton(
                              child: Center(
                                child: Text(
                                  'DELETE',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.0,
                                      color: Colors.red),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.transparent
                          ),
                        ],
                      )

                    ],
                  )));
        });
  }
  */


}





/*new Flexible(
                    child: new Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      child: new TextField(
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ),*/


/*new Flexible(
                    child: new Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      child: new TextField(
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ),*/