import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_date.dart';
import '../hazizz_theme.dart';

class CommentWidget extends StatelessWidget{


  PojoTask task;

  CommentWidget({this.task});

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 50;

    DateTime currentDateTime = DateTime.now();




    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              width: itemHeight,
              child:
              AspectRatio(
                aspectRatio: 1/1,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text("prof pic"),
                     // style: TextStyle(fontSize: 38),
                  ),
                ),
              ),
            ),
            //  SizedBox(width: 4,),
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
                        Text("asdasdsa"),
                      ]
                  ),
                )
            ),
            SizedBox(width: 4,),


            Row(
              children: <Widget>[
                Container(
                    width: 200,
                    height: 55,
                    child: TextField()
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: (){

                  },
                )
              ],
            )


          ],
        )
    );
  }
}
