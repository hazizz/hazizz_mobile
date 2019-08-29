import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_date.dart';
import '../hazizz_localizations.dart';

class GradeItemWidget extends StatelessWidget{


  PojoGrade pojoGrade;

  GradeItemWidget({this.pojoGrade});

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 82;


    return Container(
      height: itemHeight,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: InkWell(
              onTap: () {
                showGradeDialog(context, grade: pojoGrade);
              },
              child: Stack(
                children: <Widget>[
                  Row(
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
                              child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: AutoSizeText(pojoGrade.grade == null ? "5" : pojoGrade.grade,
                                          style: TextStyle(fontSize: 50, color: Colors.black, fontFamily: "Nunito"),
                                          maxLines: 1,
                                          maxFontSize: 50,
                                          minFontSize: 10,
                                        ),
                                      ),


                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Builder(
                                            builder: (context){
                                              Color textColor = Colors.black;
                                              if(pojoGrade.weight == 200){
                                                // textColor = Colors.red;

                                              }

                                              return Text(pojoGrade.weight == null ? "100%" : "${pojoGrade.weight}%", style: TextStyle(color: textColor, fontFamily: "Nunito"),);

                                            },
                                          ),
                                        )
                                      ),

                                    ]
                                ),

                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Builder(
                                builder: (context){
                                  if(pojoGrade.topic != null && pojoGrade.topic != ""){
                                    return Text(pojoGrade.topic, style: TextStyle(fontSize: 19),);
                                  }
                                  return Container();
                                },
                              ),
                              Builder(
                                builder: (context){
                                  String gradeType = pojoGrade.gradeType;
                                  if(gradeType.toLowerCase() == "midyear"){
                                    gradeType = locText(context, key: "gradeType_midYear");
                                  }else if(gradeType.toLowerCase() == "halfyear"){
                                    gradeType = locText(context, key: "gradeType_halfYear");
                                  }else if(gradeType.toLowerCase() == "endyear"){
                                    gradeType = locText(context, key: "gradeType_endYear");
                                  }
                                  return Text(gradeType);
                                },
                              ),

                            ],
                          ),
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
                  ),
                  Positioned(bottom: 4, right: 4,
                    child: Text(hazizzShowDateAndTimeFormat(pojoGrade.creationDate),style: Theme.of(context).textTheme.subtitle,) ,
                  )
                ],
              )
          )
      ),
    );
  }
}
