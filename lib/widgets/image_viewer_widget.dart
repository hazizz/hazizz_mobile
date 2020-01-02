import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/widgets/image_viewer_page.dart';
import 'package:http/http.dart' as http;

import 'error_proof_widget.dart';


enum ImageType{
  NETWORK,
  FILE,
  MEMORY,
  GOOGLE_DRIVE
}

class ImageViewer extends StatefulWidget {

  ImageType imageType;

  double height;
  double width;

  File imageFile;
  String imageUrl;
  Uint8List imageBytes;

  Object heroTag;

  Function onSmallDelete;
  Function onDelete;

  Image image;



  String salt;
  Uint8List byteImg;

  bool loadImageEnabled = PreferenceService.imageAutoLoad;

  Image thumbnailImage;

  bool tapped = false;

  HazizzImageData imageData;

  ImageViewer.fromNetwork(this.imageUrl, {Key key, @required this.heroTag, this.onSmallDelete, this.onDelete, this.height}) : super(key: key){
    //http.get(imageUrl);
    print("recreatedd!!!");
    image = Image.network(imageUrl, key: Key(imageUrl),);
    imageType = ImageType.NETWORK;
  }
  ImageViewer.fromFile(this.imageFile, {Key key, @required this.heroTag, this.onSmallDelete, this.onDelete, this.height}) : super(key: key){
    image = Image.file(imageFile,);
    imageType = ImageType.FILE;
  }
  ImageViewer.fromBytes(this.imageBytes, {Key key, @required this.heroTag, this.onSmallDelete, this.onDelete, this.height}) : super(key: key){
    image = Image.memory(imageBytes);
    imageType = ImageType.MEMORY;
  }


  ImageViewer.fromGoogleDrive(this.imageUrl, {Key key, @required this.salt, @required this.heroTag, this.onSmallDelete, this.onDelete, this.width, this.height}) : super(key: key){
    thumbnailImage = Image.network(
      "https://drive.google.com/thumbnail?id=${imageUrl.split("?id=")[1]}",
      width: width,
      fit: BoxFit.fitWidth,
      height: height,
    );
    imageType = ImageType.GOOGLE_DRIVE;
  }

  ImageViewer.fromHazizzImageData(this.imageData, {Key key, this.onSmallDelete, this.onDelete, this.height}) : super(key: key){
    if(imageData.imageType == ImageType.FILE){
      image = Image.file(imageData.imageFile);
      heroTag = imageData.imageFile.path;
      imageType = ImageType.FILE;
      imageFile = imageData.imageFile;
    }else if(imageData.imageType == ImageType.NETWORK){
      image = Image.network(imageData.url);
      heroTag = imageData.url;
      imageType = ImageType.NETWORK;
    }else if(imageData.imageType == ImageType.GOOGLE_DRIVE){
      salt = imageData.key;
      imageUrl = imageData.url;
      thumbnailImage = Image.network(
        "https://drive.google.com/thumbnail?id=${imageUrl.split("?id=")[1]}",
        width: width,
        fit: BoxFit.fitWidth,
        height: height,
      );
      imageType = ImageType.GOOGLE_DRIVE;
      heroTag = imageData.url ;//+ HeroHelper.uniqueTag;
    }
  }

  @override
  _ImageViewer createState() => _ImageViewer();
}


class _ImageViewer extends State<ImageViewer>{

  List<PojoComment> comments = List();

  bool uploading = false;

  @override
  void initState() {
    if(widget.imageType == ImageType.FILE && widget.imageData != null){
      uploading = true;

      widget.imageData.futureUploadedToDrive.then((_){
        if(mounted){
          setState(() {
            uploading = false;
          });
        }
      });

    }
    super.initState();
  }


  bool tapped = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // commentBlocs.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("uploading: $uploading");
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            if(widget.imageType == ImageType.NETWORK){
              return ImageViewerPage.fromNetwork(widget.imageUrl,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
            }else if(widget.imageType == ImageType.MEMORY) {
              return ImageViewerPage.fromBytes(widget.imageBytes, heroTag: widget.heroTag, onDelete: widget.onDelete,);
            }else if(widget.imageType == ImageType.FILE){
              return ImageViewerPage.fromFile(widget.imageFile,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
            }else if(widget.imageType == ImageType.GOOGLE_DRIVE){
              return ImageViewerPage.fromBytes(widget.byteImg,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
            }
            return null;

          }
          ));
        },
        child: Hero(
          tag: widget.heroTag,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                child: Builder(
                  builder: (context){
                    if(widget.imageType == ImageType.GOOGLE_DRIVE){
                      if(!widget.loadImageEnabled){
                        print("niggas be like :O 2");
                        return thumbnailWidget(loadImage);
                      }
                      print("niggas be like :O 3");

                      return FutureBuilder(
                        future: widget.byteImg != null ? Future.value(false) : /*RequestSender().getResponse(new GetUploadedImage(
                                                                url: uri.toString()
                                                        )), */
                        http.get(widget.imageUrl),
                        builder: (context, responseState){
                          print("niggas be like :O 4");


                          if(widget.byteImg != null){
                            print("niggas be like :O 6");
                            return ErrorProofWidget(
                              child: Image.memory(
                                widget.byteImg,
                              ),
                              onErrorWidget: Text("something wrong"),
                            );
                          }
                          else if(responseState.connectionState == ConnectionState.done){
                            print("niggas be like :O 7");
                            String cryptedBase64Img = responseState.data.body;
                            String base64Img = HazizzCrypt.decrypt(cryptedBase64Img, widget.salt);
                            widget.byteImg = Base64Decoder().convert(base64Img);

                            return ErrorProofWidget(
                              child: Image.memory(
                                widget.byteImg,
                                height: widget.height,
                              ),
                              onErrorWidget: Text("something wrong"),
                            );
                          }else{
                            print("niggas be like :O 8");
                            if(widget.byteImg == null){
                              print("niggas be like :O 5");
                              return thumbnailWidget(null);
                            }
                            return thumbnailWidget(null);
                          }
                        },
                      );
                    }
                    return widget.image;
                  },
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              Builder(
                builder: (context){
                  print("boi??0");
                  if(widget.onSmallDelete == null) return Container(width: 1,);
                  print("boi??1");
                  return Positioned(
                      top: 3, left: 3,
                      child: GestureDetector(
                        child: Icon(FontAwesomeIcons.solidTimesCircle, size: 20, color: Colors.red,),
                        onTap: () async {
                          await widget.onSmallDelete();
                        },
                      )
                  );
                },
              ),
              Builder(
                builder: (context){
                  if(uploading && false){
                    return Container(
                      color: Colors.white12,
                      child: Center(
                        child: Icon(FontAwesomeIcons.cloudUploadAlt),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void loadImage(){
    print("loading inmage");
    setState(() {
      widget.loadImageEnabled = true;
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
                child: widget.thumbnailImage
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
          ),
        ],
      ),
    );
  }
}
