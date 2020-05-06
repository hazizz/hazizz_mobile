import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/dialogs/dialogs.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import "package:mobile/extension_methods/extension_first_upper.dart";


class ClassItemWidget extends StatelessWidget{

  final PojoClass pojoClass;

  final bool isCurrentEvent;

  ClassItemWidget({this.pojoClass}) : isCurrentEvent = false;

  ClassItemWidget.isCurrentEvent({this.pojoClass}) : isCurrentEvent = true;

  @override
  Widget build(BuildContext context) {

    const double itemHeight = 65;

    DateTime currentDateTime = DateTime.now();

    Color bgColor;

    if(hazizzIsAfterHHMMSS(mainTime: currentDateTime, compareTime: pojoClass.startOfClass) &&
       hazizzIsBeforeHHMMSS(mainTime: currentDateTime, compareTime: pojoClass.endOfClass)
    ){
      bgColor = HazizzTheme.blue;
    }

    return Hero(
      tag: pojoClass,
      child: Card(
        margin: EdgeInsets.only(left: 3, right: 3, bottom: 2.1, top: 2.1),
        color: bgColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              showClassDialog(context, pojoClass: pojoClass);
            },
            child: Container(

              decoration: isCurrentEvent ? BoxDecoration(
                border: Border.all(
                    width: 4.0,
                  color: HazizzTheme.red
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0)
                ),

              ) : null,

              child: Stack(
                children: [IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        width: itemHeight/100*80,
                      //    height: 200,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(pojoClass.periodNumber == null ? "1." : "${pojoClass.periodNumber}.",
                            style: TextStyle(fontSize: 38, ),
                            maxLines: 1,
                          ),
                        )
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                                    color: Theme.of(context).primaryColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2, top: 0, right: 8, bottom: 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                      children: [

                                  //  Text(pojoClass.subject == null ? "subject" : pojoClass.subject, style: TextStyle(fontSize: 20)),
                                        Text(pojoClass.subject == null ? "className" : pojoClass.subject.toUpperFirst(),
                                          style: TextStyle(fontSize: 19),
                                        ),
                                      ]
                                  ),
                                )
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Builder(builder: (context){
                                  if(pojoClass.topic != null && pojoClass.topic != ""){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.4, bottom: 4),
                                      child: Text(pojoClass.topic, style: TextStyle(fontSize: 16, color: Colors.grey, height:1)),
                                    );
                                  }
                                  return Container();
                                }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Builder(builder: (context){
                                if(pojoClass.cancelled){
                                  return Text(locText(context, key: "thera_canceled").toUpperCase(), style: TextStyle(fontSize: 19, color: HazizzTheme.red));
                                }else if(pojoClass.standIn){
                                  return Text("${locText(context, key: "thera_standin")}: ${pojoClass.teacher}", style: TextStyle(fontSize: 19, color: HazizzTheme.red));

                                }
                                return Container();
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Row(
                                children: <Widget>[
                                  Text(pojoClass.startOfClass.toHazizzFormat(), style: TextStyle(fontSize: 18, height: 0.85),),
                                  Text("-", style: TextStyle(fontSize: 18, height: 0.85),),
                                  Text(pojoClass.endOfClass.toHazizzFormat(), style: TextStyle(fontSize: 18, height: 0.85),),
                                 // Spacer(),
                                //  Text(pojoClass.room == null ? " " : pojoClass.room, style: TextStyle(fontSize: 20),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                   //   Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(pojoClass.room ?? "", style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    ],
                  ),
                ),
                ]
              ),
            )
        )
      ),
    );
  }
}
