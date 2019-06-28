import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:mobile/communication/pojos/PojoGroup.dart';
=======
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc

class GroupItemWidget extends StatelessWidget{

  PojoGroup group;

  GroupItemWidget({this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              print("tap tap");
              Navigator.popAndPushNamed(context, "/group/groupId", arguments: group);
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
    );
  }
}
