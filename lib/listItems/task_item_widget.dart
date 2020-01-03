import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/markdown_image_remover.dart';
import 'package:mobile/pages/tasks_page/view_task_page.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';

class TaskItemWidget extends StatefulWidget  {

  PojoTask originalPojoTask;

  Function onCompletedChanged;

  TaskItemWidget({Key key, this.originalPojoTask, this.onCompletedChanged}) : super(key: key);


  getTabName(BuildContext context){
    return locText(context, key: "grades");
  }

  @override
  _TaskItemWidget createState() => _TaskItemWidget();
}

class _TaskItemWidget extends State<TaskItemWidget> with TickerProviderStateMixin  {

//class TaskItemWidget extends StatelessWidget{

  PojoTask pojoTask;

  double opacity = 1;


  bool isCompleted;

  @override
  void initState() {

    pojoTask = widget.originalPojoTask;
    isCompleted = pojoTask.completed;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Color mainColor = Colors.grey;

    List<PojoTag> tags = [];
    if(pojoTask.tags != null && tags != null){
      tags.addAll(pojoTask.tags);
    }



    Widget highlightTag = Container();

    bool doBreak = false;

    List<Widget> tagWidgets = List();

    if(pojoTask.tags != null){
      for(PojoTag t in pojoTask.tags) {
        if(!doBreak){
          for(PojoTag defT in PojoTag.defaultTags) {
            if(defT.name == t.name) {
              tags.remove(t);

              mainColor = t.getColor();

              highlightTag = Container(
                // color: PojoType.getColor(widget.pojoTask.type),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12)),
                      color: mainColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 4, top: 2, right: 8, bottom: 4),
                    child: Text(t.getDisplayName(context),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                  )
              );
              doBreak = true;
              break;
            }
          }
        }else{
          break;
        }
      }
      for(PojoTag t in tags){
        tagWidgets.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey,

          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2, left: 6, right: 6),
            child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
          ),
        ));
      }
      tagWidgets.insert(0, highlightTag);
    }


    return  Opacity(
      opacity: opacity,
      child:
      Card(
        margin: EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: InkWell(
              onTap: () async {
                setState(() {
                  opacity = 1;
                });

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

              },
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0, right: 0,
                    child: Builder(
                      builder: (context){
                        IconData iconData;
                        if(isCompleted == null) return Container();
                        else if(isCompleted){
                          iconData = FontAwesomeIcons.checkSquare;
                        }else {
                          iconData = FontAwesomeIcons.square;
                        }
                        pojoTask.completed = isCompleted;



                        return IconButton(
                            icon: Icon(iconData),
                            onPressed: () async {
                              HazizzLogger.printLog("IM PRESSED HELLP!!!");
                              setState(() {
                                isCompleted = !isCompleted;
                              });
                              HazizzResponse hazizzResponse = await RequestSender().getResponse(SetTaskCompleted(p_taskId: widget.originalPojoTask.id, setCompleted: isCompleted));
                              if(hazizzResponse.isSuccessful){
                                widget.onCompletedChanged();
                              }else{
                                setState(() {
                                  isCompleted = !isCompleted;
                                });
                              }

                            }

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
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4,
                                children:  tagWidgets
                            ),
                          ),

                        ],
                      ),


                      Builder(
                        builder: (context){
                          if(pojoTask.subject == null){
                            return Container();
                          }
                          return Container(
                            // color: PojoType.getColor(widget.pojoTask.type),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12)),
                                  color: mainColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, top: 0, right: 8, bottom: 4),
                                child: Text(pojoTask.subject.name,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),),
                              )
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
                        padding: const EdgeInsets.only(right: 20, top: 0, bottom: 0),
                       // child: Text(markdownImageRemover(pojoTask.description), style: TextStyle(fontSize: 18),),
                        child: Builder(
                          builder: (context){
                            Color textColor = Colors.black;
                            if(HazizzTheme.currentThemeIsDark){
                              textColor = Colors.white;
                            }
                            return Markdown(data: pojoTask.description,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              imageBuilder: (uri){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                  child: Container(
                                    height: 60,
                                    child: ClipRRect(
                                        child: Image.network("https://drive.google.com/thumbnail?id=${uri.toString().split("?id=")[1]}"),
                                        borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                );
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
                            );
                          },
                        )

                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 1, right: 6),
                            child: Text(pojoTask.creator.displayName, style: theme(context).textTheme.subtitle,),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )

          )
      ),
    );

  }
}