import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/listItems/comment_item_widget.dart';

import '../hazizz_date.dart';
import '../hazizz_theme.dart';

class CommentWidget extends StatelessWidget{


  List<PojoComment> comments = List();

  CommentWidget({this.comments}){
    if(comments == null) {
      comments = List();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[


            Builder(
              builder: (BuildContext context1) {
                if(comments.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context2, int index) {
                      return GestureDetector(
                          onTap: () {
                            // Navigator.of(context2).pop();
                            //      onPicked(groups_data[index]);

                          },
                          child: CommentItemWidget(comment: comments[index],)
                      );
                    },
                  );
                }
                return Center(child: Text("no comments yet"));

              }
            ),

            SizedBox(width: 4,),

            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(),
                  ),
                ),
                /*
                FloatingActionButton(
                  child: Icon(Icons.send),
                  onPressed: (){},
                ),
                */

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
