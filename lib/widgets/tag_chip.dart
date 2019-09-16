import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../hazizz_theme.dart';


class TagChip extends StatefulWidget {

  Color backgroundColor = HazizzTheme.blue;

  Widget child;

  Function onClick;
  Function onCloseClick;
  EdgeInsets padding = EdgeInsets.all(0);

  bool hasCloseButton = true;

  TagChip({Key key, @required this.child, this.backgroundColor, this.hasCloseButton, this.padding, this.onClick, this.onCloseClick}) : super(key: key){
    padding ??= EdgeInsets.only(left: 9, right: 9, top: 2, bottom: 2);
    onClick ??= (){};
    onCloseClick ??= (){};
  }

  @override
  _TagChip createState() => _TagChip();
}

class _TagChip extends State<TagChip> {

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



    return GestureDetector(
      onTap: ()=> widget.onClick(),
      child:  Card(

            margin: EdgeInsets.only(top: 5, bottom: 5),
              color: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 10,
              child: Padding(
                padding: widget.padding,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.child,

                      Builder(
                        builder: (context){
                          if(widget.hasCloseButton){
                            return GestureDetector(
                              onTap: (){widget.onCloseClick();},
                               // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(FontAwesomeIcons.solidTimesCircle, size: 20, /*color: Colors.red,*/),
                                ),
                              //  iconSize: 20,
                               // onPressed: () => widget.onCloseClick
                            );
                          }
                          return Container();
                        },
                      )

                    ]
                ),
              )
          ),
    );
  }
}
