import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mobile/dialogs/sure_to_delete_me_dialog.dart';
import 'package:mobile/dialogs/sure_to_delete_subject_dialog.dart';
import 'package:mobile/dialogs/sure_to_join_group_dialog.dart';
import 'package:mobile/dialogs/sure_to_leave_group_dialog.dart';
import 'package:mobile/dialogs/user_dialog.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/hero_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'choose_subject_dialog.dart';
import 'create_group_dialog.dart';
import 'kreta_profile_dialog.dart';
import 'subject_editor_dialog.dart';
import 'invite_link_dialog.dart';
import 'join_group_dialog.dart';
import 'kick_group_member_dialog.dart';


// 280 min width
class HazizzDialog extends Dialog{

  static const double buttonBarHeight = 48.0;

  final Widget header, content;

  final Widget actionButtons;

  final double height, width;

  HazizzDialog({this.header, this.content, this.actionButtons,@required this.height,@required this.width}){
  }

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
                   //   color: Theme.of(context).primaryColor
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
              //  Spacer(),

                //  SizedBox(height: 20.0),

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
    ));
  }
}

Future showJoinGroupDialog(BuildContext context,) async{
  // List<PojoGroup> data;
  var d = JoinGroupDialog();
  var result = showDialog(context: context, builder: (context2){
    return d;
  });
  return result;
}

Future showCreateGroupDialog(BuildContext context,) async{
  // List<PojoGroup> data;
  var d = CreateGroupDialog();
  bool result = await showDialog(context: context, builder: (context2){
    return d;
  });
  return result;
}

Future<PojoGroup> showDialogGroup(BuildContext context, {List<PojoGroup> data}) async{
 // List<PojoGroup> data;
  List<PojoGroup> groups_data = List();
  if(data == null) {
    HazizzResponse response = await RequestSender().getResponse(new GetMyGroups());

    if(response.isSuccessful){
      groups_data = response.convertedData;
    }
  }else{
    groups_data.addAll(data);
  }


  groups_data.insert(0, getEmptyPojoGroup(context));

  double groupsHeights;

  if(groups_data.length > 6){
    groupsHeights = 6 * 38.0;

  }else{
    groupsHeights = groups_data.length * 38.0;

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
          locText(context, key: "select_group"),
          style: TextStyle( fontWeight: FontWeight.w800, fontSize: 26),
         // maxFontSize: 28,
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
                if(groups_data.length <= 1){
                  return Text(locText(context, key: "not_member_of_groups"));
                }
                return Container();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groups_data.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                      onTap: (){
                        Navigator.pop(context, groups_data[index]);
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
                            child: Text( groups_data[index].name ,//   data[index].name,
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
       /* Builder(
          builder: (context){
            if(groups_data.length <= 1){
              return FlatButton(
                child: new Text(locText(context, key: "close").toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }
            return Container();
          },
        ),
        */
        FlatButton(
          child: new Text(locText(context, key: "close").toUpperCase()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );

  //return d;

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
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
  /*
  HazizzResponse hazizzResponse = await RequestSender().getResponse(GetGroupInviteLink(groupId: group.id));
  String inviteLink = "Waiting...";
  if(hazizzResponse.isSuccessful){
    inviteLink = hazizzResponse.convertedData;
  }else{
    return false;
  }

  HazizzDialog h = HazizzDialog(
      header:
      Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(locText(context, key: "invite_link_info", args: [group.name]), style: TextStyle(fontSize: 19),),
          )
      ),
      content: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(inviteLink, style: TextStyle(fontSize: 15),),
          )
      ),
      actionButtons:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
              child: Center(
                child: Text(
                  locText(context, key: "cancel").toUpperCase(),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
          FlatButton(
              child: Center(
                child: Text(locText(context, key: "share").toUpperCase(),),
              ),
              onPressed: () {
                HazizzLogger.printLog("share");

                Share.share(locText(context, key: "invite_to_group_text_title", args: [group.name, inviteLink]));
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
        ],
      ) ,height: 190,width: 200);

  return showDialog(context: context, barrierDismissible: true,
      builder: (BuildContext context) {
        return h;
      }
  );
  */
}


Future<PojoSubject> showDialogSubject(BuildContext context, {@required PojoGroup group, List<PojoSubject> data}) async{

  double height = 200;
  double width = 280;

  /*
  HazizzDialog d = HazizzDialog(height: height, width: width,
    header: Container(
      width: width,
      height: 40,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child:
        Text("Choose task type",
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          )
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
                    if(subjects_data.length <= 1){
                      return Text("No subject in this group");
                    }
                    return Container();
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: subjects_data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, subjects_data[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30, top: 4, bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Theme
                                      .of(context)
                                      .primaryColor
                              ),
                              width: width,
                              child: Center(
                                child: Text(
                                  subjects_data[index].name, //   data[index].name,
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
              ],
        ),
      ),
    ),
    actionButtons: Row(
      children: <Widget>[
        Builder(
          builder: (context){
            if(subjects_data.length == 1 && subjects_data[0].id == 0) {
              return FlatButton(
                child: new Text(locText(context, key: "add_subject")),
                onPressed: () async {
                  PojoSubject result = await showAddSubjectDialog(context, groupId: groupId);
                  if(result != null){
                    subjects_data.add(result);
                  }
                },
              );
          }
            return Container();
          },
        ),
        FlatButton(
          child: new Text(locText(context, key: "close")),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    ),
  );
  */

  //return d;

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return ChooseSubjectDialog(groupId: group.id, data: data,);
    },
  );
  return result;
}


Future<bool> showReportDialog(BuildContext context, {@required ReportTypeEnum reportType, @required int id, int secondId, @required String name}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return ReportDialog(reportType: reportType, id: id, secondId: secondId, name: name,);
    },
  );
  return result;
}




