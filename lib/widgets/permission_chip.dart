import 'package:flutter/material.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';


class PermissionChip extends StatefulWidget {

  Color backgroundColor = HazizzTheme.blue;

  Widget child;

  EdgeInsets padding = EdgeInsets.all(0);
  GroupPermissionsEnum permission;


  PermissionChip({Key key,  @required this.permission, this.padding,}) : super(key: key){
    padding ??= EdgeInsets.only(left: 9, right: 9, top: 2, bottom: 2);
    // backgroundColor ??= Colors.grey;
  }

  /*
  PermissionChip.createMode({Key key, this.groupId}) : super(key: key){
    mode = TaskMakerMode.create;
  }
  */

  @override
  _PermissionChip createState() => _PermissionChip();
}

class _PermissionChip extends State<PermissionChip> {

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(widget.permission == GroupPermissionsEnum.OWNER){
      return Chip(label: Text(locText(context, key: "owner"), style: TextStyle(fontWeight: FontWeight.w600),), backgroundColor: HazizzTheme.yellow, shadowColor: HazizzTheme.yellow, elevation: 4,);
    }else if(widget.permission == GroupPermissionsEnum.MODERATOR){
      return Chip(label: Text(locText(context, key: "moderator"), style: TextStyle(fontWeight: FontWeight.w600),), backgroundColor: HazizzTheme.yellow, shadowColor: HazizzTheme.yellow, elevation: 4,);
    }

    return Container();

    return GestureDetector(
      child:  Card(

          margin: EdgeInsets.only(top: 5, bottom: 5),
          color: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),

          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 10,
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          )
      ),
    );
  }
}
