import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'dart:math' as math;


class NoteItemWidget extends StatefulWidget  {

  PojoKretaNote note;


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
      duration: new Duration(milliseconds: 2300 + Random().nextInt(500) ),
    );

    animationController.forward();


    animation =  new Tween(
        begin: math.pi/4 + Random().nextDouble() * math.pi/4,
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

              Transform.rotate(

                origin: Offset( 0, -40),
                angle: animation.value as double,
                child: getWidget(),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 14),
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
                  Center(child: Text(widget.note.content, style: TextStyle(fontSize: 18))),

                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget.note.teacher, style: TextStyle(fontSize: 16)),
                        Text(hazizzShowDateFormat(widget.note.creationDate), style: TextStyle(fontSize: 16)),
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