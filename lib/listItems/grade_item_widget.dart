import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGrade.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/pages/ViewTaskPage.dart';

class GradeItemWidget extends StatelessWidget{


  PojoGrade pojoGrade;

  GradeItemWidget({this.pojoGrade});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "hero_task${pojoGrade.subject}",
      child:
        Card(
            elevation: 5,
            child: InkWell(
                onTap: () {
                  print("tap tap");
             //     Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTaskPage.fromPojo(pojoTask: pojoTask)));
                },
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Chip(
                              label: Text(
                                " ${pojoGrade.grade} ",

                              ),
                              backgroundColor: Colors.green,//PojoType.getColor(pojoTask.type),
                            ),

                          //  Text(pojoTask.subject != null ? pojoTask.subject.name : ""),
                          //  Text(pojoTask.title),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(pojoGrade.weight),
                        )
                      ],
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child:
                        Text(pojoGrade.creationDate.toString())
                    )
                  ],
                )
            )
        )
    );
  }
}
