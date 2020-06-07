import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoCreator.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/defaults/pojo_group_empty.dart';
import 'package:mobile/dialogs/registration_dialog.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/dialogs/school_dialog.dart';
import 'package:mobile/dialogs/subject_dialog.dart';
import 'package:mobile/dialogs/subscribe_to_subjects_dialog.dart';
import 'package:mobile/dialogs/sure_to_delete_all_images_dialog.dart';
import 'package:mobile/dialogs/sure_to_delete_image_dialog.dart';
import 'package:mobile/dialogs/sure_to_delete_me_dialog.dart';
import 'package:mobile/dialogs/sure_to_delete_subject_dialog.dart';
import 'package:mobile/dialogs/sure_to_join_group_dialog.dart';
import 'package:mobile/dialogs/sure_to_leave_group_dialog.dart';
import 'package:mobile/dialogs/user_dialog.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/widgets/hero_dialog_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mobile/extension_methods/time_of_day_extension.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_ghost_grade_dialog.dart';
import 'choose_subject_dialog.dart';
import 'create_group_dialog.dart';
import 'grant_access_to_gdrive_dialog.dart';
import 'kreta_profile_dialog.dart';
import 'subject_editor_dialog.dart';
import 'invite_link_dialog.dart';
import 'join_group_dialog.dart';
import 'kick_group_member_dialog.dart';
import "package:mobile/extension_methods/string_first_upper_extension.dart";
import 'package:mobile/extension_methods/duration_extension.dart';

// 280 min width
class HazizzDialog extends Dialog{

  static const double buttonBarHeight = 48.0;
  final Widget header, content;
  final Widget actionButtons;
  final double height, width;

  HazizzDialog({
    this.header,
    this.content,
    this.actionButtons,
    @required this.height,
    @required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: height + buttonBarHeight,
        width: width,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: <Widget>[
            Container(
              //  height: 64.0,
              width: width*2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Center(child: header),
              ),
            ),

            Expanded(
              child: Builder(
                  builder: (BuildContext context){
                    if(content != null){
                      return content;
                    }
                    return Container();
                  }
              ),
            ),

            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  actionButtons,
                ],
              ),
            )
          ],
        )
      )
    );
  }
}

Future showJoinGroupDialog(BuildContext context,) async{
  var d = JoinGroupDialog();
  var result = showDialog(context: context, builder: (context2){
    return d;
  });
  return result;
}

Future showCreateGroupDialog(BuildContext context,) async{
  var d = CreateGroupDialog();
  bool result = await showDialog(context: context, builder: (context2){
    return d;
  });
  return result;
}

Future<PojoGroup> showDialogGroup(BuildContext context, {List<PojoGroup> data}) async{
  List<PojoGroup> groupsData = List();
  if(data == null) {
    HazizzResponse response = await RequestSender().getResponse(new GetMyGroups());

    if(response.isSuccessful){
      groupsData = response.convertedData;
    }
  }else{
    groupsData.addAll(data);
  }

  groupsData.insert(0, getEmptyPojoGroup(context));

  double groupsHeights;

  if(groupsData.length > 6){
    groupsHeights = 6 * 38.0;
  }else{
    groupsHeights = groupsData.length * 38.0;
  }

  double height = 80  + groupsHeights;
  double width = 280;

  HazizzDialog d = HazizzDialog(height: height, width: width,
    header: Container(
      width: width,
      height: 40,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child:
        AutoSizeText(
          localize(context, key: "select_group"),
          style: TextStyle( fontWeight: FontWeight.w800, fontSize: 26),
          maxLines: 1,
        ),
      ),
    ),
    content: Container(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          children: <Widget>[
            Builder(
              builder: (context){
                if(groupsData.length <= 1){
                  return Text(localize(context, key: "not_member_of_groups"));
                }
                return Container();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groupsData.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                      onTap: (){
                        Navigator.pop(context, groupsData[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 4,bottom: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Theme.of(context).primaryColor
                          ),
                          width: width,
                          child: Center(
                            child: Text( groupsData[index].name ,//   data[index].name,
                              style: TextStyle(
                                  fontSize: 26
                              ),
                              textAlign: TextAlign.center  ,
                            ),
                          ),
                        ),
                      )
                  );
                },
              ),
            ),
          ],
        )
      ),
    ),
    actionButtons: Row(
      children: <Widget>[
        FlatButton(
          child: new Text(localize(context, key: "close").toUpperCase()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return d;
    },
  );
  return result;
}

Future<bool> showInviteDialog(context, {@required PojoGroup group}) async {
  InviteLinkDialog dialog = InviteLinkDialog(group: group);
  return showDialog(context: context, barrierDismissible: true,
      builder: (BuildContext context) {
        return dialog;
      }
  );
}


Future<PojoSubject> showDialogSubject(BuildContext context, {@required PojoGroup group, List<PojoSubject> data}) async{
  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ChooseSubjectDialog(groupId: group.id, data: data,);
    },
  );
  return result;
}


