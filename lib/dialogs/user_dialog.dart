import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/create_group_bloc.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/communication/pojos/PojoCreator.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_date_time.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/image_operations.dart';
import 'package:mobile/widgets/permission_chip.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';
import '../hazizz_theme.dart';
import '../request_sender.dart';
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

class _UserDialog extends State<UserDialog> {

  String encodedProfilePic;

  Image img;
  @override

  Future initState() {

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
                    if(value == "report"){
                      bool success = await showReportDialog(context, reportType: ReportTypeEnum.USER, id: widget.id, name: widget.displayName);
                      if(success != null && success){
                        Navigator.pop(context);
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
                Center(child:  PermissionChip(permission: widget.permission  ,)),

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
                )

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
                ),
              ),
            ]
        ),
        height: 200,
        width: 200);
  }
}