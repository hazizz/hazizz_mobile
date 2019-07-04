import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_date.dart';
import '../hazizz_theme.dart';

class CommentItemWidget extends StatelessWidget{


  PojoComment comment;

  CommentItemWidget({this.comment});

  @override
  Widget build(BuildContext context) {

    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              // showGradeDialog(context, grade: pojoGrade);
            //  showClassDialog(context, pojoClass: pojoClass);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                /*
                Container(
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
                */
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
                                Text(comment.creator.displayName == null ? "displayName" : comment.creator.displayName , style: TextStyle(fontSize: 22),),
                              ]
                          ),
                        )
                    ),
                    Text(comment.content == null ? "Content" : comment.content , style: TextStyle(fontSize: 22),)
                  ],
                ),
              ],
            )
        )
    );
  }
}