Future<bool> showReportDialog(BuildContext context, {@required ReportTypeEnum reportType, @required int id, int secondId, @required String name}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportDialog(reportType: reportType, id: id, secondId: secondId, name: name,);
    },
  );
  return result;
}

Future<bool> showGrantAccessToGDRiveDialog(BuildContext context) async{

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return GrantAccessToGDRiveDialog();
    },
  );
  return result ?? false;
}

Future<bool> showSureToDeleteGDriveImageDialog(BuildContext context, {@required String fileId}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SureToDeleteHazizzImageDialog(fileId: fileId,);
    },
  );
  return result;
}

Future<bool> showSureToDeleteAllGDriveImageDialog(BuildContext context) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SureToDeleteAllHazizzImageDialog();
    },
  );
  return result ?? false;
}


Future<void> showSureToJoinGroupDialog(BuildContext context, {@required int groupId}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SureToJoinGroupDialog(groupId: groupId,);
    },
  );
  return result;
}

Future<bool> showSureToLeaveGroupDialog(BuildContext context, {@required int groupId}) async{

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SureToLeaveGroupDialog(groupId: groupId,);
    },
  );
  return result;
}

Future<bool> showSureToDeleteMeDialog(BuildContext context) async{

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SureToDeleteMeDialog();
    },
  );
  return result;
}




Future<bool> showSureToKickFromGroupDialog(BuildContext context, {@required int groupId, @required PojoUser pojoUser}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return KickGroupMemberDialog(groupId: groupId, user: pojoUser,);
    },
  );
  return result;
}


Future<PojoTag> showDialogTaskTag(BuildContext context, {List<PojoTag> except}) async{
  final List<PojoTag> defaultTags = PojoTag.defaultTags;

  final List<PojoTag> tagsToShow = List();

  final TextEditingController newTagController = TextEditingController();

  for(PojoTag defaultTag in defaultTags){
    bool foundDuplicate = false;
    for(PojoTag exceptTag in except){
      if(defaultTag.name  == exceptTag.name){
        foundDuplicate = true;
        break;
      }
    }
    if(!foundDuplicate){
      tagsToShow.add(defaultTag);
    }
  }

  bool autoFocus = tagsToShow.isEmpty;

  double height = 130.0 +  tagsToShow.length * 38;
  double width = 290;

  HazizzDialog d = HazizzDialog(height: height, width: width,
    header: Container(
      width: width,
      height: 40,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child:
        Text(localize(context, key: "select_tag"),
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w800,
            )
        ),
      ),
    ),
    content: Container(
      height: 240,
      child: Column(
        children: <Widget>[
          Container(
            height: 64,
            child: TextField(
              autofocus: autoFocus,
              inputFormatters:[
                LengthLimitingTextInputFormatter(20),
              ],
              style: TextStyle(fontSize: 20),
              controller: newTagController,
              decoration: InputDecoration(
                suffix: IconButton(icon: Icon(FontAwesomeIcons.plus), onPressed: (){
                  if(newTagController.text.length >= 2 && newTagController.text.length <= 20){
                    Navigator.pop(context, PojoTag(name: newTagController.text));
                  }
                }),
                hintText: localize(context, key: "add_new_tag"),
                prefixIcon: Icon(FontAwesomeIcons.searchPlus),
              )
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                itemCount: tagsToShow.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.pop(context, tagsToShow[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30, top: 4,bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: tagsToShow[index].getColor()
                        ),
                        width: width,
                        child: Center(
                          child: Text( tagsToShow[index].getDisplayName(context),//   data[index].name,
                            style: TextStyle(
                                fontSize: 26
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                },
              ),
            ),
          ),
        ],
      )
    ),
    actionButtons: Row(
      children: <Widget>[
        FlatButton(
          child: new Text(localize(context, key: "close").toUpperCase()),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    ),
  );

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return d;
    },
  );
  return result;
}

