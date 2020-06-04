import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import "package:mobile/extension_methods/string_first_upper_extension.dart";
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/widgets/tag_chip.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class GradeItemWidget extends StatelessWidget {

  final PojoGrade pojoGrade;
  final bool isBySubject, rectForm;
  final String altSubject;
  final double width;

  GradeItemWidget.bySubject({@required this.pojoGrade, this.rectForm = false, this.altSubject, this.width = 60})
    : isBySubject = true, super(key: UniqueKey());

  GradeItemWidget.byDate({@required this.pojoGrade, this.rectForm = false, this.width = 60})
    : isBySubject= false, altSubject = null, super(key: UniqueKey());


  @override
  Widget build(BuildContext context) {

    Widget gradeRectWidget(){
      return Stack(
        children: <Widget>[
          Container(
            width: width,
            height: width,
            color: pojoGrade.color,
            child: Stack(children: [
              Align(
                alignment: (pojoGrade.weight != null && pojoGrade.weight != 0)
                    ? Alignment.topCenter
                    : Alignment.center,
                child: Padding(
                  padding: (pojoGrade.weight != null && pojoGrade.weight != 0)
                      ? const EdgeInsets.only(bottom: 2)
                      : const EdgeInsets.all(0),
                  child: AutoSizeText(pojoGrade.grade == null ? "5" : pojoGrade.grade,
                    style: TextStyle(fontSize: 50, color: Colors.black, fontFamily: "Nunito"),
                    maxLines: 1,
                    maxFontSize: 50,
                    minFontSize: 10,
                  ),
                ),
              ),
              if (pojoGrade.gradeType == GradeTypeEnum.MIDYEAR
                  && (pojoGrade.weight != null && pojoGrade.weight != 0))
                Align(
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


              if(pojoGrade.creationDate.isBefore(DateTime.now().add(1.days))
              && pojoGrade.creationDate.isAfter(DateTime.now().subtract(1.days)))
                Align(alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: TagChip(
                      hasCloseButton: false,
                      padding: EdgeInsets.only(left: 2, right: 2),
                      height: 18,
                      child: Text("new".localize(context), style: TextStyle(fontSize: 10),),
                      backgroundColor: Colors.red,
                    ),
                  ),
                )

            ]
            ),
          ),
        ],
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
        margin: EdgeInsets.only(left: 4, top: 2, bottom: 2, right: 4),
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
                    Container(
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
                                      left: 4, top: 3, bottom: 1,  right: 8, ),
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
                                    child: Text(pojoGrade.topic.toUpperFirst(), style: TextStyle(fontSize: 15, height: 0.98),),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(bottom: 0, right: 2,
                child: Text(pojoGrade.creationDate.hazizzShowDateFormat,style: TextStyle(fontSize: 14, height: 0.98),) ,
              )
            ],
          )
        )
      ),
    );
  }
}

