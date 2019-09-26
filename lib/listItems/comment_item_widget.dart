import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/comment_section_bloc.dart';
import 'package:mobile/blocs/view_task_bloc.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/widgets/comment_section_widget.dart';
import 'package:mobile/widgets/flushbars.dart';

import '../hazizz_date.dart';
import '../hazizz_localizations.dart';
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
      HazizzLogger.printLog("user is the author: $result");

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
                            Text(widget.comment.creator.displayName == null ? "displayName" : widget.comment.creator.displayName , style: TextStyle(fontSize: 20),),
                          ]
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(hazizzShowDateAndTimeFormat(widget.comment.creationDate),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                )
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 6, bottom: 4),
                          child: Text(widget.comment.content == null ? "Content" : widget.comment.content ,
                            style: TextStyle(fontSize: 19),
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

                    List<PopupMenuEntry> menuItems = [

                      PopupMenuItem(
                        value: "profile",
                        child: Text(locText(context, key: "viewProfile"),),
                      ),

                      PopupMenuItem(
                        value: "report",
                        child: Text(locText(context, key: "report"),
                          style: TextStyle(color: HazizzTheme.red),
                        ),
                      ),
                    ];

                    if(imTheAuthor) {
                      menuItems.add(PopupMenuItem(
                          value: value_delete,
                          child: Text(locText(context, key: "delete"),
                            style: TextStyle(color: HazizzTheme.red),
                          ),

                      ));
                    }
                    return PopupMenuButton(
                      icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                      onSelected: (value) async {
                        if(value == value_delete){
                          await RequestSender().getResponse(DeleteComment(p_commentId: widget.comment.id));
                          ViewTaskBloc().commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());
                        }else if(value == "report"){
                          bool success = await showReportDialog(context, reportType: ReportTypeEnum.COMMENT, id: widget.comment.id, secondId: widget.taskId, name: widget.comment.creator.displayName);
                          if(success != null && success){
                            showReportSuccessFlushBar(context, what: locText(context, key: "comment"));
                          }
                        }else if(value == "profile"){
                          showUserDialog(context, creator: widget.comment.creator);
                        }
                      },
                      itemBuilder: (BuildContext context) {



                        return  menuItems;
                      },

                    );
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
