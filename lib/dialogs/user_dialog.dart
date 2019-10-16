import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/create_group_bloc.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/communication/pojos/PojoCreator.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_date_time.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/group_types_enum.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/permission_chip.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';
import 'dialogs.dart';

class UserDialog extends StatefulWidget {

  GroupPermissionsEnum permission;

  UserDialog({PojoUser user, PojoCreator creator, this.permission}){
    if(user != null){
      username = user.username;
      displayName = user.displayName;
      registrationDate = user.registrationDate;
      id = user.id;
    }else{
      username = creator.username;
      displayName = creator.displayName;
      registrationDate = creator.registrationDate;
      id = creator.id;
    }
  }

  int id;
  String username;
  String displayName;
  HazizzDateTime registrationDate;
  
  
  @override
  _UserDialog createState() => new _UserDialog();
}

enum PromotableTo{
  MODERATOR,
  USER,
  NONE
}

class _UserDialog extends State<UserDialog> {

  String encodedProfilePic;

  GroupPermissionsEnum permission;

  GroupPermissionsEnum myPermission;

  PromotableTo promotableTo = PromotableTo.NONE;

  Image img;

  @override
  Future initState() {
    permission = widget.permission;
    if(permission == GroupPermissionsEnum.MODERATOR){
      promotableTo = PromotableTo.USER;
    }else if(permission == GroupPermissionsEnum.USER){
      promotableTo = PromotableTo.MODERATOR;
    }

    myPermission = GroupBlocs().myPermissionBloc.myPermission;


    RequestSender().getResponse(GetUserProfilePicture.full(userId: widget.id)).then((HazizzResponse hazizzResponse){
      if(hazizzResponse.isSuccessful){
        encodedProfilePic = hazizzResponse.convertedData;

        Uint8List profilePictureBytes = ImageOpeations.fromBase64ToBytesImage(encodedProfilePic);
       // WidgetsBinding.instance.addPostFrameCallback((_) =>
          setState(() {
            img = Image.memory(profilePictureBytes);
          });
       // );


      }
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    List<PopupMenuEntry> popupMenuItems = [

    ];

    GroupPermissionsEnum myPermission = GroupBlocs().myPermissionBloc.myPermission;
   // GroupPermissionsEnum myId = ;


    if((myPermission == GroupPermissionsEnum.OWNER || myPermission == GroupPermissionsEnum.MODERATOR)) {
      if(permission == GroupPermissionsEnum.USER) {
        popupMenuItems.add(PopupMenuItem(
          value: "promote_to_moderator",
          child: Text(locText(context, key: "promote_to_moderator"),),
        ));
      }else if(permission == GroupPermissionsEnum.MODERATOR && myPermission == GroupPermissionsEnum.OWNER) {
        popupMenuItems.add(PopupMenuItem(
          value: "promote_to_user",
          child: Text(locText(context, key: "promote_to_user"),),
        ));
      }
      
      if(myPermission == GroupPermissionsEnum.OWNER){
        popupMenuItems.add(PopupMenuItem(
          value: "kick",
          child: Text(locText(context, key: "kick"),),
        ));
      }else if(myPermission == GroupPermissionsEnum.MODERATOR){
        if(permission == GroupPermissionsEnum.USER) {
          popupMenuItems.add(PopupMenuItem(
            value: "kick",
            child: Text(locText(context, key: "kick")))
          );
        }
      }
    }
    popupMenuItems.add(
      PopupMenuItem(
        value: "report",
        child: Text(locText(context, key: "report"),
          style: TextStyle(color: HazizzTheme.red),
        ),
      )
    );
    
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

              Positioned(
                right: 0,
                top: 0,
                child: PopupMenuButton(
                  icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                  onSelected: (value) async {
                    if(value == "promote_to_moderator"){
                      HazizzResponse hazizzResponse = await RequestSender().getResponse(PromoteMember.toModerator(p_groupId: GroupBlocs().group.id, p_userId: widget.id));
                      setState(() {
                        permission = GroupPermissionsEnum.MODERATOR;
                      });
                      if(hazizzResponse.isSuccessful){

                      }else{
                        setState(() {
                          permission = GroupPermissionsEnum.USER;
                        });
                      }
                    }else if(value == "promote_to_user"){
                      HazizzResponse hazizzResponse = await RequestSender().getResponse(PromoteMember.toUser(p_groupId: GroupBlocs().group.id, p_userId: widget.id));
                      setState(() {
                        permission = GroupPermissionsEnum.USER;
                      });
                      if(hazizzResponse.isSuccessful){

                      }else{
                        setState(() {
                          permission = GroupPermissionsEnum.MODERATOR;
                        });
                      }
                    }
                    else if(value == "report"){
                      bool success = await showReportDialog(context, reportType: ReportTypeEnum.USER, id: widget.id, name: widget.displayName);
                      if(success != null && success){
                        showReportSuccessFlushBar(context, what: locText(context, key: "user"));

                        Navigator.pop(context, permission);

                      }
                    }

                    else if(value == "kick"){
                      bool success = await showSureToKickFromGroupDialog(context, groupId: GroupBlocs().group.id, pojoUser: PojoUser(id: widget.id, displayName: widget.displayName, username: widget.username, registrationDate: DateTime(2000)));
                      if(success != null && success){
                        GroupBlocs().groupMembersBloc.dispatch(FetchData());
                      }
                    }
                    
                  },
                  itemBuilder: (BuildContext context) {
                    return popupMenuItems;
                  },
                ),
              ),

              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 4),
                    child: CircleAvatar(
                      child: Builder(builder: (_){
                        if(img != null){
                          return Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: img.image,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: new BorderRadius.all(const Radius.circular(200.0)),
                            ),
                          );
                        }
                        return Center(child: Text(locText(context, key: "loading")),);
                      }
                      ),
                   //   backgroundColor: Theme.of(context).primaryColorDark,
                      radius: 44,
                    )
                ),
              ),
            ],
          ),
        ),
        content: Container(child:  Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
              children:
              [
                Center(child: Text(widget.displayName, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,) ),
                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                  //  Text(locText(context, key: "username") + ":", style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(widget.username, style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)),
                  ],
                ),
                Builder(
                  builder: (_){
                    if(widget.registrationDate != null){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text(locText(context, key: "registrationDate") + ":", style: TextStyle(fontSize: 20)),
                          Expanded(child: Text(widget.registrationDate.hazizzShowDateFormat(), style: TextStyle(fontSize: 20), textAlign: TextAlign.end,)),
                        ],
                      );
                    }
                    return Container();


                  },
                ),
                Center(child:  PermissionChip(permission: permission  ,)),


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
                    Navigator.pop(context, permission);
                  },
                ),
              ),
            ]
        ),
        height: 200,
        width: 200);
  }
}