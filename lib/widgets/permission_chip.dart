import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/theme/hazizz_theme.dart';


class PermissionChip extends StatefulWidget {

  final Color backgroundColor = HazizzTheme.blue;

  final EdgeInsets padding ;
  final GroupPermissionsEnum permission;

  PermissionChip({Key key,
    @required this.permission,
    this.padding = const EdgeInsets.only(left: 9, right: 9, top: 2, bottom: 2),})
  : super(key: key);

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
      return Chip(label: Text(localize(context, key: "owner"), style: TextStyle(fontWeight: FontWeight.w700),), backgroundColor: HazizzTheme.yellow, shadowColor: HazizzTheme.yellow, elevation: 4,);
    }else if(widget.permission == GroupPermissionsEnum.MODERATOR){
      return Chip(label: Text(localize(context, key: "moderator"), style: TextStyle(fontWeight: FontWeight.w700),), backgroundColor: Colors.deepOrangeAccent, shadowColor: Colors.deepOrangeAccent, elevation: 4,);
    }

    return Container();
  }
}