Future<dynamic> showUserInformationDialog(context, {PojoUser user, PojoCreator creator, GroupPermissionsEnum permission}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      if(user != null) return UserDialog.user(user: user, permission: permission);
      else return UserDialog.creator(creator: creator, permission: permission);
    }
  );
}

Future<dynamic> showSubjectDialog(context, { @required PojoSubject subject}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SubjectDialog(subject: subject,);
    }
  );
}

Future<bool> showDeleteTaskDialog(context, {@required int taskId}) async {

  double height = 80;
  double width = 200;

  bool success = false;

  bool pressed = false;

  HazizzDialog hazizzDialog = new HazizzDialog(
      header:
      Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          color: HazizzTheme.warningColor
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            localize(context, key: "areyousure_delete_task"),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      content:
      Container(),
      actionButtons:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
              child: Center(
                child: Text(
                  localize(context, key: "cancel").toUpperCase()
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
          FlatButton(
              child: Center(
                child: Text(
                  localize(context, key: "delete").toUpperCase(),
                  style: TextStyle(
                      color: HazizzTheme.warningColor),
                ),
              ),
              onPressed: () async {
                if(!pressed) {
                  pressed = true;
                  HazizzResponse response = await RequestSender().getResponse(
                      DeleteTask(pTaskId: taskId));
                  if(response.isSuccessful) {
                    success = true;
                  }
                  Navigator.of(context).pop();
                  pressed = false;
                }
              },
              color: Colors.transparent
          ),
        ],
      )
      ,height: height,width: width);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return hazizzDialog;
    }
  );
  return success;
}

Future<bool> showDeleteSubjectDialog(context, {@required int groupId, @required PojoSubject subject}) {
  return showDialog(context: context, barrierDismissible: true, builder: (context){
    return SureToDeleteSubjectDialog(subject: subject,);
  });
}

Future<PojoSubject> showAddSubjectDialog(context, {@required int groupId}) {
  return showDialog(context: context, barrierDismissible: true, builder: (context){
    return SubjectEditorDialog.create(groupId: groupId,);
  });
}

Future<PojoSubject> showEditSubjectDialog(context, {@required PojoSubject subject}) {
  return showDialog(context: context, barrierDismissible: true, builder: (context){
    return SubjectEditorDialog.edit(subject: subject);
  });
}


