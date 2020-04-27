import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/widgets/image_viewer_page.dart';
import 'package:http/http.dart' as http;

enum ImageType{
  NETWORK,
  FILE,
  MEMORY,
  GOOGLE_DRIVE,
}

class ImageViewer extends StatefulWidget {

  ImageType imageType;

  final double height;
  final double width;

  File imageFile;
  String imageUrl;
  Uint8List imageBytes;

  Object heroTag;

  final Function onSmallDelete;
  final Function onDelete;

  Image image;
  String salt;
  bool loadImageEnabled = PreferenceService.imageAutoLoad;
  Image thumbnailImage;
  bool tapped = false;

  HazizzImageData imageData;

  ImageViewer.fromNetwork(this.imageUrl, {Key key, @required this.heroTag, this.onSmallDelete, this.onDelete, this.width, this.height}) : super(key: key){
    image = Image.network(imageUrl, key: Key(imageUrl),
      loadingBuilder: (context, child, progress){
        return progress == null
          ? child
          : CircularProgressIndicator();
      },
    );
    imageType = ImageType.NETWORK;
  }
  ImageViewer.fromFile(this.imageFile, {Key key, @required this.heroTag, this.onSmallDelete, this.onDelete, this.width, this.height}) : super(key: key){
    image = Image.file(imageFile,);
    imageType = ImageType.FILE;
  }
  ImageViewer.fromBytes(this.imageBytes, {Key key, @required this.heroTag, this.onSmallDelete, this.onDelete, this.width, this.height}) : super(key: key){
    image = Image.memory(imageBytes);
    imageType = ImageType.MEMORY;
  }


  ImageViewer.fromGoogleDrive(this.imageUrl, {Key key, @required this.salt, @required this.heroTag, this.onSmallDelete, this.onDelete, this.width, this.height}) : super(key: key){
    thumbnailImage = Image.network(
      "https://drive.google.com/thumbnail?id=${imageUrl.split("?id=")[1]}",
      width: width,
      fit: BoxFit.fitWidth,
      height: height,
      loadingBuilder: (context, child, progress){
        return progress == null
          ? child
          : CircularProgressIndicator();
      },
    );
    imageType = ImageType.GOOGLE_DRIVE;
  }

  ImageViewer.fromHazizzImageData(this.imageData, {Key key, this.onSmallDelete, this.onDelete, this.width, this.height}) : super(key: key){
    if(imageData.imageType == ImageType.FILE){
      image = Image.file(imageData.imageFile);
      heroTag = imageData.imageFile.path;
      imageType = ImageType.FILE;
      imageFile = imageData.imageFile;
    }else if(imageData.imageType == ImageType.NETWORK){
      image = Image.network(imageData.url,
        loadingBuilder: (context, child, progress){
          return progress == null
              ? child
              : CircularProgressIndicator();
        },
      );
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
        loadingBuilder: (context, child, progress){
          return progress == null
              ? child
              : CircularProgressIndicator();
        },
      );
      imageType = ImageType.GOOGLE_DRIVE;
      heroTag = imageData.url ;//+ HeroHelper.uniqueTag;
    }
  }

  @override
  _ImageViewer createState() => _ImageViewer();
}


class _ImageViewer extends State<ImageViewer> with AutomaticKeepAliveClientMixin{

  List<PojoComment> comments = List();

  bool uploading = false;

  bool noSalt = false;
  bool tapped = false;
  bool untouchable = false;

  File imageFile;
  String imageUrl;
  Uint8List imageBytes;


  double width, height;

  Image image, thumbnailImage;

  Future request;

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
    image = widget.image;
    width = widget.width;
    height = widget.height;
    imageFile = widget.imageFile;
    imageBytes = widget.imageBytes;

    imageUrl = widget.imageUrl;

