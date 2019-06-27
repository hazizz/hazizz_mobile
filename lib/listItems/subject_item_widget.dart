import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';


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
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                      Text(subject.name,
                        style: TextStyle(
                          fontSize: 30
                        ),)
                  )
            )
        )
    );
  }
}
