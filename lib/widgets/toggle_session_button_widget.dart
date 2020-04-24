import 'package:flutter/material.dart';
import 'package:mobile/theme/hazizz_theme.dart';


class ToggleSessionButton extends StatefulWidget {

  Color backgroundColor = HazizzTheme.blue;

  bool isSelected;
  String sessionName;

  EdgeInsets padding = EdgeInsets.all(0);

  ToggleSessionButton({Key key, @required this.sessionName, this.isSelected, this.padding,}) : super(key: key){
    padding ??= EdgeInsets.only(left: 9, right: 9, top: 7, bottom: 7);
  }

  @override
  _ToggleSessionButton createState() => _ToggleSessionButton();
}

class _ToggleSessionButton extends State<ToggleSessionButton> {

  bool isSelected = false;

  @override
  void initState() {
    widget.isSelected = isSelected;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: Card(

            margin: EdgeInsets.only(top: 8, bottom: 8),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            child: Material(
              color: Colors.red,
            //  type: MaterialType.transparency,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    color: isSelected ? Colors.lightBlue : Colors.white,
                    child: Padding(
                      padding: widget.padding,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.sessionName, style: TextStyle(fontSize: 16),),
                          ]
                      ),
                    ),
                  ),
                ),

            )
        ),

    );
  }
}
