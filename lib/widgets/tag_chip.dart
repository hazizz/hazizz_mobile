import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/theme/hazizz_theme.dart';

class TagChip extends StatefulWidget {

  final Color backgroundColor;

  final Widget child;

  final Function onClick;
  final Function onCloseClick;
  final EdgeInsets padding;

  final bool hasCloseButton;

  final double height;

  TagChip({Key key, @required this.child,
    this.backgroundColor = HazizzTheme.blue, this.hasCloseButton = true,
    this.padding = const EdgeInsets.only(left: 9, right: 9, top: 2, bottom: 2),
    this.onClick, this.onCloseClick,
    this.height})
  : super(key: key);

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
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: widget.onClick,
        child:  Card(
          margin: EdgeInsets.only(top: 0, bottom: 4),
            color: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),

            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
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
                            onTap: () => widget.onCloseClick() ?? (){},
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
      ),
    );
  }
}