Future<Widget> showGradeDialog(context, {@required PojoGrade grade}) {
  Widget getGradeAvatar(){
    return CircleAvatar(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AutoSizeText(
              grade.grade == null ? "null" : grade.grade,
              maxLines: 1,
              style: TextStyle(
                fontSize: 58,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontFamily: "Nunito"
              ),
            ),
          ),
          if(grade.weight != null && grade.weight != 0) Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("${grade.weight}%",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Nunito"
                ),
              ),
            ),
          ),
        ]
      ),
      backgroundColor: grade.color,
      radius: 46,
    );
  }

  return Navigator.push(context, HeroDialogRoute(builder: (context){
    HazizzDialog hazizzDialog = HazizzDialog(
        header: Container(
          color: Theme.of(context).dialogBackgroundColor,
          child: Stack(
            children: <Widget>[
              Container(
                  height: 62.0,
                  color: Theme.of(context).primaryColor
              ),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 4),
                    child: Container(//Hero(
                      /* tag: grade,
                      flightShuttleBuilder: (context, animation, heroFlightDirection, context2, context3){
                        return getGradeAvatar();
                      },
                      */
                      child: getGradeAvatar(),
                    )
                ),
              ),
            ],
          ),
        ),
        content: Container(child:  Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
              children: [
                Center(child: Text(grade.subject.toUpperFirst(), style: TextStyle(fontSize: 22, height: 0.95), textAlign: TextAlign.center,) ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(localize(context, key: "topic") + ":", style: TextStyle(fontSize: 18)),
                    Expanded(child: Text(grade.topic == null ? "" : (grade.topic).toUpperFirst(),
                      style: TextStyle(fontSize: 18, height: 0.95), textAlign: TextAlign.end,)
                    ),
                  ],
                ),
                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text(localize(context, key: "grade_type") + ":", style: TextStyle(fontSize: 18)),
                    Builder(
                      builder: (context){
                        GradeTypeEnum gradeType = grade.gradeType;
                        String gradeTypeShow;
                        if(gradeType == GradeTypeEnum.MIDYEAR){
                          gradeTypeShow = localize(context, key: "gradeType_midYear");
                        }else if(gradeType == GradeTypeEnum.HALFYEAR){
                          gradeTypeShow = localize(context, key: "gradeType_halfYear");
                        }else if(gradeType == GradeTypeEnum.ENDYEAR){
                          gradeTypeShow = localize(context, key: "gradeType_endYear");
                        }
                        return Expanded(child: Text(gradeTypeShow, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,));
                      },
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(localize(context, key: "schedule_creation_date") + ":", style: TextStyle(fontSize: 18),),
                    Expanded(child: Text(grade.creationDate == null ? "" : grade.creationDate.hazizzShowDateFormat, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(localize(context, key: "date") + ":", style: TextStyle(fontSize: 18),),
                    Expanded(child: Text(grade.date == null ? "" : grade.date.hazizzShowDateFormat, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
                  ],
                ),
              ]
          ),
        ),),
        actionButtons: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: FlatButton(
                child: Center(
                  child: Text(localize(context, key: "close").toUpperCase(),),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.transparent
              ),
            ),
          ]
        ),
        height: 280,
        width: 200
    );
    return Hero(
      tag: grade,
      flightShuttleBuilder: (context, animation, heroFlightDirection, context2, context3){
        return hazizzDialog;
      },
      child: hazizzDialog,
    );
  }));
}

Future<bool> showJoinedGroupDialog(context, {@required PojoGroup group}) async {
  double width = 280;
  double height = 90;

  HazizzDialog h = HazizzDialog(
      header:
      Container(
        width: width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(localize(context, key: "welcome_to_group", args: [group.name]), style: TextStyle(fontSize: 22),),
        )
      ),
      content: Container(),
      actionButtons:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Center(
              child: Text(
                localize(context, key: "ok").toUpperCase(),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.transparent
          ),
        ],
      ), height: height,width: width);
  return showDialog(context: context, barrierDismissible: true,
    builder: (BuildContext context) {
      return h;
    }
  );
}


void showSubscribeToSubjectDialog(context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SubscribeToSubjectDialog();
    },
  );
}

void showKretaProfileDialog(BuildContext context, PojoSession session){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return KretaProfileDialog(session: session,);
    },
  );
}


void showSchoolsDialog(BuildContext context, {@required Function({String key, String value}) onPicked, @required Map data}) async{
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SchoolDialog(onPicked: onPicked, data: data);
    },
  );
}

