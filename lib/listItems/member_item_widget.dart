import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';

import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';

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
                  padding: EdgeInsets.only(left: 6,top: 4, bottom: 4),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    Text(member.displayName,
                      style: TextStyle(
                          fontSize: 23, fontWeight: FontWeight.w700
                      ),
                    ) ,
                    PopupMenuButton(
                      icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                      onSelected: (value) async {
                        if(value == "report"){
                          bool success = await showReportDialog(context, reportType: ReportTypeEnum.USER, id: member.id, name: member.displayName);
                          if(success != null && success){

                          }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: "report",
                            child: Text(locText(context, key: "report"),
                              style: TextStyle(color: HazizzTheme.red),
                            ),
                          )
                        ];
                      },
                    ),

                  ],)
                )
            )
        )
    );
  }
}
