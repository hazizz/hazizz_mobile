import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';


class SubjectItemWidget extends StatelessWidget{

  PojoSubject subject;

  SubjectItemWidget({this.subject});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_subject${subject.id}",
        child:
        Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            child: InkWell(
                onTap: () {
                  print("tap tap");
               //   Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTaskPage.fromPojo(pojoTask: pojoTask)));
                },
                child:
                  Padding(
                      padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
                      child:
                      Text(subject.name,
                        style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700
                        ),)
                  )
            )
        )
    );
  }
}
