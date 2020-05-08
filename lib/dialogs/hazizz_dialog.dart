import 'package:flutter/material.dart';

class HazizzDialog extends StatefulWidget {

  static const double buttonBarHeight = 48.0;

  final Widget header, content;

  final Widget actionButtons;

  final double height, width;

  HazizzDialog({this.header, this.content, this.actionButtons,@required this.height,@required this.width});

  @override
  _HazizzDialog createState() => new _HazizzDialog();
}

class _HazizzDialog extends State<HazizzDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
            height: widget.height + HazizzDialog.buttonBarHeight,
            width: widget.width,
            decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: <Widget>[
                Container(
                  //  height: 64.0,
                  width: widget.width*2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    //   color: Theme.of(context).primaryColor
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: Center(child: widget.header),
                  ),
                ),

                Expanded(
                  child: Builder(
                      builder: (BuildContext context){
                        if(widget.content != null){
                          return widget.content;
                        }
                        return Container();
                      }
                  ),
                ),
                //  Spacer(),

                //  SizedBox(height: 20.0),

                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      widget.actionButtons,
                    ],
                  ),
                )
              ],
            )
        ));
  }
}