Future<void> showSureToJoinGroupDialog(BuildContext context, {@required int groupId}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return SureToJoinGroupDialog(groupId: groupId,);
    },
  );
  return result;
}

Future<bool> showSureToLeaveGroupDialog(BuildContext context, {@required int groupId}) async{

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return SureToLeaveGroupDialog(groupId: groupId,);
    },
  );
  return result;
}

Future<bool> showSureToDeleteMeDialog(BuildContext context) async{

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return SureToDeleteMeDialog();
    },
  );
  return result;
}




Future<bool> showSureToKickFromGroupDialog(BuildContext context, {@required int groupId, @required PojoUser pojoUser}) async{

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return KickGroupMemberDialog(groupId: groupId, user: pojoUser,);
    },
  );
  return result;
}


Future<PojoTag> showDialogTaskTag(BuildContext context, {List<PojoTag> except}) async{
  final List<PojoTag> defaultTags = PojoTag.defaultTags;

  final List<PojoTag> tagsToShow = List();

  final TextEditingController newTagController = TextEditingController();

  /*
  var d = JoinGroupDialog();
  var result = showDialog(context: context, builder: (context2){
    return d;
  });
  return result;
  */

  for(PojoTag defaultTag in defaultTags){
    bool foundDuplicate = false;
    for(PojoTag exceptTag in except){
      if(defaultTag.getName() == exceptTag.getName()){
        foundDuplicate = true;
        break;
      }
    }
    if(!foundDuplicate){
      tagsToShow.add(defaultTag);
    }

  }

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
        Text(locText(context, key: "select_tag"),
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

              inputFormatters:[
                LengthLimitingTextInputFormatter(20),
              ],
              style: TextStyle(fontSize: 20),
              onChanged: (String searchText){
                //   List<String> searchKeys = keys;
                /*
                List<String> nextSearchKeys = List();
                for(String s in keys){
                  if(s.toLowerCase().contains(searchText.toLowerCase())){
                    nextSearchKeys.add(s);
                  }
                }
                */
              },
              controller: newTagController,
              decoration: InputDecoration(
                suffix: IconButton(icon: Icon(FontAwesomeIcons.plus), onPressed: (){
                  if(newTagController.text.length >= 2 && newTagController.text.length <= 20){
                    Navigator.pop(context, PojoTag(name: newTagController.text));
                  }
                }),
                hintText: locText(context, key: "add_new_tag"),
                prefixIcon: Icon(FontAwesomeIcons.searchPlus),
                //  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
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
          child: new Text(locText(context, key: "close").toUpperCase()),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    ),
  );

  //return d;

  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return d;
    },
  );
  return result;
}

