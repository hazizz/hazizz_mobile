import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'hazizz_back_button.dart';

class ImageViewerPage extends StatefulWidget {

  File imageFile;
  String imageUrl;
  Object heroTag;

  Function onDelete;
  ImageViewerPage.fromNetwork(this.imageUrl, {Key key, @required this.heroTag, this.onDelete}) : super(key: key);
  ImageViewerPage.fromFile(this.imageFile, {Key key, @required this.heroTag, this.onDelete}) : super(key: key);

  @override
  _ImageViewerPage createState() => _ImageViewerPage();
}

class _ImageViewerPage extends State<ImageViewerPage>{

  List<PojoComment> comments = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // commentBlocs.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Hero(
              tag: widget.heroTag,
              child: Center(child:
              Container(
                  child:  Container(
                    width: MediaQuery.of(context).size.width,
                    child: PhotoView(
                      imageProvider: widget.imageUrl != null ?
                        NetworkImage(widget.imageUrl) :
                        FileImage(widget.imageFile),
                    ),
                  ),
                 // fit: BoxFit.fitWidth,
                )
              )
            ),
            Positioned(
                bottom: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      IconButton(
                        icon: Icon(FontAwesomeIcons.download),
                        onPressed: () async {
                          var response = await get(widget.imageUrl);
                          var documentDirectory = await getApplicationDocumentsDirectory();
                          File file = new File(
                              '${documentDirectory.path}/imagetest.png'
                          );
                        //  File f = File.fromRawPath(response.bodyBytes);
                        //  f.copySync("${documentDirectory.path}/imagetest.png");
                          file.writeAsBytesSync(response.bodyBytes);
                        },
                      ),
                      Builder(
                        builder: (context){
                          if(widget.onDelete == null) return Container();
                          return IconButton(
                            icon: Icon(FontAwesomeIcons.times, color: Colors.red,),
                            onPressed: () async {
                              await widget?.onDelete();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
            ),
            Positioned(
                top: 6, left: 6,
                child: HazizzBackButton()
            )
          ],
        ),
      ),
    );
  }
}