Future<void> showClassDialog(context, {@required PojoClass pojoClass}) {
  pojoClass.subject = pojoClass.subject.toUpperFirst();

  double headerHeight = 50;
  double contentHeight = 220;
  double buttonBarHeight = HazizzDialog.buttonBarHeight;

  if(pojoClass.cancelled){
    contentHeight += 20;
  }

  double height = headerHeight + contentHeight + buttonBarHeight;
  double width = 340;
  int v = 20;
  if(pojoClass.topic == null){
    height -= v;
  }
  if(pojoClass.cancelled == null){
    height -= v;
  }
  if(pojoClass.standIn == null){
    height -= v;
  }


  return Navigator.push(context, HeroDialogRoute(builder: (context){
    HazizzDialog hazizzDialog = HazizzDialog(
        header:
        Container(
          height: headerHeight,
          color: Theme.of(context).primaryColor,
          child: Row(children: <Widget>[
            Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 2),
                  child: Text("${pojoClass.periodNumber}.", style: TextStyle(fontSize: 40)),
                )
            ),
            Expanded(
              child: Container(

                child: AutoSizeText("${pojoClass.subject}",
                  style: TextStyle(fontSize: 40),
                  maxLines: 1,
                  maxFontSize: 40,
                  minFontSize: 20,
                ),
              ),
            )
          ],),
        ),
        content:
        Container(
          child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Builder(builder: (BuildContext context){

                List<Widget> rows = List();

                void addToColumn(Widget widget){
                  rows.add(widget);
                  if(rows.length != 0){
                    rows.add(Spacer());
                  }

                }

                addToColumn(Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      color: Theme.of(context).primaryColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        Text(pojoClass.startOfClass.hazizzFormat, style: TextStyle(fontSize: 22)),
                        Text("-", style: TextStyle(fontSize: 22)),
                        Text(pojoClass.endOfClass.hazizzFormat, style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ));

                if(pojoClass.cancelled != null && pojoClass.cancelled){
                  addToColumn(Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[
                      Text("${localize(context, key: "thera_canceled").toUpperCase()}", style: TextStyle(fontSize: 24, color: HazizzTheme.red)),
                    ],
                  ));
                }

                addToColumn(Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(localize(context, key: "class_name") + ":", style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: Text(pojoClass.className == null ? "" : (pojoClass.className),
                        style: TextStyle(fontSize: 18), textAlign: TextAlign.end,),
                    ),
                  ],
                ));

                if(pojoClass.standIn != null && pojoClass.standIn){
                  addToColumn(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Text("${localize(context, key: "thera_standin")}:", style: TextStyle(fontSize: 18, color: HazizzTheme.red)),
                      Expanded(child: Text(pojoClass.teacher, style: TextStyle(fontSize: 18,  color: HazizzTheme.red), textAlign: TextAlign.end,)),
                    ],
                  ));
                }else{
                  addToColumn(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(localize(context, key: "teacher") + ":", style: TextStyle(fontSize: 18, height: 0.94)),
                      Expanded(child: Text(pojoClass.teacher == null ? "" : pojoClass.teacher, style: TextStyle(fontSize: 18, height: 0.94), textAlign:TextAlign.end,),),
                    ],
                  ),);
                }

                addToColumn(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text(localize(context, key: "room") + ":", style: TextStyle(fontSize: 18)),
                    Expanded(child: Text(pojoClass.room == null ? "" : pojoClass.room, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
                  ],
                ),);

                if(pojoClass.topic != null && pojoClass.topic != ""){
                  addToColumn(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Text(localize(context, key: "topic") + ":", style: TextStyle(fontSize: 18, height: 0.94)),
                      Expanded(child: Text(pojoClass.topic, style: TextStyle(fontSize: 18, height: 0.94), textAlign: TextAlign.end)),
                    ],
                  ));
                }
                return Container(height: 220,child: Column(mainAxisAlignment: MainAxisAlignment.end,children: rows,));
              }
              )
          ),
        ),
        actionButtons:
        Row(
          children: <Widget>[
            FlatButton(
              child: Text(localize(context, key: "close").toUpperCase()),
              onPressed: (){
                Navigator.pop(context) ;
              },
            )
          ],
        ),
        height: (pojoClass.topic == null || pojoClass.topic == "") ? height - 60 : height, width: width);
    return Hero(
      tag: pojoClass,
      flightShuttleBuilder: (context, animation, heroFlightDirection, context2, context3){
        return hazizzDialog;
      },

      child: hazizzDialog,
    );
  }));




  /*
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return hazizzDialog;
    }
  );
  */
}

