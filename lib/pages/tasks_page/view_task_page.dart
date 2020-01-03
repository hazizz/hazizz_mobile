import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/comment_section_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/view_task_bloc.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/dialogs/report_dialog.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/managers/deep_link_receiver.dart';
import 'package:mobile/managers/google_drive_manager.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/widgets/comment_section_widget.dart';
import 'package:mobile/widgets/error_proof_widget.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/google_drive_image_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';
import 'package:mobile/widgets/tag_chip.dart';
import 'package:share/share.dart';
import 'package:snappable/snappable.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTaskPage extends StatefulWidget {

  CommentSectionWidget commentSectionWidget = CommentSectionWidget();

  bool fromId = false;
  int taskId;
  PojoTask pojoTask;

  ViewTaskPage.fromId({Key key, this.taskId}) : assert(taskId != null), super(key: key){
    fromId = true;
  }

  ViewTaskPage.fromPojo({Key key, this.pojoTask}) :assert(pojoTask != null), super(key: key){
    taskId = pojoTask.id;
    HazizzLogger.printLog("created ViewTaskPage.fromPojo");
  }

  @override
  _ViewTaskPage createState() => _ViewTaskPage();
}

class _ViewTaskPage extends State<ViewTaskPage> {

  ScrollController _scrollController = ScrollController();

  static final AppBar appBar = AppBar(
    title: Text("what's my purpose?"),
  );

  static final double padding = 4;


  bool completed = true;
  bool isFirstTime = true;

  String _subject = "";
  String _group = "";
  String _creator = "";
  //String _type = "";
  List<PojoTag> _tags = List();
  String _deadline = "";
  String _description = "";
  String _title = "";
  PojoTag mainTag = null;

  List<PojoTask> task_data = List();

  bool showComments = false;

  PojoTask pojoTask;
  Image img;


