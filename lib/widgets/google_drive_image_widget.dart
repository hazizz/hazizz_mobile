import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/widgets/error_proof_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/widgets/image_viewer_widget.dart';

class GoogleDriveImage extends StatefulWidget {

  bool showThumbnail;
 // bool loadImage = PreferenceService.imageAutoLoad;
  
  String salt;
  String imageUrl;

  Object heroTag;

  Function onSmallDelete;
  Function onDelete;

  double height;
  double width;


  GoogleDriveImage({@required this.imageUrl, this.heroTag, @required this.salt, this.onSmallDelete, this.onDelete, this.height, this.width, this.showThumbnail = true});
  @override
  _GoogleDriveImage createState() => _GoogleDriveImage();
}

class _GoogleDriveImage extends State<GoogleDriveImage>{

  Uint8List byteImg;

  bool loadImageEnabled = PreferenceService.imageAutoLoad;

  Image thumbnailImage;

  bool tapped = false;
  bool deleted = false;

  double height;
  double width;




  Future<Size> _calculateImageDimension(Image image) {
    Completer<Size> completer = Completer();
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }




  @override
  void initState() {
    width = widget.width;
    height = widget.height;
    if(widget.showThumbnail){

      thumbnailImage = Image.network(
        "https://drive.google.com/thumbnail?id=${widget.imageUrl.split("?id=")[1]}",
        width: widget.width,
        fit: BoxFit.fitWidth,
        height: widget.height,
      );
      _calculateImageDimension(thumbnailImage).then((Size size){

        if(widget.height != null){
          double resizePercent = widget.height / size.height;

          setState(() {
            widget.width = size.width * resizePercent;
            width = widget.width;
          });
        }

        print("size is: ${size.width}, ${size.height}");
      });
    }

    if(widget.showThumbnail){


      /*
      http.get("https://drive.google.com/thumbnail?id=${widget.imageUrl.split("?id=")[1]}").then((Response response){
        Image.network("https://drive.google.com/thumbnail?id=${widget.imageUrl.split("?id=")[1]}");
      });
      */
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadImage(){
    print("loading inmage");
    setState(() {
      loadImageEnabled = true;
    });
  }

  Widget thumbnailWidget(Function onTapped){
    return Container(
      child: Stack(
        children: <Widget>[
          ClipRRect(
              child: GestureDetector(
                  onTap: (){
                    if(onTapped != null) onTapped();
                    tapped = true;
                  },
                  child: thumbnailImage
              ),
              borderRadius: BorderRadius.circular(4),
            ),

          Builder(
            builder: (context){

              print("heightttt: ${thumbnailImage?.height}");


              if(tapped){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            },
          )

        ],
      ),
    );
  }

  Widget deletedImageWidget(){
    return Container(
      height: 180,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(8))
        //   color: Theme.of(context).primaryColor
      ),
      child: Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(locText(context, key: "gdrive_image_deleted"), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {

    print("widet size: ${widget.width}, ${widget.height}");
    if(deleted) return deletedImageWidget();

    return Container(
      width: width,
      height: height,
      child: Builder(
        builder: (context){
          print("niggas be like :O 1");
          if(widget.showThumbnail && false){
            return Image.network("https://drive.google.com/thumbnail?id=${widget.imageUrl.split("?id=")[1]}");

          }

          print("niggas be like :O 1.1");
          if(!loadImageEnabled || widget.salt == null){
            print("niggas be like :O 2");
            return thumbnailWidget(loadImage);
          }
          print("niggas be like :O 3");

          return FutureBuilder(
            future: byteImg != null ? Future.value(false) : /*RequestSender().getResponse(new GetUploadedImage(
                                                                  url: uri.toString()
                                                          )), */
            http.get(widget.imageUrl),
            builder: (context, responseState){
              print("niggas be like :O 4");


              if(byteImg != null){
                print("niggas be like :O 6");
                return ErrorProofWidget(
                  child: ImageViewer.fromBytes(
                    byteImg,
                    heroTag: widget.imageUrl,
                  ),
                  onErrorWidget: Text("something wrong"),
                );
              }
              else if(responseState.connectionState == ConnectionState.done){
                print("niggas be like :O 7");
                if(responseState.data.statusCode == 200){
                  String cryptedBase64Img = responseState.data.body;
                  String base64Img = HazizzCrypt.decrypt(cryptedBase64Img, widget.salt);
                  byteImg = Base64Decoder().convert(base64Img);

                  return ErrorProofWidget(
                    child: ImageViewer.fromBytes(
                      byteImg,
                      heroTag: widget.heroTag,
                      onDelete: widget.onDelete,
                      onSmallDelete: widget.onSmallDelete,
                      height: widget.height,
                    ),
                    onErrorWidget: Text("something wrong"),
                  );
                }else{
                  deleted = true;
                  return deletedImageWidget();
                }

              }else{
                print("niggas be like :O 8");
                if(widget.showThumbnail && byteImg == null){
                  print("niggas be like :O 5");
                  return thumbnailWidget(null);
                }
                return thumbnailWidget(null);
              }
            },
          );
        },
      ),
    );
  }
}
