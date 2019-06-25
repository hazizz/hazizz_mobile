import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';

class GroupItemWidget extends StatelessWidget{

  PojoGroup group;

  GroupItemWidget({this.group});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_user${group.id}",
        child:
        Card(
            elevation: 5,
            child: InkWell(
                onTap: () {
                  print("tap tap");
                  Navigator.popAndPushNamed(context, "/group/groupId", arguments: group.id);
                },
                child:
                Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Text(group.name,
                      style: TextStyle(
                          fontSize: 30
                      ),)
                )
            )
        )
    );
  }
}
