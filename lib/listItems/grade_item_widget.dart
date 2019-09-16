import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_date.dart';
import '../hazizz_localizations.dart';

class GradeItemWidget extends StatelessWidget{


  PojoGrade pojoGrade;

  bool isBySubject = false;

  GradeItemWidget.bySubject({this.pojoGrade}){
    isBySubject = true;
  }

  GradeItemWidget.byDate({this.pojoGrade}){

  }


  @override
  Widget build(BuildContext context) {

    final double itemHeight = 72;


    return Container(
     // height: itemHeight,
      child: Card(
          margin: EdgeInsets.only(left: 7, top: 2.5, bottom: 2.5, right: 7),

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
                                          padding: const EdgeInsets.only(bottom: 0.0),
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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Builder(
                                builder: (context){
                                  if(!isBySubject){
                                    return Container(
                                      // color: PojoType.getColor(widget.pojoTask.type),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(12)),
                                            color: pojoGrade.color
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, top: 1, bottom: 1,  right: 8, ),
                                          child: Text(pojoGrade.subject,
                                            style: TextStyle(fontSize: 18, color: Colors.black),),
                                        )
                                    );
                                  }
                                  return Container();
                                },
                              ),


                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Builder(
                                  builder: (context){
                                    if(pojoGrade.topic != null && pojoGrade.topic != ""){
                                      return Text(pojoGrade.topic, style: TextStyle(fontSize: 19),);
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Builder(
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
                              ),

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
                  ),
                  Builder(
                    builder: (_){
                      if(isBySubject){
                        return Positioned(bottom: 4, right: 4,
                          child: Text(hazizzShowDateAndTimeFormat(pojoGrade.creationDate),style: Theme.of(context).textTheme.subtitle,) ,
                        );
                      }
                      return Container();
                    },
                  )

                ],
              )
          )
      ),
    );
  }
}
