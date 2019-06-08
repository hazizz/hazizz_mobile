import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:hazizz_mobile/communication/pojos/PojoUser.dart';
=======
import 'package:flutter_hazizz/communication/pojos/PojoUser.dart';
>>>>>>> 697a6e3b071e12017449a7ca76eb8a9feb3f5ba0

class MemberItemWidget extends StatelessWidget{

  PojoUser member;

  MemberItemWidget({this.member});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_user${member.id}",
        child:
        Card(
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
                    Text(member.displayName,
                      style: TextStyle(
                          fontSize: 30
                      ),)
                )
            )
        )
    );
  }
}
