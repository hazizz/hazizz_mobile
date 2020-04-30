import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/enums/action_type_enum.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';
import 'dialogs.dart';



class SubjectEditorDialog extends StatefulWidget {

  ActionTypeEnum actionType;

  int groupId;
  PojoSubject subject;

  SubjectEditorDialog.create({Key key, @required this.groupId}) : super(key: key){
    actionType = ActionTypeEnum.CREATE;
  }

  SubjectEditorDialog.edit({Key key, @required this.subject}) : super(key: key){
    actionType = ActionTypeEnum.EDIT;
  }

  @override
  _SubjectEditorDialog createState() => new _SubjectEditorDialog();
}

class _SubjectEditorDialog extends State<SubjectEditorDialog> {

  bool isLoading = false;

  bool passwordVisible = true;

  final double width = 300;
  final double height = 190;

  TextEditingController _subjectTextEditingController = TextEditingController();

  bool isSubscriberOnly = false;

  @override
  void initState() {
    _subjectTextEditingController.text =
      widget.actionType == ActionTypeEnum.EDIT
        ? widget.subject.name
        : "";
    isSubscriberOnly =
      widget.actionType == ActionTypeEnum.EDIT
        ? widget.subject.subscriberOnly
        : false;
    super.initState();
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
          AutoSizeText(widget.subject == null ? locText(context, key: "create_subject") : locText(context, key: "edit_subject") ,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              minFontSize: 20,
            maxFontSize: 30,

          ),
        ),
      ),
      content: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(fontSize: 22),
                        inputFormatters:[
                          LengthLimitingTextInputFormatter(20),
                        ],
                        autofocus: true,

                        controller: _subjectTextEditingController,
                        textInputAction: TextInputAction.send,
                        decoration:
                        InputDecoration(hintText: locText(context, key: "subject"), errorText: errorText),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(locText(context, key: "subscription_based"), style: TextStyle(fontSize: 19),),
                            Transform.scale(scale: 1.3,
                              child: Checkbox(
                                value: isSubscriberOnly,
                                onChanged: (value) async {
                                  setState(() {
                                    isSubscriberOnly = value;
                                  });
                                },
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                              ),
                            ),


                          ],
                        ),
                      )
                    ],
                  )
              ),

              Builder(builder: (context){
                if(isLoading){
                  return Container(
                    width: width,
                    height: height,
                    color: Colors.grey.withAlpha(120),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Container();
              }),
            ],
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
                child: Text((widget.subject == null ? locText(context, key: "add") : locText(context, key: "edit")).toUpperCase() ,
                  style: TextStyle(
                    //  fontFamily: 'Montserrat',
                      color: HazizzTheme.warningColor
                  ),
                ),
              ),


              onPressed: !isLoading ? () async {

                if(_subjectTextEditingController.text.length >= 2 && _subjectTextEditingController.text.length <= 20){

                  setState(() {
                    isLoading = true;

                  });

                  HazizzResponse response = await getResponse(
                    widget.actionType == ActionTypeEnum.CREATE ?
                      CreateSubject(p_groupId: widget.groupId,
                          b_subjectName: _subjectTextEditingController.text,
                          b_subscriberOnly: isSubscriberOnly)
                    : UpdateSubject(p_subjectId: widget.subject.id,
                        b_subjectName: _subjectTextEditingController.text,
                        b_subscriberOnly: isSubscriberOnly)
                  );

                  setState(() {
                    isLoading = false;
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