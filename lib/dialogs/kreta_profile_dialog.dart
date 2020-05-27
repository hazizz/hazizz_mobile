import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoKretaProfile.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'dialog_collection.dart';

class KretaProfileDialog extends StatefulWidget {
  final PojoSession session;

  KretaProfileDialog({@required this.session});

  @override
  _KretaProfileDialog createState() => new _KretaProfileDialog();
}

class _KretaProfileDialog extends State<KretaProfileDialog> {
  bool isLoading = true;

  PojoKretaProfile kretaProfile;

  @override
  void initState() {

    RequestSender().
    getResponse(new KretaGetProfile(session:  widget.session)).then((HazizzResponse hazizzResponse){
      if(hazizzResponse.isSuccessful){
        setState(() {
          kretaProfile = hazizzResponse.convertedData;
        });
      }
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  final double width = 300;
  final double height = 260;

  final double searchBarHeight = 50;

  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
        header: Container(
          width: 600,
          color: Theme.of(context).primaryColor,
          child: Padding(
              padding: const EdgeInsets.all(5),
              child:
              Center(
                child: Builder(builder: (context){
                  if(!isLoading){
                    return Column(
                      children: <Widget>[
                        Text(kretaProfile?.name != null ? kretaProfile.name : "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            )
                        ),
                        Text(widget.session.username != null ? widget.session.username : "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )
                        )
                      ],
                    );
                  }
                  return Center(child: Text(localize(context, key: "loading"), style: TextStyle(fontSize: 20),));
                }),
              )
          ),
        ),
        content: Container(
          child: Builder(
            builder: (context){
              if(isLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text(kretaProfile?.schoolName != null ? kretaProfile.schoolName : "", textAlign: TextAlign.center, style: TextStyle(fontSize: 16))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Osztályfönök:", style: TextStyle(fontSize: 16),),
                        Expanded(child: Column(
                          children: <Widget>[
                            Text(kretaProfile?.formTeacher?.name != null ? kretaProfile.formTeacher.name : "", style: TextStyle(fontSize: 16),  textAlign: TextAlign.end,),
                            Text(kretaProfile?.formTeacher?.email != null ? kretaProfile.formTeacher.email : "", style: TextStyle(fontSize: 16),  textAlign: TextAlign.end,)
                          ],
                        )),
                      ],
                    ),
                    /*   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Osztályfönök email címe:", style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(kretaProfile?.formTeacher?.email != null ? kretaProfile.formTeacher.email : "", style: TextStyle(fontSize: 16))),
                  ],
                ),
                */
                  ],
                ),
              );

            },
          )

        ),
        actionButtons: Builder(builder: (context){
          return FlatButton(
            child: Text(localize(context, key: "close").toUpperCase(),),
            onPressed: (){
              Navigator.pop(context);
            },
          );
          }
    ));
    return dialog;
  }
}