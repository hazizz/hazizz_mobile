import 'package:flutter/material.dart';
import 'package:mobile/blocs/comment_section_bloc.dart';
import 'package:mobile/blocs/view_task_bloc.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/widgets/comment_section_widget.dart';

import '../hazizz_date.dart';
import '../hazizz_theme.dart';
import '../request_sender.dart';

class CommentItemWidget extends StatefulWidget  {

  PojoComment comment;
  int taskId;

  CommentItemWidget({@required this.comment, @required this.taskId}) {
  }

  @override
  _CommentItemWidget createState() => _CommentItemWidget();
}


class _CommentItemWidget extends State<CommentItemWidget>{

  bool imTheAuthor = false;


  @override
  void initState() {
    // TODO: implement initState
    InfoCache.getMyId().then((int result){
      if(widget.comment.creator.id == result){
        setState(() {
          imTheAuthor = true;
        });
      }
    });
    super.initState();
  }


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
                            Text(widget.comment.creator.displayName == null ? "displayName" : widget.comment.creator.displayName , style: TextStyle(fontSize: 22),),
                          ]
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(hazizzShowDateAndTimeFormat(widget.comment.creationDate),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                )
              ],
            ),

            Row(
              children: [Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 6, bottom: 4),
                          child: Text(widget.comment.content == null ? "Content" : widget.comment.content ,
                            style: TextStyle(fontSize: 22),
                           // textAlign: TextAlign.justify,
                           // overflow: TextOverflow.ellipsis,
                           // softWrap: false,
                          ),
                      ),
                    ]
                  ),
                ),
                Builder(
                  builder: (context) {
                    const String value_delete = "delete";
                    if(imTheAuthor) {
                      return PopupMenuButton(
                        onSelected: (value) async {
                          print("log: value: $value");
                          if(value == value_delete){
                            await RequestSender().getResponse(DeleteTaskComment(p_taskId: widget.taskId, p_commentId: widget.comment.id));
                            ViewTaskBloc().commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: value_delete,
                              child: GestureDetector(
                                child: Text("Delete",
                                  style: TextStyle(color: HazizzTheme.red),
                                ),
                              )
                            )
                          ];
                        },

                      );
                    }else{
                      return Container();
                    }
                  }
                )
              ]
            )
          ]
        )
      )
    );
  }
}