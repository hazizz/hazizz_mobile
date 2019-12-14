import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/widgets/image_viewer_page.dart';

class ImageViewer extends StatefulWidget {

  double height;

  File imageFile;
  String imageUrl;
  Object heroTag;

  Function onDelete;

  ImageViewer.fromNetwork(this.imageUrl, {Key key, @required this.heroTag, this.onDelete, this.height}) : super(key: key);
  ImageViewer.fromFile(this.imageFile, {Key key, @required this.heroTag, this.onDelete, this.height}) : super(key: key);

  @override
  _ImageViewer createState() => _ImageViewer();
}

class _ImageViewer extends State<ImageViewer>{

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
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          if(widget.imageUrl != null){
            return ImageViewerPage.fromNetwork(widget.imageUrl,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
          }else{
            return ImageViewerPage.fromFile(widget.imageFile,  heroTag: widget.heroTag, onDelete: widget.onDelete,);

          }
        }
        ));
      },
      child: Hero(
        tag: widget.heroTag,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              child: widget.imageUrl != null ?
                Image.network(widget.imageUrl, height: widget.height,) :
                Image.file(widget.imageFile, height: widget.height,),
              borderRadius: BorderRadius.circular(8),
            ),
            Builder(
              builder: (context){

                if(widget.onDelete == null) return Container(width: 1,);
                return Positioned(
                    top: 1, left: 1,
                    child: GestureDetector(
                      child: Icon(FontAwesomeIcons.solidTimesCircle, size: 20, color: Colors.red,),
                      onTap: (){
                        setState(() {

                        });
                      },
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
