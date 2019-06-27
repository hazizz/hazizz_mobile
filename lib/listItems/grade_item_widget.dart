import 'package:flutter/material.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGrade.dart';
import 'package:hazizz_mobile/communication/pojos/PojoType.dart';
import 'package:hazizz_mobile/dialogs/dialogs.dart';
import 'package:hazizz_mobile/pages/ViewTaskPage.dart';
import 'package:easy_localization/easy_localization.dart';

import '../hazizz_date.dart';

class GradeItemWidget extends StatelessWidget{


  PojoGrade pojoGrade;

  GradeItemWidget({this.pojoGrade});

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 76;


    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              showGradeDialog(context, grade: pojoGrade);
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
                      color: pojoGrade.color,
                      child: Center(
                        child: Column(
                          children: [
                            Text(pojoGrade.grade == null ? "5" : pojoGrade.grade,
                              style: TextStyle(fontSize: 50),
                            ),
                            Text(pojoGrade.weight == null ? "100%" : "${pojoGrade.weight}%"),
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                Column(
                  children: <Widget>[

                    Text(pojoGrade.topic == null ? "Algebra" : pojoGrade.topic),
                    Text(pojoGrade.gradeType == null ? "Röpdolgozat" : pojoGrade.gradeType),

                  ],
                ),
                Spacer(),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topRight,
                        child:
                        Text(hazizzShowDateFormat(pojoGrade.creationDate))
                    )
                  ],
                )

              ],
            )
        )
    );
  }
}