Future<bool> showIntroCancelDialog(context) async {
  bool success = false;

  double height = 80;
  double width = 280;

  Container(
    height: height,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: HazizzTheme.warningColor),
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        "Are you sure you want to delete this task?",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
  );

  HazizzDialog hazizzDialog = HazizzDialog(
      header:
      Container(
        width: width,
        height: height,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text(localize(context, key: "kreta_login_later"),
            style: TextStyle(
              fontSize: 23.0,
            )
          ),
        ),
      ),
      content: Container(),
      actionButtons:
      Row(
        children: <Widget>[
          FlatButton(
            child: Text(localize(context, key: "close").toUpperCase()),
            onPressed: (){
              Navigator.pop(context) ;
            },
          ),
          FlatButton(
            child: Text(localize(context, key: "ok").toUpperCase()),
            onPressed: (){
              success = true;
              Navigator.pop(context) ;
            },
          )
        ],
      ),
      height: height, width: width);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return hazizzDialog;
    }
  );
  return success;
}



Future<bool> showDialogSessionReauth(BuildContext context) async{
  double height = 80;
  double width = 360;

  HazizzDialog d = HazizzDialog(height: height, width: width,
    header: Container(
      width: width,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child:
        Text(localize(context, key: "you_can_only_use_active_account"),
            style: TextStyle(
              fontSize: 20.0,
            )
        ),
      ),
    ),
    content: Container(
      height: 40,
      child: Text(localize(context, key: "do_you_want_to_log_in_again")),
    ),
    actionButtons: Row(
      children: <Widget>[
        FlatButton(
          child: new Text(localize(context, key: "no").toUpperCase()),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: new Text(localize(context, key: "yes").toUpperCase()),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    ),
  );

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return d;
    },
  );
  return result;
}


Future<bool> showRegistrationDialog(context) async {
  return showDialog(context: context,
    barrierDismissible: false,
    builder: (context){
      return RegistrationDialog();
    }
  );
}


Future<void> showNewFeatureDialog(context) async {
  double height = 120;
  double width = 200;

  HazizzDialog hazizzDialog = new HazizzDialog(
      header:
      Container(
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Text( "${localize(context, key: "new_features")}:",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      content: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Column(

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text("-"),
                        ),
                        Expanded(child: Text("${localize(context, key: "new_feature_subject_subscribe")}", style: TextStyle(fontSize: 15.4),)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actionButtons:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Center(
              child: Text(localize(context, key: "ok").toUpperCase()),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.transparent
          ),
        ],
      )
      ,height: height,width: width);

  await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return hazizzDialog;
      }
  );
}

