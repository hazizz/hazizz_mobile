import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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

  @override
  void didChangeDependencies() {

    if(widget.showThumbnail){
      thumbnailImage = Image.network(
        "https://drive.google.com/thumbnail?id=${widget.imageUrl.split("?id=")[1]}",
        width: widget.width,
        fit: BoxFit.fitWidth,
        height: widget.height,
      );
    }
    super.didChangeDependencies();
  }
  @override
  void initState() {
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
      height: widget.height,
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
              if(tapped){
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Container();
            },
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    print("niggas be like :O 1");
    if(widget.showThumbnail && false){
      return Image.network("https://drive.google.com/thumbnail?id=${widget.imageUrl.split("?id=")[1]}");

    }

    print("niggas be like :O 1.1");
    if(!loadImageEnabled){
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
          print("niggas be like :O 8");
          if(widget.showThumbnail && byteImg == null){
            print("niggas be like :O 5");
            return thumbnailWidget(null);
          }
          return thumbnailWidget(null);
        }
      },
    );
  }
}
