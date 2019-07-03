import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoType.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/pages/ViewTaskPage.dart';

class TaskItemWidget extends StatelessWidget{


  PojoTask pojoTask;

  TaskItemWidget({this.pojoTask});

  @override
  Widget build(BuildContext context) {
    return Hero(
    tag: "hero_task${pojoTask.id}",
        child:
      Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
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
                      Container(
                         // color: PojoType.getColor(pojoTask.type),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                            color: PojoType.getColor(pojoTask.type)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4, top: 4, right: 8, bottom: 6),
                            child: Text(pojoTask.type.name, style: TextStyle(fontSize: 18),),
                          )
                      ),
                      Text(pojoTask.subject != null ? pojoTask.subject.name : "", style: TextStyle(fontSize: 18),),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(pojoTask.title, style: TextStyle(fontSize: 18),),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Text(pojoTask.description, style: TextStyle(fontSize: 16),),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child:
                    Text(pojoTask.creator.displayName, style: TextStyle(fontSize: 16),)
              )
            ],
          )
        )
      )
    );
  }
}
