import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';

class MemberItemWidget extends StatelessWidget{

  PojoUser member;

  MemberItemWidget({this.member});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_user${member.id}",
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
                  padding: EdgeInsets.only(left: 6),
                  child:
                  Text(member.displayName,
                    style: TextStyle(
                        fontSize: 30
                    ),
                  )
                )
            )
        )
    );
  }
}
