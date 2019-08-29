import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';

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
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  child: Text(group.name,
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700
                    ),),
                )
            )
        )
    );
  }
}
