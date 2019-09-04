import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/pages/view_task_page.dart';

import '../hazizz_localizations.dart';

import '../hazizz_theme.dart';

class TaskItemWidget extends StatefulWidget  {

  PojoTask pojoTask;

  TaskItemWidget({Key key, this.pojoTask}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "grades");
  }

  @override
  _TaskItemWidget createState() => _TaskItemWidget();
}

class _TaskItemWidget extends State<TaskItemWidget> with TickerProviderStateMixin  {

//class TaskItemWidget extends StatelessWidget{

  double opacity = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


      List<PojoTag> tags = List();
      tags.addAll(widget.pojoTask.tags);



      Widget highlightTag = Container();

      bool doBreak = false;
      for(PojoTag t in widget.pojoTask.tags) {
        if(!doBreak){
          for(PojoTag defT in PojoTag.defaultTags) {
            if(defT.name == t.name) {
              tags.remove(t);

              highlightTag = Container(
                // color: PojoType.getColor(widget.pojoTask.type),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12)),
                      color: t.getColor()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 4, top: 4, right: 8, bottom: 6),
                    child: Text(t.getDisplayName(context),
                      style: TextStyle(fontSize: 18),),
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

      List<Widget> tagWidgets = List();
      for(PojoTag t in tags){
        tagWidgets.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey,

          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2, left: 6, right: 6),
            child: Text(t.getDisplayName(context)),
          ),
        ));
      }


      /*
      if(widget.pojoTask.subject != null) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            // color: PojoType.getColor(widget.pojoTask.type),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  color: widget.pojoTask.tags[0].getColor()
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 6),
                child: Text(widget.pojoTask.subject.name,
                  style: TextStyle(fontSize: 18),
                ),
              )
          ),
        );
      }
      */

      tagWidgets.insert(0, highlightTag);



      return  Opacity(
        opacity: opacity,
          child:
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              child: InkWell(
                  onTap: () {
                    print("tap tap");

                    setState(() {
                      opacity = 1;
                    });

                    Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTaskPage.fromPojo(pojoTask: widget.pojoTask)));
                  },
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0, right: 0,
                        child: Builder(
                          builder: (context){
                            IconData iconData = FontAwesomeIcons.square;
                            if(widget.pojoTask.completed){
                              iconData = FontAwesomeIcons.checkSquare;
                            }
                            return IconButton(
                                icon: Icon(iconData),
                                onPressed: () async {
                                }
                            );
                          },
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[ /*
                        Row(
                          children: <Widget>[
                           // highlightTag,
                            /*
                            Builder(builder: (context){


                              for(PojoTag t in widget.pojoTask.tags){
                                for(PojoTag defT in PojoTag.defaultTags){
                                  if(defT.name == t.name){
                                    tagWidgets.remove(t);

                                    return Container(
                                      // color: PojoType.getColor(widget.pojoTask.type),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                                            color: t.getColor()
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4, top: 4, right: 8, bottom: 6),
                                          child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 18),),
                                        )
                                    );
                                  }
                                }
                              }

                              return Container();


                            }),
                            */

                            /*
                            Builder(
                              builder: (BuildContext context){
                                if(widget.pojoTask.subject != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      // color: PojoType.getColor(widget.pojoTask.type),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                            color: widget.pojoTask.tags[0].getColor()
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 6),
                                          child: Text(widget.pojoTask.subject.name,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )
                                    ),
                                  );
                                }else{return Container();}
                              },
                            ),
                            */

                            Wrap(
                              spacing: 2,
                              children:  tagWidgets
                            ),




                            // Text(widget.pojoTask.subject != null ? widget.pojoTask.subject.name : "", style: TextStyle(fontSize: 18),),
                            /*
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(widget.pojoTask.title, style: TextStyle(fontSize: 18),),
                    ),
                    */
                          ],
                        ),
                        */
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

                          Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(widget.pojoTask.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                                ),
                              ]
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                            child: Text(widget.pojoTask.description, style: TextStyle(fontSize: 18),),
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 1, right: 6),
                                child: Text(widget.pojoTask.creator.displayName, style: theme(context).textTheme.subtitle,),
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
