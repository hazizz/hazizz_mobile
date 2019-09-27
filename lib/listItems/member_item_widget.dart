import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/permission_chip.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';


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
        Card(
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
                  //   Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTaskPage.fromPojo(pojoTask: pojoTask)));
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

                    /*
                    Spacer(),

                    BlocBuilder(
                      bloc: GroupBlocs().myPermissionBloc,
                      builder: (context, state){

                        if(widget.isMe){
                          return Container();
                        }

                        List<PopupMenuEntry> entries = [
                          PopupMenuItem(
                            value: "report",
                            child: Text(locText(context, key: "report"),
                              style: TextStyle(color: HazizzTheme.red),
                            ),
                          ),
                        ];
                        if(state is MyPermissionSetState){
                          if((state.permission == GroupPermissionsEnum.MODERATOR || state.permission == GroupPermissionsEnum.OWNER)
                              && permission != GroupPermissionsEnum.OWNER){
                            entries.add(PopupMenuItem(
                              value: "kick",
                              child: Text(locText(context, key: "kick"),
                                style: TextStyle(color: HazizzTheme.red),
                              ),
                            ),
                            );
                          }
                        }
                        return PopupMenuButton(
                          icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                          onSelected: (value) async {
                            if(value == "report"){
                              bool success = await showReportDialog(context, reportType: ReportTypeEnum.USER, id: widget.member.id, name: widget.member.displayName);
                              if(success != null && success){
                                showReportSuccessFlushBar(context, what: locText(context, key: "user"));

                              }
                            }else if(value == "kick"){
                              bool success = await showSureToKickFromGroupDialog(context, groupId: GroupBlocs().group.id, pojoUser: widget.member);
                              if(success != null && success){
                                widget.onKicked();
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return entries;
                          },
                        );
                      },
                    )
                      */
                  ],)
                )
            )
        )
    );
  }
}
