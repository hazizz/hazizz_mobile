import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/comment_section_bloc.dart';
import 'package:mobile/blocs/other/view_task_bloc.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';

class CommentItemWidget extends StatefulWidget  {

  final PojoComment comment;
  final int taskId;

  CommentItemWidget({@required this.comment, @required this.taskId});

  @override
  _CommentItemWidget createState() => _CommentItemWidget();
}


class _CommentItemWidget extends State<CommentItemWidget>{

  bool imTheAuthor = false;

  @override
  void initState() {
    if(widget.comment.creator.id == CacheManager.getMyIdSafely){
      setState(() {
        imTheAuthor = true;
      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
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
                            Text(widget.comment.creator.displayName == null
                                ? "displayName" :
                                widget.comment.creator.displayName,
                              style: TextStyle(fontSize: 20),),
                          ]
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(widget.comment.creationDate.hazizzShowDateAndTimeFormat,
                    style: Theme.of(context).textTheme.subtitle2,
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
                        child: Text(localize(context, key: "viewProfile"),),
                      ),

                      PopupMenuItem(
                        value: "report",
                        child: Text(localize(context, key: "report"),
                          style: TextStyle(color: HazizzTheme.red),
                        ),
                      ),
                    ];

                    if(imTheAuthor) {
                      menuItems.add(PopupMenuItem(
                          value: value_delete,
                          child: Text(localize(context, key: "delete"),
                            style: TextStyle(color: HazizzTheme.red),
                          ),

                      ));
                    }
                    return PopupMenuButton(
                      icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                      onSelected: (value) async {
                        if(value == value_delete){
                          await RequestSender().getResponse(
                            DeleteComment(pCommentId: widget.comment.id)
                          );
                          ViewTaskBloc().commentBlocs.commentSectionBloc.add(CommentSectionFetchEvent());
                        }else if(value == "report"){
                          bool success = await showReportDialog(context,
                              reportType: ReportTypeEnum.COMMENT, id: widget.comment.id,
                              secondId: widget.taskId, name: widget.comment.creator.displayName
                          );
                          if(success != null && success){
                            showReportSuccessFlushBar(context, what: localize(context, key: "comment"));
                          }
                        }else if(value == "profile"){
                          showUserInformationDialog(context, creator: widget.comment.creator);
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
