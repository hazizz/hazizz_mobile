import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';

/*
// TODO rewrite this mess

Widget getCorrectTaskItemWidget(PojoTask task, {Function onCompletedChanged, Key key}){

  return TaskItemWidget(originalPojoTask: task, onCompletedChanged: onCompletedChanged, key: key,);
  /*
  if(task.assignation.name == "THERA"){
    return TheraTaskItemWidget(task, key: key);
  }else{
    return TaskItemWidget(originalPojoTask: task, onCompletedChanged: onCompletedChanged, key: key,);
  }
  */
}
*/

/*
class TheraTaskItemWidget extends StatelessWidget  {

  final PojoTask task;

  PojoTag mainTag;
  Color mainColor = Colors.grey;

  List<PojoTag> tags = [];

  TheraTaskItemWidget(this.task, {Key key}) : super(key: key) {
    bool doBreak = false;
    if(task.tags != null){
      tags.addAll(task.tags);

      for(PojoTag t in task.tags) {
        if(!doBreak){
          for(PojoTag defT in PojoTag.defaultTags) {
            if(defT.name == t.name) {
              tags.remove(t);
              mainTag = t;
              mainColor = t.getColor();
              doBreak = true;
              break;
            }
          }
        }else{
          break;
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, "/viewTask", arguments: task.copy());
        },
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width-60,
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 1.4 ,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 2,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                                    color: mainColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, top: 0, right: 6, bottom: 0),
                                  child: Text(mainTag?.getDisplayName(context) ?? "",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                                )
                            ),
                            for (PojoTag t in tags) Padding(
                              padding: const EdgeInsets.only(top: 2, left:2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: t.name == "Thera" ? HazizzTheme.kreta_homeworkColor : Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                                  child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                                ),
                              ),
                            )
                          ] //tagWidgets
                      ),
                    ),
                  ],
                ),

                Builder(
                  builder: (context){
                    if(task.subject == null){
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 3, left: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: mainColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 4),
                            child: Text(task.subject.name,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),),
                          )
                      ),
                    );
                  },
                ),

                Builder(
                  builder: (context){
                    if(task.title == null) return Container();
                    return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(task.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                          ),
                        ]
                    );
                  },
                ),

                Padding(
                    padding: const EdgeInsets.only(right: 20, top: 0, bottom: 0),
                    // child: Text(markdownImageRemover(pojoTask.description), style: TextStyle(fontSize: 18),),
                    child: Builder(
                      builder: (context){

                        if(task.description.length >= 200){

                        }

                        return Stack(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(),
                                child: Builder(
                                  builder: (context){
                                    Color textColor = Colors.black;
                                    if(HazizzTheme.currentThemeIsDark){
                                      textColor = Colors.white;
                                    }
                                    return Transform.translate(
                                      offset: const Offset(-6, -9),
                                      child: Markdown(data: task.description,
                                        padding:  const EdgeInsets.only(left: 20, top: 12),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        imageBuilder: (uri){

                                          final List<String> a = uri.toString().split("?id=");
                                          final String id = a.length > 1 ? a[1] : null;

                                          if(id != null){
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                              child: Container(
                                                height: 60,
                                                child: ClipRRect(
                                                  child: Image.network( "https://drive.google.com/thumbnail?id=$id",
                                                    loadingBuilder: (context, child, progress){
                                                      return progress == null
                                                          ? child
                                                          : CircularProgressIndicator();
                                                    },
                                                  ),
                                                  borderRadius: BorderRadius.circular(3),
                                                ),
                                              ),
                                            );
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                            child: Container(
                                              height: 60,
                                              child: ClipRRect(
                                                child: Image.network(uri.toString(),
                                                  loadingBuilder: (context, child, progress){
                                                    return progress == null
                                                        ? child
                                                        : CircularProgressIndicator();
                                                  },
                                                ),
                                                borderRadius: BorderRadius.circular(3),
                                              ),

                                            ),
                                          );
                                        },

                                        onTapLink: (String url) async {
                                          await Navigator.pushNamed(context, "/viewTask", arguments: task.copy());
                                        },

                                        styleSheet: MarkdownStyleSheet(
                                          p:  TextStyle(fontFamily: "Nunito", fontSize: 14, color: textColor),
                                          h1: TextStyle(fontFamily: "Nunito", fontSize: 26, color: textColor),
                                          h2: TextStyle(fontFamily: "Nunito", fontSize: 24, color: textColor),
                                          h3: TextStyle(fontFamily: "Nunito", fontSize: 22, color: textColor),
                                          h4: TextStyle(fontFamily: "Nunito", fontSize: 20, color: textColor),
                                          h5: TextStyle(fontFamily: "Nunito", fontSize: 18, color: textColor),
                                          h6: TextStyle(fontFamily: "Nunito", fontSize: 16, color: textColor),
                                          a:  TextStyle(fontFamily: "Nunito", color: Colors.blue, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]
                        );
                      },
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 6),
                      child: Text(task.creator.displayName, style: theme(context).textTheme.subtitle2,),
                    ),
                  ],
                )
              ],
            ),
      )
    );
  }
}
*/