Future<dynamic> showUserDialog(context, { PojoUser user, PojoCreator creator, GroupPermissionsEnum permission}) {

  return showDialog(
    context: context,
    barrierDismissible: true,

    builder: (BuildContext context) {

      return UserDialog(creator: creator, user: user, permission: permission,);
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
            locText(context, key: "areyousure_delete_task"),
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
                  locText(context, key: "cancel").toUpperCase()
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
                  locText(context, key: "delete").toUpperCase(),
                  style: TextStyle(
                      color: HazizzTheme.warningColor),
                ),
              ),
              onPressed: () async {
                if(!pressed) {
                  pressed = true;
                  HazizzResponse response = await RequestSender().getResponse(
                      DeleteTask(taskId: taskId));
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
    return SureToDeleteSubjectDialog(groupId: groupId, subject: subject,);
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
                grade.grade == null ? "5" : grade.grade,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.black,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  grade.weight == null ? "100%" : "${grade.weight}%",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),

          ]
      ),
      backgroundColor: grade.color,
      radius: 50,
    );
  }

  Navigator.push(context, HeroDialogRoute(builder: (context){
    return HazizzDialog(
        header: Container(
          color: Theme.of(context).dialogBackgroundColor,
          height: 98,
          child: Stack(
            children: <Widget>[
              //  Container(color: Theme.of(context).dialogBackgroundColor,),
              Container(
                  height: 62.0,
                  color: Theme.of(context).primaryColor

              ),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 4),
                    child: Hero(
                      tag: grade,
                      flightShuttleBuilder: (context, animation, heroFlightDirection, context2, context3){
                        return getGradeAvatar();
                      },
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
              children:
              [

                Center(child: Text(grade.subject[0].toUpperCase() + grade.subject.substring(1), style: TextStyle(fontSize: 22), textAlign: TextAlign.center,) ),
                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text(locText(context, key: "topic") + ":", style: TextStyle(fontSize: 18)),
                    Expanded(child: Text(grade.topic == null ? "" : (grade.topic), style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
                  ],
                ),
                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text(locText(context, key: "grade_type") + ":", style: TextStyle(fontSize: 18)),
                    Builder(
                      builder: (context){
                        String gradeType = grade.gradeType;
                        if(gradeType.toLowerCase() == "midyear"){
                          gradeType = locText(context, key: "gradeType_midYear");
                        }else if(gradeType.toLowerCase() == "halfyear"){
                          gradeType = locText(context, key: "gradeType_halfYear");
                        }else if(gradeType.toLowerCase() == "endyear"){
                          gradeType = locText(context, key: "gradeType_endYear");
                        }
                        return Expanded(child: Text(gradeType, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,));
                      },
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(locText(context, key: "date") + ":", style: TextStyle(fontSize: 18),),
                    Expanded(child: Text(grade.creationDate == null ? "" : hazizzShowDateFormat(grade.creationDate), style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
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
                      child: Text(locText(context, key: "close").toUpperCase(),),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.transparent
                ),
              ),
            ]
        ),
        height: 250,
        width: 200);
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
          child: Text(locText(context, key: "welcome_to_group", args: [group.name]), style: TextStyle(fontSize: 22),),
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
                  locText(context, key: "ok").toUpperCase(),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.transparent
          ),
        ],
      ) ,height: height,width: width);

  return showDialog(context: context, barrierDismissible: true,
      builder: (BuildContext context) {
        return h;
      }
  );
}


Future showSubscribeToSubjectDialog(context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SubscribeToSubjectDialog();
    },
  );
}

Future showKretaProfileDialog(BuildContext context, PojoSession session){
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
      // return object of type Dialog
      return SchoolDialog(onPicked: onPicked, data: data);
    },
  );
}

