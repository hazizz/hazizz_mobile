import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/widgets/flushbars.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';

class GroupItemWidget extends StatelessWidget{

  final PojoGroup group;

  GroupItemWidget({this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, "/group/groupId", arguments: group);
            },
            child:
            Align(
              alignment: Alignment.centerLeft,
              child:
              Padding(
                padding: const EdgeInsets.only(left: 8,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(group.name,
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                      onSelected: (value) async {
                        if(value == "report"){
                          bool success = await showReportDialog(context, reportType: ReportTypeEnum.GROUP, id: group.id, name: group.name);
                          if(success != null && success){
                            showReportSuccessFlushBar(context, what: localize(context, key: "group"));

                          }
                        }else if(value == "leave"){
                          bool success = await showSureToLeaveGroupDialog(context, groupId: group.id);
                          if(success != null && success){
                            Navigator.pop(context);
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: "report",
                            child: Text(localize(context, key: "report"),
                              style: TextStyle(color: HazizzTheme.red),
                            ),
                          ),
                          PopupMenuItem(
                            value: "leave",
                            child: Text(localize(context, key: "leave"),
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