  void _processData(BuildContext context, PojoTask pojoTask){
    widget.pojoTask = pojoTask;
    setState(() {
      _subject = pojoTask.subject != null ? pojoTask.subject.name : null;
      _group = pojoTask.group?.name;

      _creator = pojoTask.creator.displayName;

     // _type = pojoTask.tags[0].getDisplayName(context);

      if(pojoTask.tags != null){
        for(PojoTag t in pojoTask.tags){
          for(PojoTag defT in PojoTag.defaultTags){
            if(t.name ==  defT.name){
              mainTag = t;
            }
          }
        }
        _tags = pojoTask.tags;
      }

      DateTime date_deadline =  pojoTask.dueDate;
      _deadline = hazizzShowDateFormat(date_deadline);//"${date_deadline.day}.${date_deadline.month}.${date_deadline.year}";
      _description = pojoTask.description;
      _title = pojoTask.title;

      tagWidgets = List();

      if(pojoTask.tags != null){
        for(PojoTag t in pojoTask.tags){
          if(mainTag == null ||  t.name != mainTag.name){
            tagWidgets.add(
                TagChip(child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 21, ),),
                  hasCloseButton: false,
                )
            );
          }
        }
      }

      if(isFirstTime){
        completed = pojoTask.completed;
        isFirstTime = false;
      }


    });
  }

  List<Widget> tagWidgets;

  bool canModify = false;

  final snapKey = GlobalKey<SnappableState>();
  
  bool noPermission = false;

  @override
  void initState() {

    Future<void> _init(PojoTask pTask){
      pojoTask = pTask;

      InfoCache.getMyId().then((int result){
        if(pojoTask.creator.id == result){
          setState(() {
            canModify = true;
          });
        }
      });
      if(pojoTask.permission == GroupPermissionsEnum.OWNER
      || pojoTask.permission == GroupPermissionsEnum.MODERATOR
      ){
        setState(() {
          canModify = true;
        });
      }

      ViewTaskBloc().reCreate(pojoTask: pojoTask);
    }
    
    if(widget.fromId){
      getResponse(GetTaskByTaskId(p_taskId: widget.taskId)).then((hazizzResponse){
        if(hazizzResponse.isSuccessful){
          _init(hazizzResponse.convertedData);
        }else if(hazizzResponse.pojoError != null){
          if(hazizzResponse.pojoError.errorCode == 11){
            setState(() {
              noPermission = true;
            });
          }
        }
      });
    }else{
      _init(widget.pojoTask);
    }



    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(pojoTask != null) {
      _processData(context, pojoTask);
    }

    return WillPopScope(
          onWillPop: (){
            Navigator.pop(context, pojoTask);
            return Future.value(false);
          },
          child: Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(onPressed: (){
              Navigator.pop(context, pojoTask);
            },),
            title: Text(locText(context, key: "view_task")),
            actions: <Widget>[
              Builder(
                builder: (context){
                  if(pojoTask == null || widget.pojoTask.assignation.name.toLowerCase() == "thera") return Container();
                  return PopupMenuButton(
                    icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                    onSelected: (value) async {
                      if(value == "report"){
                        bool success = await showReportDialog(context, reportType: ReportTypeEnum.TASK, id: widget.pojoTask.id, name: "");
                        if(success != null && success){
                          showReportSuccessFlushBar(context, what: locText(context, key: "task"));
                        }
                      }else if(value == "share"){
                        await Share.share(locText(context, key: "invite_to_task_text_title", args: [DeepLink.createLinkToTask(pojoTask.id)]));
                      }
                      else if(value == "snap"){
                        snapKey.currentState.snap();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: "share",
                          child: Text(locText(context, key: "share"),
                          ),
                        ),
                        PopupMenuItem(
                          value: "report",
                          child: Text(locText(context, key: "report"),
                            style: TextStyle(color: HazizzTheme.red),
                          ),
                        )
                      ];
                    },
                  );
                },
              )
            ],
          ),
          body:Snappable(
            key: snapKey,
            child: RefreshIndicator(
              onRefresh: () async{
               // widget.commentSectionWidget.commentBlocs.commentSectionBloc.add(CommentSectionFetchEvent());
                ViewTaskBloc().commentBlocs.commentSectionBloc.dispatch(CommentSectionFetchEvent());

              },
              child: Builder(
                builder: (context){
                  if(noPermission) return Text(locText(context, key: "no_permission_to_view"));
                  else if(pojoTask == null) return Center(child:  CircularProgressIndicator(),);
                  return Stack(
                      children: [ListView(
                        controller: _scrollController,
                        children: [ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3,
                          //  maxHeight: (MediaQuery.of(context).size.height-appBar.preferredSize.height - padding*3)*2,

                            minWidth: MediaQuery.of(context).size.width,
                            maxWidth: MediaQuery.of(context).size.width,

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: Card(
                              margin: EdgeInsets.only(bottom: 20),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 100,
                              child:new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        Container(
                                            color: mainTag != null ? mainTag.getColor(): Theme.of(context).primaryColor,
                                            //  width: 400,

                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                                                    child: Builder(builder: (context){
                                                      HazizzLogger.printLog("redrawing coz completed: $completed");
                                                      if(completed == null) return Container();
                                                      IconData iconData;
                                                      if(completed){
                                                        return IconButton(
                                                            icon: Icon(FontAwesomeIcons.checkSquare, size: 32,),
                                                            onPressed: () async {
                                                              setState(() {
                                                                completed = false;
                                                                pojoTask.completed = false;

                                                              });
                                                              HazizzResponse hazizzResponse = await RequestSender().getResponse(SetTaskCompleted(p_taskId: pojoTask.id, setCompleted: false));
                                                              if(hazizzResponse.isError){
                                                                setState(() {
                                                                  completed = true;
                                                                  pojoTask.completed = true;

                                                                });
                                                              }
                                                            }
                                                        );
                                                      }
                                                      return IconButton(
                                                          icon: Icon(FontAwesomeIcons.square, size: 32,),
                                                          onPressed: () async {
                                                            setState(() {
                                                              completed = true;
                                                              pojoTask.completed = true;

                                                            });
                                                            HazizzResponse hazizzResponse = await RequestSender().getResponse(SetTaskCompleted(p_taskId: pojoTask.id, setCompleted: true));
                                                            if(hazizzResponse.isError){
                                                              setState(() {
                                                                completed = false;
                                                                pojoTask.completed = false;

                                                              });
                                                            }
                                                          }
                                                      );
                                                    }),
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Builder(
                                                      builder: (context){
                                                        if(mainTag != null){
                                                          return Padding(
                                                            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2),
                                                            child: new Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                new Flexible(
                                                                    child: Text(mainTag.getDisplayName(context),
                                                                      style: TextStyle(
                                                                          fontSize: 36,
                                                                          fontWeight: FontWeight.w800
                                                                      ),
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                        return Container();
                                                      },
                                                    ),
                                                    Wrap(
                                                      alignment: WrapAlignment.start,
                                                      spacing: 8,
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: tagWidgets,
                                                    ),

                                                    GestureDetector(
                                                      onTap: (){
                                                        showUserDialog(context, creator: pojoTask.creator);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 2),
                                                        child: new Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 8.0, left: 3),
                                                              child: Icon(FontAwesomeIcons.userAlt),
                                                            ),
                                                            new Flexible(
                                                              child: Text(pojoTask.creator.displayName,
                                                                style: TextStyle(
                                                                  fontSize: 20
                                                                ),
                                                              )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    Builder(
                                                      builder: (context){
                                                        if(pojoTask.group != null){
                                                          return GestureDetector(
                                                            onTap: (){
                                                              Navigator.pushNamed(context, "/group/groupId", arguments: widget.pojoTask.group);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 2),
                                                              child: new Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 11.0),
                                                                    child: Icon(FontAwesomeIcons.users),
                                                                  ),
                                                                  new Flexible(
                                                                    child: Text(pojoTask.group.name,
                                                                      style: TextStyle(
                                                                          fontSize: 21
                                                                      ),
                                                                    )
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return Container();
                                                      },
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 16.0, right: 20.0, bottom: 4),
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8.0, left: 3),
                                                            child: Icon(FontAwesomeIcons.calendarTimes),
                                                          ),

                                                          new Flexible(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 4.0),
                                                              child: Text(_deadline,
                                                                style: TextStyle(
                                                                    fontSize: 20
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        Stack(
                                          children: <Widget>[

                                            Column(
                                              children: <Widget>[
                                                _subject != null ? Padding(
                                                  padding: const EdgeInsets.only( left: 0,top: 0),
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      new Flexible(
                                                        child:
                                                        new Container(
                                                          // color: PojoType.getColor(pojoTask.type),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                                              color: mainTag != null ? mainTag.getColor(): Theme.of(context).primaryColor,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 0),
                                                              child: Text(pojoTask.subject.name,
                                                                style: TextStyle(fontSize: 32),
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ) : Container(),
                                                Builder(
                                                  builder: (context){
                                                    if(_title == null) return Container();
                                                    return Padding(
                                                      padding: const EdgeInsets.only( left: 10,top: 5),
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          new Flexible(
                                                            child: new Text(_title,
                                                              style: TextStyle(
                                                                //  fontFamily: "ShortStack",
                                                                  fontSize: 33
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only( left: 4, right: 4, top: 4),
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      new Flexible(
                                                          child: Builder(
                                                            builder: (context){
                                                              Color textColor = Colors.black;
                                                              if(HazizzTheme.currentThemeIsDark){
                                                                textColor = Colors.white;
                                                              }
                                                              return Markdown(data: _description,
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                imageBuilder: (uri){
                                                                  print("mivan?1");

                                                                  if(uri.host != "drive.google.com"){
                                                                    return Padding(
                                                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                                        child: ImageViewer.fromNetwork(
                                                                          uri.toString(),key: Key(uri.toString()),
                                                                          heroTag: uri.toString(),

                                                                        )
                                                                    );
                                                                  }
                                                                //  List<String> urlList = uri.toString().split("~~");

                                                                  print("mivan?2");

                                                                  print("mivan?3");

                                                                  return Padding(
                                                                    padding: const EdgeInsets.only(bottom: 8.0),
                                                                    child: GoogleDriveImage(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      imageUrl: uri.toString(),
                                                                      heroTag: uri,
                                                                      salt: pojoTask.salt,
                                                                      showThumbnail: true,

                                                                    ),
                                                                  );

                                                                  return ErrorProofWidget(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                                      child: FutureBuilder(
                                                                        future: img != null ? Future.value(false) : /*RequestSender().getResponse(new GetUploadedImage(
                                                                url: uri.toString()
                                                            )), */
                                                                        http.get(uri),
                                                                        builder: (context, responseState){
                                                                          if(img != null){
                                                                            return ErrorProofWidget(child: img, onErrorWidget: Text("something wrong"),);
                                                                          }
                                                                          else if(responseState.connectionState == ConnectionState.done){
                                                                            // HazizzResponse g = responseState.data;
                                                                            // g.response.data
                                                                            String cryptedBase64Img = responseState.data.body;

//                                                                String cryptedBase64Img = responseState.data.response.data;
                                                                            String base64Img = HazizzCrypt.decrypt(cryptedBase64Img, pojoTask.salt);
                                                                            Uint8List byteImg = Base64Decoder().convert(base64Img);

                                                                            return ErrorProofWidget(
                                                                              child: ImageViewer.fromBytes(
                                                                                byteImg,
                                                                                heroTag: uri,

                                                                              )
                                                                            );
                                                                          }else{
                                                                            return Center(child: CircularProgressIndicator(),);
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    onErrorWidget: Text("something wrong")
                                                                    ,

                                                                  );
                                                                },
                                                                styleSheet: MarkdownStyleSheet(
                                                                  p:  TextStyle(fontFamily: "Nunito", fontSize: 20, color: textColor),
                                                                  h1: TextStyle(fontFamily: "Nunito", fontSize: 32, color: textColor),
                                                                  h2: TextStyle(fontFamily: "Nunito", fontSize: 30, color: textColor),
                                                                  h3: TextStyle(fontFamily: "Nunito", fontSize: 28, color: textColor),
                                                                  h4: TextStyle(fontFamily: "Nunito", fontSize: 26, color: textColor),
                                                                  h5: TextStyle(fontFamily: "Nunito", fontSize: 24, color: textColor),
                                                                  h6: TextStyle(fontFamily: "Nunito", fontSize: 22, color: textColor),
                                                                  a:  TextStyle(fontFamily: "Nunito", color: Colors.blue, decoration: TextDecoration.underline),
                                                                ),
                                                                onTapLink: (String url) async {
                                                                  if (await canLaunch(url)) {
                                                                    await launch(url);
                                                                  }
                                                                },
                                                              );

                                                            },
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        BlocBuilder(
                                            bloc: ViewTaskBloc().commentBlocs.commentSectionBloc,
                                            builder: (context, state){

                                              Widget chip = Container();

                                              if(state is CommentSectionLoadedState){
                                                chip = Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50.0),

                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                                                    child: Text(state.items.length.toString()),
                                                  ), color: Colors.red,
                                                );
                                              }

                                              return Stack(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets.only(top: 3.0, right: 3),
                                                      child: Builder(
                                                        builder: (context){
                                                          if(widget.pojoTask.assignation.name.toLowerCase() == "thera") return Container();
                                                          return FlatButton(
                                                              onPressed: () async {
                                                                setState(() {
                                                                  showComments = true;
                                                                });
                                                                await Future.delayed(const Duration(milliseconds: 50));
                                                                _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.ease, duration: Duration(milliseconds: 340));
                                                              },

                                                              child: Text(locText(context, key: "comments").toUpperCase(), style: theme(context).textTheme.button)

                                                          );

                                                        },
                                                      )
                                                  ),
                                                  Positioned(top: 0, right: 0,
                                                    child: chip,
                                                  )
                                                ],
                                              );

                                            }
                                        ),
                                        Builder(
                                            builder: (context){
                                              if(canModify){

                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      onPressed: () async {
                                                        var editedTask = await Navigator.of(context).pushNamed( "/editTask", arguments: pojoTask);
                                                        if(editedTask != null && editedTask is PojoTask){
                                                          setState(() {
                                                            pojoTask = editedTask;
                                                            _processData(context, pojoTask);
                                                          });
                                                          MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
                                                        }
                                                      },
                                                      child: Text(locText(context, key: "edit").toUpperCase(), style: theme(context).textTheme.button,),
                                                    ),
                                                    FlatButton(
                                                      child: Text(locText(context, key: "delete").toUpperCase(), style: TextStyle(color: Colors.red),),
                                                      onPressed: () async {
                                                        if(await showDeleteTaskDialog(context, taskId: widget.taskId)){
                                                          HazizzLogger.printLog("showDeleteTaskDialog : success");
                                                          MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
                                                          List<String> splited = pojoTask.description.split("\n![img_");
                                                          if(splited.length > 1){
                                                            await GoogleDriveManager().initialize();
                                                            for(int i = 1; i < splited.length; i++){
                                                              String n = splited[i].split("id=")[1];
                                                              GoogleDriveManager().deleteHazizzImage(n.substring(0, n.length-1));
                                                            }
                                                          }

                                                          Navigator.of(context).pop();

                                                        }else{
                                                          HazizzLogger.printLog("showDeleteTaskDialog: no success");

                                                        }

                                                      },

                                                    ),
                                                  ],
                                                );
                                              }
                                              else return Container();
                                            }
                                        )
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ),
                          Builder(
                            builder: (BuildContext context){
                              if(showComments) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                      padding: EdgeInsets.all(padding),
                                      child:
                                      widget.commentSectionWidget
                                  ),
                                );
                              }
                              return Container();
                            },
                          )
                        ],
                      ),
                      ]
                  );
                },
              )
            ),
          )
        ),
      );
  }
}