class TaskItemWidget extends StatefulWidget  {

  final PojoTask originalPojoTask;
  final Function onCompletedChanged;

  TaskItemWidget({Key key, @required this.originalPojoTask, @required this.onCompletedChanged}) : super(key: key);

  @override
  _TaskItemWidget createState() => _TaskItemWidget();
}

class _TaskItemWidget extends State<TaskItemWidget>  {

  PojoTask pojoTask;
  bool isCompleted;

  List<PojoTag> tags = [];

  PojoTag mainTag;
  Color mainColor = Colors.grey;

  @override
  void initState() {
    pojoTask = widget.originalPojoTask;
    isCompleted = pojoTask.completed;

    bool doBreak = false;

    if(pojoTask.tags != null){
      tags.addAll(pojoTask.tags);

      for(int i = 0; i < tags.length; i++) {
        PojoTag t = pojoTask.tags[i];
        if(!doBreak){
          for(PojoTag defT in PojoTag.defaultTags) {
            if(defT.name == t.name) {
              tags.removeAt(i);
              mainTag = t;
              mainColor = t.getColor();
              doBreak = true;
              break;
            }
          }
        }else{
          break;
        }
      }
    }

    HazizzLogger.printLog("msgasdsd " + tags.join(", "));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTap() async {
    dynamic editedTask = await Navigator.pushNamed(context, "/viewTask", arguments: pojoTask.copy());
    if(editedTask != null){
      HazizzLogger.printLog("old task: ${pojoTask.toJson()}");
      HazizzLogger.printLog("edited task: ${editedTask.toJson()}");

      if(pojoTask.completed != editedTask.completed){
        widget.onCompletedChanged();
      }
      if(mounted){
        setState(() {
          pojoTask = editedTask;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    /*
    List<Widget> tagWidgets = List();


    tagWidgets.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
            color: mainColor
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 3, top: 3, right: 6, bottom: 3),
          child: Text(mainTag.getDisplayName(context),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
        )
    ));
    for(PojoTag t in tags){
      tagWidgets.add(Padding(
        padding: const EdgeInsets.only(top: 2, left:2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: t.name == "Thera" ? HazizzTheme.kreta_homeworkColor : Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2, left: 6, right: 6),
            child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
          ),
        ),
      ));
    }
    */

    return  Card(
      margin: EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            if(pojoTask.assignation.name != "THERA") Positioned(
              top: 0, right: 0,
              child: Builder(
                builder: (context){
                  pojoTask.completed = isCompleted;

                  return Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      activeColor: Colors.green,
                      value: isCompleted,
                      onChanged: (val) async {
                      setState(() {
                        isCompleted = val;
                        if(isCompleted){
                          widget.onCompletedChanged();
                        }
                      });
                      await RequestSender().getResponse(SetTaskCompleted(pTaskId: widget.originalPojoTask.id, setCompleted: isCompleted));
                    }),
                  );
                },
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width-60,
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 1.4 ,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 2,
                          children: [
                            if(mainTag != null) Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                                color: mainColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3, right: 6),
                                child: Text(mainTag.getDisplayName(context),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                              )
                            ),
                            for (PojoTag t in tags) Padding(
                              padding: const EdgeInsets.only(top: 2, left:1),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: t.name == "Thera" ? HazizzTheme.kreta_homeworkColor : Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only( left: 6, right: 6),
                                  child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                                ),
                              ),
                            )
                          ] //tagWidgets
                      ),
                    ),
                  ],
                ),

                Builder(
                  builder: (context){
                    if(pojoTask.subject == null){
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 3, left: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: mainColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 0.5, right: 4, bottom: 0.5),
                          child: Text(pojoTask.subject.name,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),),
                        )
                      ),
                    );
                  },
                ),

                Builder(
                  builder: (context){
                    if(pojoTask.title == null) return Container();
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(pojoTask.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                        ),
                      ]
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  // child: Text(markdownImageRemover(pojoTask.description), style: TextStyle(fontSize: 18),),
                  child: Builder(
                    builder: (context){

                      if(pojoTask.description.length >= 200){

                      }
                      return Stack(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Builder(
                                builder: (context){
                                  Color textColor = Colors.black;
                                  if(HazizzTheme.currentThemeIsDark){
                                    textColor = Colors.white;
                                  }
                                  return Transform.translate(
                                    offset: const Offset(-6, -9),
                                    child: Markdown(data: pojoTask.description,
                                      padding:  const EdgeInsets.only(left: 20, top: 12),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      imageBuilder: (Uri uri, String title, String alt){

                                        final List<String> a = uri.toString().split("?id=");
                                        final String id = a.length > 1 ? a[1] : null;

                                        if(id != null){
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                            child: Container(
                                              height: 60,
                                              child: ClipRRect(
                                                child: Image.network( "https://drive.google.com/thumbnail?id=$id",
                                                  loadingBuilder: (context, child, progress){
                                                    return progress == null
                                                        ? child
                                                        : CircularProgressIndicator();
                                                  },
                                                ),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                            ),
                                          );
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                          child: Container(
                                            height: 60,
                                            child: ClipRRect(
                                              child: Image.network(uri.toString(),
                                                loadingBuilder: (context, child, progress){
                                                  return progress == null
                                                      ? child
                                                      : CircularProgressIndicator();
                                                },
                                              ),
                                              borderRadius: BorderRadius.circular(3),
                                            ),

                                          ),
                                        );
                                      },

                                      onTapLink: (String url) async {
                                        onTap();
                                      },

                                      styleSheet: MarkdownStyleSheet(
                                        p:  TextStyle(fontFamily: "Nunito", fontSize: 14, color: textColor),
                                        h1: TextStyle(fontFamily: "Nunito", fontSize: 26, color: textColor),
                                        h2: TextStyle(fontFamily: "Nunito", fontSize: 24, color: textColor),
                                        h3: TextStyle(fontFamily: "Nunito", fontSize: 22, color: textColor),
                                        h4: TextStyle(fontFamily: "Nunito", fontSize: 20, color: textColor),
                                        h5: TextStyle(fontFamily: "Nunito", fontSize: 18, color: textColor),
                                        h6: TextStyle(fontFamily: "Nunito", fontSize: 16, color: textColor),
                                        a:  TextStyle(fontFamily: "Nunito", color: Colors.blue, decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                      );
                    },
                  )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 6),
                      child: Text(pojoTask.creator.displayName, style: theme(context).textTheme.subtitle2,),
                    ),
                  ],
                )
              ],
            ),
          ],
        )
      )
    );
  }
}