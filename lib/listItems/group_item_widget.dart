import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';

import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(group.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700
                        ),
                      ),
                      PopupMenuButton(
                        icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                        onSelected: (value) async {
                          if(value == "report"){
                            bool success = await showReportDialog(context, reportType: ReportTypeEnum.GROUP, id: group.id, name: group.name);
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
                      )


                    ],
                  )
                )
            )
        )
    );
  }
}
