import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/pojos/PojoClass.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGrade.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/dialogs/dialogs.dart';
import 'package:hazizz_mobile/pages/ViewTaskPage.dart';
import 'package:easy_localization/easy_localization.dart';

import '../hazizz_date.dart';

class ClassItemWidget extends StatelessWidget{


  PojoClass pojoClass;

  ClassItemWidget({this.pojoClass});

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 50;


    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: InkWell(
          onTap: () {
           // showGradeDialog(context, grade: pojoGrade);
          },
          child: Row(
            children: <Widget>[

              FittedBox(
                fit: BoxFit.none,
                child: Container(
                  width: itemHeight,
                  child:
                  AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(pojoClass.periodNumber == null ? "1." : "${pojoClass.periodNumber}.",
                          style: TextStyle(fontSize: 38),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(pojoClass.className == null ? "className" : pojoClass.className, style: TextStyle(fontSize: 20),),
                  Text(pojoClass.subject == null ? "subject" : pojoClass.subject),

                ],
              ),
              Spacer(),
              Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child:
                      Text(hazizzShowDateFormat(pojoClass.date))
                  )
                ],
              ),
              SizedBox(width: 4,),

            ],
          )
      )
        );
  }
}
