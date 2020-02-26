import 'package:flutter/material.dart';

class CardHeaderWidget extends StatefulWidget {
  final String text, secondText;
  final Color backgroundColor;
  CardHeaderWidget({Key key, @required this.text, this.secondText, this.backgroundColor}) : super(key: key);

  @override
  _CardHeaderWidgetState createState() => _CardHeaderWidgetState();
}

class _CardHeaderWidgetState extends State<CardHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 2),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: widget.backgroundColor ?? Theme.of(context).primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.only(top: 1.5, bottom: 1.5, left: 4),
          child: InkWell(
              child: widget.secondText!= null ?
                Row(
                  children: <Widget>[
                    Text(widget.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    SizedBox(width: 20),
                    Text("${widget.secondText}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                )
                : Row(
                  children: <Widget>[
                    Text(widget.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    Spacer()
                  ],
              ),
          ),
        )
    );
  }
}