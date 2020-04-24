import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  String title;
  List<String> options;
  Function onSent;
  Function onClose;

  bool radioType = true;

  FormWidget.radioType({Key key, this.title, this.options, this.onSent, this.onClose, }) : super(key: key){
    radioType = true;
  }
  FormWidget.checkboxType({Key key, this.title, this.options, this.onSent, this.onClose, }) : super(key: key){
    radioType = false;
  }

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {

  List<Widget> children;
  var groupValue;

  @override
  void initState() {
    for(String s in widget.options){
      children.add(Row(
        children: <Widget>[
          widget.radioType ? Radio() : Checkbox(),
          Text(s)
        ],
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Column(
        children: <Widget>[
          Text(""),
          Column(
            children: children
          ),
          RaisedButton(
            onPressed: (){

            },
          )
        ],
      )
    );
  }
}