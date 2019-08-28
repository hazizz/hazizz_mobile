import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/create_group_bloc.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';
import '../hazizz_theme.dart';
import '../request_sender.dart';
import 'dialogs.dart';

class CreateSubjectDialog extends StatefulWidget {

  int groupId;

  CreateSubjectDialog({Key key, @required this.groupId}) : super(key: key);

  @override
  _CreateSubjectDialog createState() => new _CreateSubjectDialog();
}

class _CreateSubjectDialog extends State<CreateSubjectDialog> {

  @override
  void initState() {

    super.initState();
  }

  bool passwordVisible = true;

  GroupType groupValue = GroupType.OPEN;


  final double width = 300;
  final double height = 100;

  final double searchBarHeight = 50;

  TextEditingController _subjectTextEditingController = TextEditingController();



  setGroupTypeValue(GroupType groupType){

    groupValue = groupType;
  }


  @override
  Widget build(BuildContext context) {


    String errorText = null;

    bool isEnabled = true;


    var dialog = HazizzDialog(width: width, height: height,
      header: Container(
        width: width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text(locText(context, key: "create_subject"),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              )
          ),
        ),
      ),
      content: Container(
          height: 60,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(fontSize: 22),
                inputFormatters:[
                  LengthLimitingTextInputFormatter(20),
                ],
                autofocus: true,
                onChanged: (dynamic text) {
                  print("change: $text");
                },
                controller: _subjectTextEditingController,
                textInputAction: TextInputAction.send,
                decoration:
                InputDecoration(hintText: locText(context, key: "subject"), errorText: errorText),
              )
          ),
      ),
      actionButtons: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
              child: Center(
                child: Text(locText(context, key: "cancel").toUpperCase()),
              ),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              color: Colors.transparent
          ),
          FlatButton(

              child: Center(
                child: Text(locText(context, key: "add"),
                  style: TextStyle(
                    //  fontFamily: 'Montserrat',
                      color: HazizzTheme.warningColor
                  ),
                ),
              ),


              onPressed: isEnabled ? () async {

                if(_subjectTextEditingController.text.length >= 2 && _subjectTextEditingController.text.length <= 20){

                  setState(() {
                    isEnabled = false;

                  });

                  HazizzResponse response = await RequestSender().getResponse(CreateSubject(p_groupId: widget.groupId, b_subjectName: _subjectTextEditingController.text));
                  setState(() {
                    isEnabled = true;

                  });
                  if(response.isSuccessful){
                    Navigator.pop(context, response.convertedData);
                  }
                }

              } : null,

              /*
                            onPressed: () async {

                              if(_subjectTextEditingController.text.length >= 2 && _subjectTextEditingController.text.length <= 20){
                                HazizzResponse response = await RequestSender().getResponse(CreateSubject(p_groupId: groupId, b_subjectName: _subjectTextEditingController.text));
                                if(response.isSuccessful){
                                  Navigator.pop(context, true);
                                }
                              }

                            },
        */
              color: Colors.transparent
          ),
        ],
      )
    );
    return dialog;
  }
}