Future<void> showClassDialog(context, {@required PojoClass pojoClass}) {
  Widget space = SizedBox(height: 5);

  pojoClass.subject = pojoClass.subject[0].toUpperCase() + pojoClass.subject.substring(1);

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


  HazizzDialog hazizzDialog = HazizzDialog(
    header:
    Container(
      height: headerHeight,
      color: Theme.of(context).primaryColor,
      child: Row(children: <Widget>[
        Container(
         // color: Theme.of(context).primaryColorDark,
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
    //  height: contentHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Builder(builder: (BuildContext context){

          List<Widget> rows = List();

          void addToColumn(Widget widget){
            rows.add(widget);
            if(rows.length != 0){
              rows.add(Spacer());
            //  rows.add(Divider());
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
                  Text(hazizzTimeOfDayToShow(pojoClass.startOfClass), style: TextStyle(fontSize: 22)),
                  Text("-", style: TextStyle(fontSize: 22)),
                  Text(hazizzTimeOfDayToShow(pojoClass.endOfClass), style: TextStyle(fontSize: 22)),
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
                Text("${locText(context, key: "thera_canceled").toUpperCase()}", style: TextStyle(fontSize: 24, color: HazizzTheme.red)),
              ],
            ));
          }

          addToColumn(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(locText(context, key: "class_name") + ":", style: TextStyle(fontSize: 18)),
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
                Text("${locText(context, key: "thera_standin")}:", style: TextStyle(fontSize: 18, color: HazizzTheme.red)),
                Expanded(child: Text(pojoClass.teacher, style: TextStyle(fontSize: 18,  color: HazizzTheme.red), textAlign: TextAlign.end,)),
              ],
            ));
          }else{
            addToColumn(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(locText(context, key: "teacher") + ":", style: TextStyle(fontSize: 18)),
                Expanded(child: Text(pojoClass.teacher == null ? "" : pojoClass.teacher, style: TextStyle(fontSize: 18), textAlign:TextAlign.end,),),
              ],
            ),);
          }

          addToColumn(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Text(locText(context, key: "room") + ":", style: TextStyle(fontSize: 18)),
              Expanded(child: Text(pojoClass.room == null ? "" : pojoClass.room, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
            ],
          ),);

          if(pojoClass.topic != null && pojoClass.topic != ""){
            addToColumn(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Text(locText(context, key: "topic") + ":", style: TextStyle(fontSize: 18)),
                Expanded(child: Text(pojoClass.topic, style: TextStyle(fontSize: 18), textAlign: TextAlign.end,)),
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
            child: Text(locText(context, key: "close").toUpperCase()),
            onPressed: (){
              Navigator.pop(context) ;
            },
          )
        ],
      ),
      height: height, width: width);

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return hazizzDialog;
      });
}

Future<bool> showIntroCancelDialog(context) async {
  Widget space = SizedBox(height: 5);

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
          Text(locText(context, key: "kreta_login_later"),
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
            child: Text(locText(context, key: "close").toUpperCase()),
            onPressed: (){
              Navigator.pop(context) ;
            },
          ),
          FlatButton(
            child: Text(locText(context, key: "ok").toUpperCase()),
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
      });
  return success;
}



Future<bool> showDialogSessionReauth(BuildContext context) async{

  /*
  var d = JoinGroupDialog();
  var result = showDialog(context: context, builder: (context2){
    return d;
  });
  return result;
  */

  double height = 80;
  double width = 360;

  HazizzDialog d = HazizzDialog(height: height, width: width,
    header: Container(
      width: width,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child:
        Text(locText(context, key: "you_can_only_use_active_account"),
            style: TextStyle(
              fontSize: 20.0,
            )
        ),


      ),
    ),
    content: Container(
      height: 40,
      child: Text(locText(context, key: "do_you_want_to_log_in_again")),
    ),
    actionButtons: Row(
      children: <Widget>[
        /*
        FlatButton(
          child: new Text("FIÓK ELTÁVOLITÁSA"),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        */
        FlatButton(
          child: new Text(locText(context, key: "no").toUpperCase()),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: new Text(locText(context, key: "yes").toUpperCase()),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    ),
  );

  //return d;

  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return d;
    },
  );
  return result;
}


Future<bool> showRegistrationDialog(context) async {
  return showDialog(context: context,
    barrierDismissible: true,
    builder: (context){
      return RegistrationDialog();
    }
  );
}


Future<void> showNewFeatureDialog(context) async {

  double height = 120;//240;
  double width = 200;

  HazizzDialog hazizzDialog = new HazizzDialog(
      header:
      Container(
       // height: height,
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
          child: Text( "${locText(context, key: "new_features")}:",
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
                        Expanded(child: Text("${locText(context, key: "new_feature_subject_subscribe")}", style: TextStyle(fontSize: 15.4),)),
                      ],
                    ),
                  ),

                  /*
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text("-"),
                      ),
                      Expanded(child: Text("${locText(context, key: "new_feature_notifications")}", style: TextStyle(fontSize: 15.4),)),
                    ],
                  ),
                  */
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
                child: Text(locText(context, key: "ok").toUpperCase()),
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

//TODO a good lookin dialog this is
/*Future<bool> showReview(context, review) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 150.0),
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.teal),
                        ),
                        Positioned(
                            top: 50.0,
                            left: 94.0,
                            child: Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                  image: DecorationImage(
                                      image:
                                      NetworkImage(review['reviewerPic']),
                                      fit: BoxFit.cover)),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          review['reviewMade'],
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    SizedBox(height: 15.0),
                    FlatButton(
                        child: Center(
                          child: Text(
                            'OKAY',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: Colors.teal),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.transparent
                    )
                  ],
                )));
      });
} */



