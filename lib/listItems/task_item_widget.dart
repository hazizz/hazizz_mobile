import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoType.dart';
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
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    // color: PojoType.getColor(widget.pojoTask.type),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                                          color: PojoType.getColor(widget.pojoTask.type)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4, top: 4, right: 8, bottom: 6),
                                        child: Text(widget.pojoTask.type.name, style: TextStyle(fontSize: 18),),
                                      )
                                  ),

                                  Builder(
                                    builder: (BuildContext context){
                                      if(widget.pojoTask.subject != null) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            // color: PojoType.getColor(widget.pojoTask.type),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                  color: PojoType.getColor(widget.pojoTask.type)
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

                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, right: 6),
                                    child: Text(widget.pojoTask.creator.displayName, style: theme(context).textTheme.subtitle,),
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

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(widget.pojoTask.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                  ),
                                ]
                              ),

                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 2, bottom: 10),
                                  child: Text(widget.pojoTask.description, style: TextStyle(fontSize: 16),),
                                ),
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
