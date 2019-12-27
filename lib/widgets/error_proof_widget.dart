import 'package:flutter/material.dart';


class ErrorProofWidget extends StatefulWidget {
  Widget child;

  Widget onErrorWidget;

  ErrorProofWidget({Key key, @required this.child, this.onErrorWidget}) : super(key: key);

  @override
  _ErrorProofWidget createState() => _ErrorProofWidget();
}

class _ErrorProofWidget extends State<ErrorProofWidget> {

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
    try{
      return widget.child;
    }catch(e){
      return widget.onErrorWidget;
    }
  }
}
