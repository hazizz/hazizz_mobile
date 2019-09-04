import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/permission_chip.dart';

import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';

class MemberItemWidget extends StatelessWidget{

  PojoUser member;
  GroupPermissionsEnum permission;
  Widget permissionChip = Container();

  MemberItemWidget({@required this.member, @required this.permission}){

  }

  @override
  Widget build(BuildContext context) {



    return Hero(
        tag: "hero_user${member.id}",
        child:
        Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            child: InkWell(
                onTap: () async {

                  await showUserDialog(context, user: member, permission: permission);
                  print("tap tap");
                  //   Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTaskPage.fromPojo(pojoTask: pojoTask)));
                },
                child:
                Padding(
                  padding: EdgeInsets.only(left: 6, /*top: 4, bottom: 4*/),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                    Text(member.displayName,
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700
                      ),
                    ) ,

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: PermissionChip(permission: permission,),
                  ),
                    Spacer(),

                    BlocBuilder(
                      bloc: GroupBlocs().myPermissionBloc,
                      builder: (context, state){


                        List<PopupMenuEntry> entries = [
                          PopupMenuItem(
                            value: "report",
                            child: Text(locText(context, key: "report"),
                              style: TextStyle(color: HazizzTheme.red),
                            ),
                          ),
                        ];

                        if(state is MyPermissionSetState){
                          if(state.permission == GroupPermissionsEnum.MODERATOR || state.permission == GroupPermissionsEnum.OWNER){
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
                              bool success = await showReportDialog(context, reportType: ReportTypeEnum.USER, id: member.id, name: member.displayName);
                              if(success != null && success){

                              }
                            }else if(value == "kick"){
                              bool success = await showReportDialog(context, reportType: ReportTypeEnum.USER, id: member.id, name: member.displayName);
                              if(success != null && success){

                              }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return entries;
                          },
                        );
                      },
                    )

                  ],)
                )
            )
        )
    );
  }
}
