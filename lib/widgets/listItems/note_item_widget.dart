import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';


class NoteItemWidget extends StatefulWidget  {

  final PojoKretaNote note;

  NoteItemWidget({Key key, this.note}) : super(key: key);

  @override
  _NoteItemWidget createState() => _NoteItemWidget();
}

class _NoteItemWidget extends State<NoteItemWidget> with SingleTickerProviderStateMixin {

  AnimationController animationController;

  Animation animation;

  @override
  void initState() {
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2300 + Random().nextInt(500) ),
    );

    animationController.forward();


    animation =  new Tween(
        begin: math.pi/5 + Random().nextDouble() * math.pi/5,
        end: 0.0//-math.pi/50,// -math.pi/6
    ).animate(new CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.elasticOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child : getWidget(),
      builder: (BuildContext context, Widget _widget) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(
            children: <Widget>[

              Transform(
                child: getWidget(),
                alignment: FractionalOffset.topCenter,
                transform: new Matrix4.rotationZ(animation.value as double,),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 14, top: 0),
                child: Transform.scale(
                  scale: 1.4,
                  child: Transform.rotate(
                    angle: math.pi/6,
                    child: Center(
                      child: Icon(
                          FontAwesomeIcons.mapPin
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget getWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Center(child: AutoSizeText(widget.note.title, style: TextStyle(fontSize: 23), minFontSize: 18, maxFontSize: 24,)),
                )
            ),
            Padding(
              padding: EdgeInsets.only(left: 4, right: 4, top: 4),
              child: Column(
                children: <Widget>[
                  Center(child: Builder(
                    builder: (c){
                      Color textColor = Colors.black;
                      if(HazizzTheme.currentThemeIsDark){
                        textColor = Colors.white;
                      }
                      return  Markdown(
                        selectable: true,
                        data: widget.note.content,
                        // selectable: true,
                        padding:  const EdgeInsets.only(left: 4, top: 10, bottom: 4),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        styleSheet: MarkdownStyleSheet(
                          p:  TextStyle(fontFamily: "Nunito", fontSize: 15, color: textColor),
                          h1: TextStyle(fontFamily: "Nunito", fontSize: 29, color: textColor),
                          h2: TextStyle(fontFamily: "Nunito", fontSize: 27, color: textColor),
                          h3: TextStyle(fontFamily: "Nunito", fontSize: 25, color: textColor),
                          h4: TextStyle(fontFamily: "Nunito", fontSize: 23, color: textColor),
                          h5: TextStyle(fontFamily: "Nunito", fontSize: 21, color: textColor),
                          h6: TextStyle(fontFamily: "Nunito", fontSize: 19, color: textColor),
                          a:  TextStyle(fontFamily: "Nunito", color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                        onTapLink: (String url) async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                      );
                    },
                  )),

                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget.note.teacher, style: TextStyle(fontSize: 16)),
                        Text(widget.note.creationDate.hazizzShowDateFormat, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}