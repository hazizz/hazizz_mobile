import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/dialogs/dialogs.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import "package:mobile/extension_methods/extension_first_upper.dart";



class GradeItemWidget extends StatefulWidget {

  PojoGrade pojoGrade;

  bool isBySubject = false;

  bool rectForm = false;

  String alt_subject;



  GradeItemWidget.bySubject({@required this.pojoGrade, this.rectForm = false, this.alt_subject})
      : super(key: UniqueKey()){
    isBySubject = true;
  }

  GradeItemWidget.byDate({@required this.pojoGrade, this.rectForm = false})
      : super(key: UniqueKey());

  @override
  _GradeItemWidget createState() => new _GradeItemWidget();
}

class _GradeItemWidget extends State<GradeItemWidget>{

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 72;

    Widget gradeRectWidget(){
      return Container(
        width: itemHeight,
        height: itemHeight,
        color: widget.pojoGrade.color,
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: AutoSizeText(widget.pojoGrade.grade == null ? "5" : widget.pojoGrade.grade,
              style: TextStyle(fontSize: 50, color: Colors.black, fontFamily: "Nunito"),
              maxLines: 1,
              maxFontSize: 50,
              minFontSize: 10,
            ),
          ),
          if (widget.pojoGrade.gradeType == GradeTypeEnum.MIDYEAR)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 4),
                child: Builder(
                  builder: (context){
                    Color textColor = Colors.black;
                    if(widget.pojoGrade.weight == 200){
                      // textColor = Colors.red;
                    }
                    return Text(widget.pojoGrade.weight == null ? "100%" : "${widget.pojoGrade.weight}%", style: TextStyle(color: textColor, fontFamily: "Nunito"),);

                  },
                ),
              )
            ),
         // Text("NEW")
        ]
        ),
      );
    }

    Widget gradeRectWidgetWithHero(){
      return Hero(
        placeholderBuilder: (context, size, widget){
          return Card(
            margin: EdgeInsets.only(left: 7, top: 2.5, bottom: 2.5, right: 0 ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            child: gradeRectWidget(),
          );
        },
        tag: widget.pojoGrade,
        child: Card(
          margin: EdgeInsets.only(left: 7, top: 2.5, bottom: 2.5, right: 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: gradeRectWidget(),
        ),
      );
    }

    if(widget.rectForm){
      return InkWell(
        onTap: () {
          showGradeDialog(context, grade: widget.pojoGrade);
        },
        child: gradeRectWidgetWithHero()
      );
    }

    return Container(
      child: Card(
          margin: EdgeInsets.only(left: 7, top: 2.5, bottom: 2.5, right: 7),

          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: InkWell(
              onTap: () {
                showGradeDialog(context, grade: widget.pojoGrade);
              },
              child: Stack(
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Hero(
                          placeholderBuilder: (context, size, widget){
                            return gradeRectWidget();
                          },
                          tag: widget.pojoGrade,
                          child: gradeRectWidget(),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Builder(
                                builder: (context){
                                  if(!widget.isBySubject || widget.pojoGrade.gradeType != GradeTypeEnum.MIDYEAR ){
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                                        color: widget.pojoGrade.color
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4, top: 3, bottom: 2,  right: 8, ),
                                        child: Column(
                                          children: <Widget>[
                                            Text((widget.alt_subject ?? widget.pojoGrade.subject).toUpperFirst(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  height: 0.96
                                                )),
                                          ],
                                        )
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
                                    if(widget.pojoGrade.gradeType == GradeTypeEnum.MIDYEAR
                                    && widget.pojoGrade.topic != null
                                    && widget.pojoGrade.topic != ""){
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(widget.pojoGrade.topic, style: TextStyle(fontSize: 16, height: 0.98),),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              /*
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Builder(
                                  builder: (context){
                                    GradeTypeEnum gradeType = widget.pojoGrade.gradeType;
                                    String gradeTypeShow;
                                    if(gradeType == GradeTypeEnum.MIDYEAR){
                                      gradeTypeShow = locText(context, key: "gradeType_midYear");
                                    }else if(gradeType == GradeTypeEnum.HALFYEAR){
                                      gradeTypeShow = locText(context, key: "gradeType_halfYear");
                                    }else if(gradeType == GradeTypeEnum.ENDYEAR){
                                      gradeTypeShow = locText(context, key: "gradeType_endYear");
                                    }
                                    return Text(gradeTypeShow);
                                  },
                                ),
                              ),
                              */
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Builder(
                    builder: (_){
                      return Positioned(bottom: 2, right: 4,
                        child: Text(hazizzShowDateFormat(widget.pojoGrade.creationDate),style: Theme.of(context).textTheme.subtitle,) ,
                      );
                    },
                  )
                ],
              )
          )
      ),
    );
  }
}
