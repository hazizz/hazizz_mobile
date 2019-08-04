import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/comment_section_bloc.dart';
import 'package:mobile/blocs/view_task_bloc.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/listItems/comment_item_widget.dart';

import '../hazizz_localizations.dart';

class CommentSectionWidget extends StatefulWidget {

 // CommentSectionBloc commentSectionBloc;


 // static CommentBlocs commentBlocs;

  CommentSectionWidget({Key key,}) : super(key: key){
   // commentBlocs = CommentBlocs();

   // commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());
  }

  getTabName(BuildContext context){
    return locText(context, key: "schedule");
  }

  @override
  _CommentSectionWidget createState() => _CommentSectionWidget();
}


class _CommentSectionWidget extends State<CommentSectionWidget>{

  List<PojoComment> comments = List();


 // CommentBlocs commentBlocs = ViewTaskBloc().commentBlocs;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // commentBlocs = CommentSectionWidget.commentBlocs;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
   // commentBlocs.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder(
              condition: (CommentSectionState beforeState, CommentSectionState currentState){
                if(beforeState is CommentSectionLoadedState && currentState is CommentSectionWaitingState){
                  return false;
                }

                return true;
              },
              bloc: ViewTaskBloc().commentBlocs.commentSectionBloc,
              builder: (_, CommentSectionState state){
                print("log CommentSectionState change? $state");
                if(state is CommentSectionLoadedState){
                  print("state is CommentSectionLoadedState: ${state.items}");
                  comments = state.items;
                  if(comments.isNotEmpty) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context2, int index) {
                        return GestureDetector(
                            onTap: () {
                              // Navigator.of(context2).pop();
                              //      onPicked(groups_data[index]);

                            },
                            child: CommentItemWidget(taskId: ViewTaskBloc().commentBlocs.taskId ,comment: comments[index],)
                        );
                      },
                    );
                  }
                  return Center(child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(locText(context, key: "no_comments_yet")),
                  ));
                }
                else if(state is CommentSectionFailState){
                  return Center(child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("something went wro ng"),
                  ));
                }
                else{
                  print("log: state: $state");
                  return Center(child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RefreshProgressIndicator(),
                  ));
                }
              },
            ),

          //  SizedBox(width: 4,),

            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child:

              BlocBuilder(
                bloc: ViewTaskBloc().commentBlocs.commentWriterBloc,
                builder: (_, CommentWriterState commentWriterState) {
                  String error;
                  if(commentWriterState is CommentWriterSentState){

                  }
                  else if(commentWriterState is CommentWriterEmptyState){
                    error = "No comment written";
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: TextField(
                                decoration:
                                InputDecoration(
                                  errorText: error,
                                  labelText: locText(context, key: "write_comment"),),
                                controller: ViewTaskBloc().commentBlocs.commentWriterBloc
                                    .commentController,
                                autofocus: false,
                                maxLines: null,
                                //  minLines: 2,
                                //  maxLines: 5,
                                style: TextStyle(fontSize: 20),
                                //  controller: _commentController,
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0, bottom: 5),
                              child: IconButton(
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                icon: Icon(Icons.send, size: 30,),
                                onPressed: () async {
                                  ViewTaskBloc().commentBlocs.commentWriterBloc.dispatch(CommentWriterSendEvent());
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
            )
          ],
        )
    );
  }
}