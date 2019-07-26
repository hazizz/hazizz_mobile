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

    final double itemHeight = 50;

    DateTime currentDateTime = DateTime.now();


    Color bgColor = null;

    if(hazizzIsAfterHHMMSS(mainTime: currentDateTime, compareTime: pojoClass.startOfClass) &&
       hazizzIsBeforeHHMMSS(mainTime: currentDateTime, compareTime: pojoClass.endOfClass)
    ){
      bgColor = HazizzTheme.blue;
    }

    return Card(
      color: bgColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: InkWell(
          onTap: () {
           // showGradeDialog(context, grade: pojoGrade);
            showClassDialog(context, pojoClass: pojoClass);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


            Container(
             // height: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(pojoClass.periodNumber == null ? "1." : "${pojoClass.periodNumber}.",
                  style: TextStyle(fontSize: 38),
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

                  Row(
                    children: <Widget>[
                      Text(pojoClass.startOfClass.toHazizzFormat(), style: TextStyle(fontSize: 20),),
                      Text("-", style: TextStyle(fontSize: 20),),
                      Text(pojoClass.endOfClass.toHazizzFormat(), style: TextStyle(fontSize: 20),)
                    ],
                  )


                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(hazizzShowDateFormat(pojoClass.date))
                ],
              ),
              SizedBox(width: 4,),
            ],
          )
      )
    );
  }
}
