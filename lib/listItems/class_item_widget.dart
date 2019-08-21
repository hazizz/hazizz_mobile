import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_date.dart';
import '../hazizz_theme.dart';

class ClassItemWidget extends StatelessWidget{


  PojoClass pojoClass;

  ClassItemWidget({this.pojoClass});

  @override
  Widget build(BuildContext context) {

    const double itemHeight = 66;

    DateTime currentDateTime = DateTime.now();


    Color bgColor = null;

    if(hazizzIsAfterHHMMSS(mainTime: currentDateTime, compareTime: pojoClass.startOfClass) &&
       hazizzIsBeforeHHMMSS(mainTime: currentDateTime, compareTime: pojoClass.endOfClass)
    ){
      bgColor = HazizzTheme.blue;
    }

    return Container(
      height: itemHeight,
      child: Card(
        margin: EdgeInsets.only(left: 4, right: 4, bottom: 0, top: 5),
        color: bgColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
             // showGradeDialog(context, grade: pojoGrade);
              showClassDialog(context, pojoClass: pojoClass);
            },
            child: Stack(
              children: [Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  Container(
                    width: itemHeight/100*80,
                    height: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(pojoClass.periodNumber == null ? "1." : "${pojoClass.periodNumber}.",
                        style: TextStyle(fontSize: 44),
                      ),
                    ),
                  ),

                //  SizedBox(width: 4,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  //    Text(pojoClass.className == null ? "className" : pojoClass.className, style: TextStyle(fontSize: 20),),
                  //    Text(pojoClass.subject == null ? "subject" : pojoClass.subject),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                              color: Theme.of(context).primaryColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2, top: 2, right: 8, bottom: 4),
                            child: Row(
                                children: [
                                //  Text(pojoClass.subject == null ? "subject" : pojoClass.subject, style: TextStyle(fontSize: 20)),
                                  Text(pojoClass.className == null ? "className" : pojoClass.className, style: TextStyle(fontSize: 22),),
                                ]
                            ),
                          )
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            Text(pojoClass.startOfClass.toHazizzFormat(), style: TextStyle(fontSize: 20),),
                            Text("-", style: TextStyle(fontSize: 20),),
                            Text(pojoClass.endOfClass.toHazizzFormat(), style: TextStyle(fontSize: 20),),
                           // Spacer(),
                          //  Text(pojoClass.room == null ? " " : pojoClass.room, style: TextStyle(fontSize: 20),)
                          ],
                        ),
                      )


                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(pojoClass.room == null ? "U125" : pojoClass.room, style: TextStyle(fontSize: 20),)
                    ],
                  ),
                  SizedBox(width: 4,),
                ],
              ),
                /*
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Text(pojoClass.room == null ? "U125" : pojoClass.room, style: TextStyle(fontSize: 20),)
                )
                */

              ]
            )
        )
      ),
    );
  }
}