Future<bool> showMarkdownInfo(context,) async {
  double width = MediaQuery.of(context).size.width * 0.8;
  double height = MediaQuery.of(context).size.height * 0.8;


  Markdown getMark(String text){
    Color textColor = Colors.black;
    if(HazizzTheme.currentThemeIsDark){
      textColor = Colors.white;
    }
    return Markdown(data: text,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        p:  TextStyle(fontFamily: "Nunito", fontSize: 20, color: textColor, ),
        h1: TextStyle(fontFamily: "Nunito", fontSize: 30, color: textColor),
        h2: TextStyle(fontFamily: "Nunito", fontSize: 28, color: textColor),
        h3: TextStyle(fontFamily: "Nunito", fontSize: 26, color: textColor),
        h4: TextStyle(fontFamily: "Nunito", fontSize: 24, color: textColor),
        h5: TextStyle(fontFamily: "Nunito", fontSize: 22, color: textColor),
        h6: TextStyle(fontFamily: "Nunito", fontSize: 20, color: textColor),
        a:  TextStyle(fontFamily: "Nunito", color: Colors.blue, decoration: TextDecoration.underline),

      ),
      onTapLink: (String url) async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
    );
  }

  HazizzDialog h = HazizzDialog(
      header:
      Container(
          width: width,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(localize(context, key: "markdown_info"), style: TextStyle(fontSize: 22),),
          )
      ),
      content: Container(
        child: ListView(
          children: <Widget>[
              Container(
              //  height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_h1")),
                    Spacer(),
                    Container(width: 100,child: getMark(localize(context, key: "markdown_info_h1")))
                  ],
                ),
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_h2")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_h2")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_h3")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_h3")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_h4")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_h4")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_h5")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_h5")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_h6")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_h6")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_a")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_a"))
                  )                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_ul")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_ul")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(localize(context, key: "markdown_info_ol")),
                    Spacer(),
                    Flexible(child: getMark(localize(context, key: "markdown_info_ol")))
                  ],
                ),

          ],
        ),
      ),
      actionButtons:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
              child: Center(
                child: Text(
                  localize(context, key: "close").toUpperCase(),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
        ],
      ) ,height: height,width: width);

  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: 200.milliseconds,
      pageBuilder: (BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation) {
        return h;
      });

}

Future<bool> showGiveawayDialog(context) async {

  void quit(){
    CacheManager.setSeenGiveaway();
    Navigator.pop(context);
  }

  HazizzDialog d = HazizzDialog(
    width: 350, height: 270,
    header: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 270,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: AutoSizeText(localize(context, key: "giveaway_title",).toUpperCase(),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
              maxFontSize: 30,
              minFontSize: 20,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    ),
    content: Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      child: Column(
        children: <Widget>[
          AutoSizeText(localize(context, key: "giveaway_description",),
            style: TextStyle(fontSize: 18),
            maxFontSize: 18,
            minFontSize: 16,
            maxLines: 7,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Megnézem".toUpperCase()),
                onPressed: () async {
                  String url = "https://www.facebook.com/notes/h%C3%A1zizz/h%C3%A1zizz-nyerem%C3%A9nyj%C3%A1t%C3%A9k/489579875054324/";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                  quit();
                 /* if (await canLaunch(fb_link)) {
                    await launch(fb_link);
                  }
                  */
                },
              )
            ],
          )
        ],
      )
    ),
    actionButtons: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(

          child: Text("bezárás".toUpperCase(), style: TextStyle(color: Colors.grey, fontSize: 12),),
          onPressed: (){
            quit();
          },
        ),
      ],
    )


  );
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return d;
      }
  );
}

Future<bool> showNoAssociatedEmail(BuildContext context) async {
  double width = 300;
  double height = 200;

  HazizzDialog h = HazizzDialog(
      header:
      Container(
          width: width,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: AutoSizeText(localize(context, key: "markdown_info"),
              maxLines: 2,
              maxFontSize: 24,
              minFontSize: 16,
              style: TextStyle(fontSize: 24),
            ),
          )
      ),
      content: Container(),
      actionButtons:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
              child: Center(
                child: Text(
                  localize(context, key: "close").toUpperCase(),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
          FlatButton(
              child: Center(
                child: Text(
                  localize(context, key: "add_email").toUpperCase(),
                ),
              ),
              onPressed: () async {
                const String url = "https://www.facebook.com/help/162801153783275";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }

                Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
        ],
      ) ,height: height,width: width);

  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return h;
      }
  );
}

Future<PojoGrade> showAddGradeDialog(context, {@required String subject}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddGradeDialog(subject: subject);
    },
  );
}