    if(widget.imageType == ImageType.GOOGLE_DRIVE){
      request = http.get(imageUrl);
      thumbnailImage = Image.network(
        "https://drive.google.com/thumbnail?id=${imageUrl.split("?id=")[1]}",
        width: width,
        fit: BoxFit.fitWidth,
        height: height,
        loadingBuilder: (context, child, progress){
          return progress == null
              ? child
              : CircularProgressIndicator();
        },
      );
      if( (height != null && width == null) || (width != null && height == null) ){
        _calculateImageDimension(thumbnailImage).then((Size size){
          if(height != null){
            double resizePercent = widget.height / size.height;
            setState(() {
              width = size.width * resizePercent;

            });
          }else{
            double resizePercent = widget.width / size.width;
            setState(() {
              height = size.height * resizePercent;
            });

          }
          print("size is: ${size.width}, ${size.height}");
        });
      }

    }

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

  @override
  void dispose() {
    super.dispose();
  }

  Widget errorImageWidget(String text){
    return Container(
      height: height ?? 180,
      width: width ?? 100,
      child: Card(
        color: Colors.grey,
        child: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
            minFontSize: 5,
            maxFontSize: 18,
          ),
        )),
      ),
    );
  }

  Widget deletedImageWidget(){
    return errorImageWidget(locText(context, key: "gdrive_image_deleted"));
  }

  Widget noSaltImageWidget(){
    return errorImageWidget(locText(context, key: "gdrive_image_no_salt"));
  }

  Widget otherErrorImageWidget(){
    return errorImageWidget(locText(context, key: "gdrive_image_other_error"));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("uploading: $uploading");
    return Container(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: (){
          if(!untouchable && !noSalt){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if(widget.imageType == ImageType.NETWORK){
                return ImageViewerPage.fromNetwork(imageUrl,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
              }else if(widget.imageType == ImageType.MEMORY) {
                return ImageViewerPage.fromBytes(imageBytes, heroTag: widget.heroTag, onDelete: widget.onDelete,);
              }else if(widget.imageType == ImageType.FILE){
                return ImageViewerPage.fromFile(imageFile,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
              }else if(widget.imageType == ImageType.GOOGLE_DRIVE){
                return ImageViewerPage.fromBytes(imageBytes,  heroTag: widget.heroTag, onDelete: widget.onDelete,);
              }
              return null;
            }));
          }
        },
        child: Container(
         // tag: widget.heroTag,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                child: Builder(
                  builder: (context){
                    if(widget.imageType == ImageType.GOOGLE_DRIVE){
                      if(!widget.loadImageEnabled){
                        print("people be like :O 2");
                        return thumbnailWidget(loadImage);
                      }
                      print("people be like :O 3");

                      return FutureBuilder(
                        future: imageBytes != null ? Future.value(false) :
                        request,
                        builder: (context, responseState){
                          print("people be like :O 4");


                          if(imageBytes != null){
                            print("people be like :O 6");
                            return Image.memory(
                              imageBytes,
                            );
                          }
                          else if(responseState.connectionState == ConnectionState.done){
                            print("people be like :O 7");
                            if(widget.salt == null || widget.salt == "" || widget.salt == "--------------------------------"){
                              noSalt = true;
                              return noSaltImageWidget();
                            }else if(responseState.data == null) return otherErrorImageWidget();
                            else if(responseState.data.statusCode == 200 ){
                              String cryptedBase64Img = responseState.data.body;
                              String base64Img = HazizzCrypt.decrypt(cryptedBase64Img, widget.salt);
                              imageBytes = Base64Decoder().convert(base64Img);

                              return ImageViewer.fromBytes(
                                  imageBytes,
                                  heroTag: widget.heroTag,
                                  onDelete: widget.onDelete,
                                  onSmallDelete: widget.onSmallDelete,
                                  height: height,
                                );
                            }else if(responseState.data.statusCode == 404 ){
                              print("sadsd: 1 ${responseState.data.statusCode}");
                              print("asd: $imageUrl");
                              untouchable = true;
                              return deletedImageWidget();
                            }
                            print("sadsd: 1 ${responseState.data.statusCode}");
                            print("asd: ${imageUrl}");
                            untouchable = true;
                            return otherErrorImageWidget();
                          }else{
                            print("people be like :O 8");
                            if(imageBytes == null){
                              print("people be like :O 5");
                              return thumbnailWidget(null);
                            }
                            return thumbnailWidget(null);
                          }
                        },
                      );
                    }
                    return image;
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
      height: height,
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
                    padding: const EdgeInsets.only(top: 60, left: 20, right: 20,),
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

  @override
  bool get wantKeepAlive => true;
}
