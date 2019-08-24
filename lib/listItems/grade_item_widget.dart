import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_date.dart';

class GradeItemWidget extends StatelessWidget{


  PojoGrade pojoGrade;

  GradeItemWidget({this.pojoGrade});

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 87;


    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              showGradeDialog(context, grade: pojoGrade);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              FittedBox(
                fit: BoxFit.none,
                child: Container(
                  width: itemHeight,
                  child:
                  AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      color: pojoGrade.color,
                      child: Center(
                        child: Column(
                          children: [
                            AutoSizeText(pojoGrade.grade == null ? "5" : pojoGrade.grade,
                              style: TextStyle(fontSize: 50, color: Colors.black),
                              maxLines: 1,
                              maxFontSize: 50,
                              minFontSize: 10,
                            ),
                            Text(pojoGrade.weight == null ? "100%" : "${pojoGrade.weight}%", style: TextStyle(color: Colors.black),),
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(pojoGrade.topic == null ? "Algebra" : pojoGrade.topic),
                      Text(pojoGrade.gradeType == null ? "Röpdolgozat" : pojoGrade.gradeType),


                      Row(  mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        Align(
                            alignment: Alignment.topRight,
                            child:
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(hazizzShowDateAndTimeFormat(pojoGrade.creationDate),style: Theme.of(context).textTheme.subtitle,),
                            )
                        )
                      ],)
                    ],
                  ),
                ),
                /*
                Spacer(),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topRight,
                        child:
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(hazizzShowDateAndTimeFormat(pojoGrade.creationDate),style: Theme.of(context).textTheme.subtitle,),
                        )
                    )
                  ],
                )
                */

              ],
            )
        )
    );
  }
}
