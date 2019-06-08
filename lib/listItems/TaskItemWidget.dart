import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/pages/ViewTaskPage.dart';

class TaskItemWidget extends StatelessWidget{


  PojoTask pojoTask;

  TaskItemWidget({this.pojoTask});

  @override
  Widget build(BuildContext context) {
    return Hero(
    tag: "hero_task${pojoTask.id}",
        child:
      Card(
        elevation: 5,
        child: InkWell(
          onTap: () {
            print("tap tap");
            Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTaskPage.fromPojo(pojoTask: pojoTask)));
          },
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Chip(
                          label: Text(
                            " ${pojoTask.type.name} ",

                          ),
                          backgroundColor: PojoType.getColor(pojoTask.type),
                        labelPadding: EdgeInsets.only(),
                      ),

                      Text(pojoTask.subject != null ? pojoTask.subject.name : ""),
                      Text(pojoTask.title),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(pojoTask.description),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child:
                    Text(pojoTask.creator.displayName)
              )
            ],
          )
        )
      )
    );
  }
}
