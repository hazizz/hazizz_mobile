import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/services/task_similarity_checker.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SimilarTaskItemWidget extends StatefulWidget  {

  final TaskSimilarity taskSimilarity;


  SimilarTaskItemWidget({Key key, this.taskSimilarity}) : super(key: key);

  @override
  _SimilarTaskItemWidget createState() => _SimilarTaskItemWidget();
}

class _SimilarTaskItemWidget extends State<SimilarTaskItemWidget> with TickerProviderStateMixin  {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Color mainColor = Colors.grey;

    List<PojoTag> tags = [];
    if(widget.taskSimilarity.task.tags != null && tags != null){
      tags.addAll(widget.taskSimilarity.task.tags);
    }

    Widget mainTag = Container();

    bool doBreak = false;

    List<Widget> tagWidgets = List();

    if(widget.taskSimilarity.task.tags != null){
      for(PojoTag t in widget.taskSimilarity.task.tags) {
        if(!doBreak){
          for(PojoTag defT in PojoTag.defaultTags) {
            if(defT.name == t.name) {
              tags.remove(t);

              mainColor = t.getColor();

              mainTag = Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                      color: mainColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 3, top: 3, right: 6, bottom: 3),
                    child: Text(t.getDisplayName(context),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  )
              );
              doBreak = true;
              break;
            }
          }
        }else{
          break;
        }
      }
      for(PojoTag t in tags){
        tagWidgets.add(Padding(
          padding: const EdgeInsets.only(top: 2, left:2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 2, left: 6, right: 6),
              child: Text(t.getDisplayName(context), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
            ),
          ),
        ));
      }
      tagWidgets.insert(0, mainTag);
    }
    return  Card(
        margin: EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () async {
              dynamic editedTask = await Navigator.pushNamed(context, "/viewTask", arguments: widget.taskSimilarity.task.copy());
              if(editedTask != null){
                HazizzLogger.printLog("old task: ${widget.taskSimilarity.task.toJson()}");
                HazizzLogger.printLog("edited task: ${editedTask.toJson()}");
              }
            },
            child: Stack(
              children: <Widget>[

                Positioned(
                  top: 0, right: 0,
                  child: Text("Hasonlóság: ${widget.taskSimilarity.percent.round()}%"),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width-104,
                          child: Wrap(
                              alignment: WrapAlignment.start,
                              runSpacing: 1.4 ,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 2,
                              children:  tagWidgets
                          ),
                        ),
                      ],
                    ),

                    Builder(
                      builder: (context){
                        if(widget.taskSimilarity.task.subject == null){
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 3, left: 2),
                          child: Container(
                            // color: PojoType.getColor(widget.widget.taskSimilarity.task.type),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: mainColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 2.4, right: 4, bottom: 2.4),
                                child: Text(widget.taskSimilarity.task.subject.name,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                              )
                          ),
                        );
                      },
                    ),

                    Builder(
                      builder: (context){
                        if(widget.taskSimilarity.task.title == null) return Container();
                        return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(widget.taskSimilarity.task.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                              ),
                            ]
                        );
                      },
                    ),

                    Padding(
                        padding: const EdgeInsets.only(right: 20, top: 0, bottom: 0),
                        // child: Text(markdownImageRemover(widget.taskSimilarity.task.description), style: TextStyle(fontSize: 18),),
                        child: Builder(
                          builder: (context){

                            if(widget.taskSimilarity.task.description.length >= 200){

                            }

                            return Stack(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(),
                                    child: Builder(
                                      builder: (context){
                                        Color textColor = Colors.black;
                                        if(HazizzTheme.currentThemeIsDark){
                                          textColor = Colors.white;
                                        }
                                        return Transform.translate(
                                          offset: const Offset(-6, -9),
                                          child: Markdown(data: widget.taskSimilarity.task.description,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),

                                            imageBuilder: (Uri uri, String title, String alt){

                                              final List<String> a = uri.toString().split("?id=");
                                              final String id = a.length > 1 ? a[1] : null;

                                              if(id != null){
                                                return Padding(
                                                  padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                                  child: Container(
                                                    height: 60,
                                                    child: ClipRRect(
                                                      child: Image.network( "https://drive.google.com/thumbnail?id=$id",
                                                        loadingBuilder: (context, child, progress){
                                                          return progress == null
                                                              ? child
                                                              : CircularProgressIndicator();
                                                        },
                                                      ),
                                                      borderRadius: BorderRadius.circular(3),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Padding(
                                                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                                                child: Container(
                                                  height: 60,
                                                  child: ClipRRect(
                                                    child: Image.network(uri.toString(),
                                                      loadingBuilder: (context, child, progress){
                                                        return progress == null
                                                            ? child
                                                            : CircularProgressIndicator();
                                                      },
                                                    ),
                                                    borderRadius: BorderRadius.circular(3),
                                                  ),

                                                ),
                                              );
                                            },
                                            onTapLink: (String url) async {
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              }
                                            },
                                            styleSheet: MarkdownStyleSheet(
                                              p:  TextStyle(fontFamily: "Nunito", fontSize: 14, color: textColor),
                                              h1: TextStyle(fontFamily: "Nunito", fontSize: 26, color: textColor),
                                              h2: TextStyle(fontFamily: "Nunito", fontSize: 24, color: textColor),
                                              h3: TextStyle(fontFamily: "Nunito", fontSize: 22, color: textColor),
                                              h4: TextStyle(fontFamily: "Nunito", fontSize: 20, color: textColor),
                                              h5: TextStyle(fontFamily: "Nunito", fontSize: 18, color: textColor),
                                              h6: TextStyle(fontFamily: "Nunito", fontSize: 16, color: textColor),
                                              a:  TextStyle(fontFamily: "Nunito", color: Colors.blue, decoration: TextDecoration.underline),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]
                            );
                          },
                        )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 1, right: 6),
                          child: Text(widget.taskSimilarity.task.creator.displayName, style: theme(context).textTheme.subtitle2,),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
        )
    );
  }
}