import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ErrorProofNetworkImageWidget extends StatefulWidget {
  String url;

  Widget onErrorWidget;

  ErrorProofNetworkImageWidget({Key key, @required this.url, @required this.onErrorWidget}) : super(key: key);

  @override
  _ErrorProofNetworkImageWidget createState() => _ErrorProofNetworkImageWidget();
}

class _ErrorProofNetworkImageWidget extends State<ErrorProofNetworkImageWidget> {

  Image image;

  Widget onErrorWidget;

  bool error = false;

  @override
  void initState() {
    onErrorWidget = widget.onErrorWidget;

    http.get(widget.url).then((Response response){
      try{
        Uint8List imageBytes = Base64Decoder().convert(response.body);

        WidgetsBinding.instance.addPostFrameCallback((_){
          if(mounted){
            setState(() {
              image = Image.memory(imageBytes);
            });
          }
        });
      }catch(e, s){
        print("exception: ${e.toString()}");
        print(s);
        WidgetsBinding.instance.addPostFrameCallback((_){
          if(mounted){
            setState(() {
              error =true;
            });
          }
        }
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(!error){
      if(image == null){
        return Container();
      }
      return image;
    }
    return onErrorWidget;
  }
}
