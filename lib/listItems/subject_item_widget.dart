import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/flushbars.dart';

import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';


class SubjectItemWidget extends StatelessWidget{

  PojoSubject subject;

  SubjectItemWidget({this.subject});


  @override
  Widget build(BuildContext context) {


    return Hero(
        tag: "hero_subject${subject.id}",
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
                      padding: EdgeInsets.only(left: 6, /* top: 4, bottom: 4*/),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Text(subject.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700
                        ),),

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
                                    value: "delete",
                                    child: Text(locText(context, key: "delete"),
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
                                  bool success = await showReportDialog(context, reportType: ReportTypeEnum.SUBJECT, id: subject.id, secondId: GroupBlocs().group.id, name: subject.name);
                                  if(success != null && success){
                                    showReportSuccess(context, what: locText(context, key: "subject"));
                                  }
                                }else if(value == "delete"){
                                  bool success = await showDeleteSubjectDialog(context, groupId: GroupBlocs().group.id, subject: subject);
                                  if(success != null && success){
                                    showDeleteWasSuccessful(context, what: "${subject.name} ${locText(context, key: "subject")}");
                                    GroupBlocs().groupSubjectsBloc.dispatch(FetchData());
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
