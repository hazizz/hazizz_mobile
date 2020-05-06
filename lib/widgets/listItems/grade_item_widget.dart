import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import "package:mobile/extension_methods/extension_first_upper.dart";


class GradeItemWidget extends StatelessWidget {

  final PojoGrade pojoGrade;
  final bool isBySubject;
  final bool rectForm;
  final String altSubject;
  final double width;

  GradeItemWidget.bySubject({@required this.pojoGrade, this.rectForm = false, this.altSubject, this.width = 72})
    : isBySubject = true, super(key: UniqueKey());

  GradeItemWidget.byDate({@required this.pojoGrade, this.rectForm = false, this.width = 72})
    : isBySubject= false, altSubject = null, super(key: UniqueKey());


  @override
  Widget build(BuildContext context) {

    Widget gradeRectWidget(){
      return Container(
        width: width,
        height: width,
        color: pojoGrade.color,
        child: Stack(children: [
          Align(
            alignment: (pojoGrade.weight != null && pojoGrade.weight != 0)
                ? Alignment.topCenter
                : Alignment.center,
            child: AutoSizeText(pojoGrade.grade == null ? "5" : pojoGrade.grade,
              style: TextStyle(fontSize: 50, color: Colors.black, fontFamily: "Nunito"),
              maxLines: 1,
              maxFontSize: 50,
              minFontSize: 10,
            ),
          ),
          if (pojoGrade.gradeType == GradeTypeEnum.MIDYEAR)
            if(pojoGrade.weight != null && pojoGrade.weight != 0) Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 4),
                child: Builder(
                  builder: (context){
                    Color textColor = Colors.black;
                    if(pojoGrade.weight == 200){
                      // textColor = Colors.red;
                    }
                    return Text("${pojoGrade.weight}%", style: TextStyle(color: textColor, fontFamily: "Nunito"),);
                  },
                ),
              )
            ),
        ]
        ),
      );
    }

    Widget gradeRectWidgetWithHero(){
      return Hero(
        tag: pojoGrade,
        child: Card(
          margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),//EdgeInsets.only(left: 7, top: 2.5, bottom: 2.5, right: 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: gradeRectWidget(),
        ),
      );
    }

    if(rectForm){
      return InkWell(
          onTap: () {
            showGradeDialog(context, grade: pojoGrade);
          },
          child: gradeRectWidgetWithHero()
      );
    }

    return Hero(
      tag: pojoGrade,
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
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container( //Hero(
                      /*
                      placeholderBuilder: (context, size, widget){
                        return gradeRectWidget();
                      },

                      tag: pojoGrade,

                       */
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
                              if(!isBySubject || pojoGrade.gradeType != GradeTypeEnum.MIDYEAR ){
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                                    color: pojoGrade.color
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4, top: 3, bottom: 2,  right: 8, ),
                                    child: Column(
                                      children: <Widget>[
                                        Text((altSubject ?? pojoGrade.subject).toUpperFirst(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              height: 0.96
                                          )
                                        ),
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
                                if(pojoGrade.gradeType == GradeTypeEnum.MIDYEAR
                                    && pojoGrade.topic != null
                                    && pojoGrade.topic != ""){
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(pojoGrade.topic, style: TextStyle(fontSize: 16, height: 0.98),),
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
                                GradeTypeEnum gradeType = pojoGrade.gradeType;
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
              Positioned(bottom: 2, right: 4,
                child: Text(hazizzShowDateFormat(pojoGrade.creationDate),style: Theme.of(context).textTheme.subtitle,) ,
              )
            ],
          )
        )
      ),
    );
  }
}

