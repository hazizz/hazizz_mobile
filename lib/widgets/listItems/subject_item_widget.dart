import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';

class SubjectItemWidget extends StatefulWidget{

  final PojoSubject subject;
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
                    ),
                  ),
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
                              ? await RequestSender().getResponse(SubscribeToSubject(pSubjectId: subject.id))
                              : await RequestSender().getResponse(UnsubscribeFromSubject(pSubjectId: subject.id));
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
              ],
            )
        ),
      )
    );
  }
}
