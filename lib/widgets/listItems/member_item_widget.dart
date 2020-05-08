import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs_collection.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/permission_chip.dart';


class MemberItemWidget extends StatefulWidget{

  bool isMe = false;
  PojoUser member;
  GroupPermissionsEnum permission;
  Widget permissionChip = Container();
  Function onKicked;

  MemberItemWidget({@required this.member, @required this.permission,  @required this.onKicked, this.isMe}){
    isMe ??= false;
  }

  @override
  _MemberItemWidget createState() => new _MemberItemWidget();
}

class _MemberItemWidget extends State<MemberItemWidget>{

  GroupPermissionsEnum permission;


  @override
  void initState() {
    permission = widget.permission;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "hero_user${widget.member.id}",
        child:
        Container(
          height: 50,
          child: Card(
            margin: EdgeInsets.only(left: 5, right: 5, top: 2.2, bottom: 2.2),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              child: InkWell(
                  onTap: () async {

                    dynamic result = await showUserDialog(context, user: widget.member, permission: permission);

                    HazizzLogger.printLog("result from user view dialog: ${result.toString()}");

                    if(result is GroupPermissionsEnum){
                      setState(() {
                        permission = result;
                      });
                    }
                  },
                  child:
                  Padding(
                    padding: EdgeInsets.only(left: 6, /*top: 4, bottom: 4*/),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Text(widget.member.displayName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700
                        ),
                      ) ,

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: PermissionChip(permission: permission,),
                    ),
                    ],)
                  )
              )
          ),
        )
    );
  }
}
