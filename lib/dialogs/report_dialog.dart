import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/create_group_bloc.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'package:mobile/widgets/hyper_link.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';
import '../hazizz_theme.dart';
import '../request_sender.dart';
import 'dialogs.dart';

enum ReportTypeEnum{
  GROUP,
  SUBJECT,
  TASK,
  COMMENT,
  USER
}

class ReportDialog extends StatefulWidget {

  int id, secondId;
  String name;

  ReportTypeEnum reportType;

  ReportDialog({@required this.reportType, @required this.id, this.secondId, @required this.name,}){

  }

  @override
  _ReportDialog createState() => new _ReportDialog();
}

class _ReportDialog extends State<ReportDialog> {


  bool isLoading = false;

  bool acceptedHazizzPolicy = false;


  TextEditingController descriptionController;


  @override
  void initState() {
    descriptionController = TextEditingController();
    descriptionController.addListener((){
      setState(() {
        errorText = null;
      });
    });
    super.initState();
  }


  final double width = 360;
  final double height = 350;


  String errorText = "";


  @override
  Widget build(BuildContext context) {

    String something;

    switch(widget.reportType){
      case ReportTypeEnum.GROUP:
        something = locText(context, key: "group");
        break;
      case ReportTypeEnum.COMMENT:
        something = locText(context, key: "somebodys_comment");
        break;
      case ReportTypeEnum.SUBJECT:
        something = locText(context, key: "subject");
        break;
      case ReportTypeEnum.TASK:
        something = locText(context, key: "task");
        break;
      case ReportTypeEnum.USER:
        something = locText(context, key: "user");
        break;
    }
    HazizzLogger.printLog("about to report a $something");

    String title = locText(context, key: "report_something", args: ["${widget.name} $something"]);


    String currentLang = Localizations.localeOf(context).languageCode;
    if(currentLang != "en" && currentLang != "hu" ){
      currentLang = "en";
    }


    var dialog = HazizzDialog(width: width, height: height,
      header: Container(
        width: width,
        color: HazizzTheme.red,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text(title,
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w800,
              )
          ),
        ),
      ),
      content: Stack(
        children: [
          Container(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    TextField(
                      // textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18),
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: locText(context, key: "description"),
                      ),
                      maxLength: 500,
                      maxLines: 5,
                      minLines: 2,
                      expands: false,
                    ),


                    Row(children: <Widget>[
                      Checkbox(value: acceptedHazizzPolicy, onChanged: (value){
                        setState(() {
                          acceptedHazizzPolicy = value;
                        });
                      }),
                      Text(locText(context, key: "accept_hazizz_guidelines1"), style: TextStyle(fontSize: 15,)),
                      Hyperlink("https://hazizz.github.io/guideline-hu.txt", Text(locText(context, key: "accept_hazizz_guidelines2"), style: TextStyle(fontSize: 15, color: HazizzTheme.red, decoration: TextDecoration.underline,), )),

                    ],),
                    Builder(builder: (context){
                      if(errorText != null && !acceptedHazizzPolicy){
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(errorText, style: TextStyle(color: HazizzTheme.red),),
                        );
                      }
                      return Container();
                    },)

                  ],
                ),
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
          })
        ]
      ),
      actionButtons:  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text(locText(context, key: "close").toUpperCase()),
            onPressed: (){
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
              child: Text(locText(context, key: "send").toUpperCase()),
              onPressed: () async {
                HazizzLogger.printLog("report descp: ${descriptionController.text}");
                if(descriptionController.text != "" && descriptionController.text != null){
                  if(!acceptedHazizzPolicy){
                    setState(() {
                      errorText = locText(context, key: "error_accept_hazizz_guidelines");
                    });
                  }
                  else{
                    setState(() {
                      isLoading = true;
                    });
                    HazizzResponse hazizzResponse;
                    switch(widget.reportType){
                      case ReportTypeEnum.GROUP:
                        hazizzResponse = await RequestSender().getResponse(Report.group(p_groupId: widget.id,  b_description: descriptionController.text));
                        break;
                      case ReportTypeEnum.COMMENT:
                        hazizzResponse = await RequestSender().getResponse(Report.comment(p_commentId: widget.id, p_taskId: widget.secondId, b_description: descriptionController.text));
                        break;
                      case ReportTypeEnum.SUBJECT:
                        hazizzResponse = await RequestSender().getResponse(Report.subject(p_groupId: widget.secondId, p_subjectId: widget.id, b_description: descriptionController.text));
                        break;
                      case ReportTypeEnum.TASK:
                        hazizzResponse = await RequestSender().getResponse(Report.task(p_taskId: widget.id, b_description: descriptionController.text));
                        break;
                      case ReportTypeEnum.USER:
                        hazizzResponse = await RequestSender().getResponse(Report.user(p_userId: widget.id,  b_description: descriptionController.text));
                        break;
                    }
                    setState(() {
                      isLoading = false;
                    });
                    if(hazizzResponse.isSuccessful){
                      Navigator.pop(context, true);
                    }else{
                      setState(() {
                        errorText = locText(context, key: "try_again_later");
                      });
                     // Navigator.pop(context, false);
                    }
                  }
                }else{

                }
              }
          )
        ],
      )
    );
    return dialog;
  }
}