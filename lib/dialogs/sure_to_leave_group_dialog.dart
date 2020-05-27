import 'package:flutter/material.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dialog_collection.dart';

class SureToLeaveGroupDialog extends StatefulWidget {

  final int groupId;

  SureToLeaveGroupDialog({@required this.groupId});

  @override
  _SureToLeaveGroupDialog createState() => new _SureToLeaveGroupDialog();
}

class _SureToLeaveGroupDialog extends State<SureToLeaveGroupDialog> {

  String groupName;

  bool isLoading = false;

  bool isMember = false;

  bool someThingWentWrong = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    super.initState();
  }

  final double width = 300;
  final double height = 90;


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
                  return Text(localize(context, key: "areyousure_leave_group"),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )
                  );
                }),
              )
          ),
        ),
        content: Container(),
        actionButtons: Builder(builder: (context){

          return Row(children: <Widget>[
              FlatButton(
                child: Text(localize(context, key: "no").toUpperCase(),),
                onPressed: (){
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: Text(localize(context, key: "yes").toUpperCase(),),
                onPressed: () async {

                  setState(() {
                    isLoading = true;
                  });
                  HazizzResponse hazizzResponse = await RequestSender().getResponse(LeaveGroup(p_groupId: widget.groupId));

                  if(hazizzResponse.isSuccessful){
                    Navigator.pop(context, true);
                  }
                  setState(() {
                    isLoading = false;
                  });

                },
              )
            ],);

        })
    );
    return dialog;
  }
}