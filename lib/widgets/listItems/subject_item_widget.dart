import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/flushbars.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';


class SubjectItemWidget extends StatefulWidget{

  
  
  PojoSubject subject;

  SubjectItemWidget({this.subject});




  @override
  State<StatefulWidget> createState() {
    return _SubjectItemWidget();
  }
}

class _SubjectItemWidget extends State<SubjectItemWidget>{

  PojoSubject subject;

  @override
  void initState() {
    // TODO: implement initState

    subject = widget.subject;



    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Hero(
        tag: "hero_subject${widget.subject.id}",
        child:
        GestureDetector(
          onTap: (){
            showSubjectDialog(context, subject: subject);
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            child:
              Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 6,  top: 10, bottom: 10),
                          child: Text(widget.subject.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700
                            ),),
                        ),
                        Spacer(),
                        Builder(
                          builder: (context){
                            if(subject.subscriberOnly){
                              return Transform.scale(scale: 1.3,
                                child: Checkbox(

                                  value: subject.subscribed,
                                  onChanged: (value) async {
                                    setState(() {
                                      subject.subscribed = value;
                                    });


                                    HazizzResponse hazizzResponse = subject.subscribed
                                        ? await RequestSender().getResponse(SubscribeToSubject(p_subjectId: subject.id))
                                        : await RequestSender().getResponse(UnsubscribeFromSubject(p_subjectId: subject.id));
                                    if(hazizzResponse.isSuccessful){
                                      if(subject.subscribed){
                                        showSubscribedToSubjectFlushBar(context, what: subject.name);
                                      }else{
                                        showUnsubscribedFromSubjectFlushBar(context, what: subject.name);
                                      }
                                    }else{
                                    setState(() {
                                      subject.subscribed = !subject.subscribed;
                                    });
                                    }
                                  },
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,

                                ),
                              );
                            }
                            return Container();
                          },
                        )
                      ],)
          ),
        )
    );
  }
}
