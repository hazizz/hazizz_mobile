import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';

import '../hazizz_date.dart';

class CommentItemWidget extends StatelessWidget{


  PojoComment comment;

  CommentItemWidget({this.comment});

  @override
  Widget build(BuildContext context) {




    return Card(
     // borderOnForeground: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 30,
        child: InkWell(
            onTap: () {
              // showGradeDialog(context, grade: pojoGrade);
            //  showClassDialog(context, pojoClass: pojoClass);
            },
            child: Column(
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                            color: Theme.of(context).primaryColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, top: 2, right: 8, bottom: 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //  Text(pojoClass.subject == null ? "subject" : pojoClass.subject, style: TextStyle(fontSize: 20)),
                                Text(comment.creator.displayName == null ? "displayName" : comment.creator.displayName , style: TextStyle(fontSize: 22),),
                              ]
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(hazizzShowDateAndTimeFormat(comment.creationDate),
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    )
                  ],
                ),

                Row(
                  children: [Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Padding(
                          padding: const EdgeInsets.only(left: 8, right: 6, bottom: 4),
                            child: Text(comment.content == null ? "Content" : comment.content ,
                              style: TextStyle(fontSize: 22),
                             // textAlign: TextAlign.justify,
                             // overflow: TextOverflow.ellipsis,
                             // softWrap: false,
                            ),
                        ),
                        ]
                      ),
                    ),
                  ]
                )
              ]
            )
        )
    );
  }
}
