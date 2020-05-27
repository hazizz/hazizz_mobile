import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dialog_collection.dart';

class KickGroupMemberDialog extends StatefulWidget {

  final int groupId;
  final PojoUser user;

  KickGroupMemberDialog({@required this.groupId, @required this.user});

  @override
  _KickGroupMemberDialog createState() => new _KickGroupMemberDialog();
}

class _KickGroupMemberDialog extends State<KickGroupMemberDialog> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  static const double width = 300;
  static const double height = 90;

  final double searchBarHeight = 50;

  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
        header: Container(
          width: width,
          height: height,
          color: HazizzTheme.red,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child:
            Center(
              child: Builder(builder: (context){
                if(!isLoading){
                  return Text(localize(context, key: "areyousure_to_kick_from_group", args: [widget.user.displayName]  ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    )
                  );
                }
                return Center(child: Text(localize(context, key: "loading"), style: TextStyle(fontSize: 20),));
              }),
            )
          ),
        ),
        content: Container(),
        actionButtons: Builder(builder: (context){

          if(!isLoading){
            return Row(children: <Widget>[
              FlatButton(
                child: Text(localize(context, key: "no").toUpperCase(),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(localize(context, key: "yes").toUpperCase(),),
                onPressed: () async {

                  setState(() {
                    isLoading = true;
                  });
                  HazizzResponse hazizzResponse = await RequestSender().getResponse(KickGroupMember(p_groupId: widget.groupId, p_userId: widget.user.id));


                  if(hazizzResponse.isSuccessful){
                    Navigator.pop(context, true);
                  }else{
                  }
                  setState(() {
                    isLoading = false;
                  });

                },
              )
            ],);
          }
          return Container();

        })
    );
    return dialog;
  }
}