import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';
import 'hazizz_back_button.dart';
import 'image_viewer_widget.dart';

class ImageViewerPage extends StatefulWidget {

  ImageType imageType;


  Uint8List imageBytes;
  File imageFile;
  String imageUrl;

  Object heroTag;

  Function onDelete;
  ImageViewerPage.fromNetwork(this.imageUrl, {Key key, @required this.heroTag, this.onDelete}) : super(key: key){
    imageType = ImageType.NETWORK;
  }
  ImageViewerPage.fromFile(this.imageFile, {Key key, @required this.heroTag, this.onDelete}) : super(key: key){
    imageType = ImageType.FILE;
  }
  ImageViewerPage.fromBytes(this.imageBytes, {Key key, @required this.heroTag, this.onDelete}) : super(key: key){
    imageType= ImageType.MEMORY;
  }
  ImageViewerPage.fromGoogleDrive(this.imageBytes, {Key key, @required this.heroTag, this.onDelete}) : super(key: key){
    imageType = ImageType.MEMORY;
  }

  @override
  _ImageViewerPage createState() => _ImageViewerPage();
}

class _ImageViewerPage extends State<ImageViewerPage>{

  List<PojoComment> comments = List();

  bool downloading = false;

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

    ImageProvider imageProvider;
    if(widget.imageType == ImageType.NETWORK){
      imageProvider = NetworkImage(widget.imageUrl);
    }else if(widget.imageType == ImageType.FILE){
      imageProvider = FileImage(widget.imageFile);
    }else if(widget.imageType == ImageType.MEMORY){
      imageProvider = MemoryImage(widget.imageBytes);
    }else if(widget.imageType == ImageType.GOOGLE_DRIVE){
      imageProvider = MemoryImage(widget.imageBytes);
    }
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
              child: Center(child: Container(
                child:  Container(
                  width: MediaQuery.of(context).size.width,
                  child: PhotoView(
                    imageProvider: imageProvider
                  ),
                ),
                )
              )
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black45,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: IconButton(
                        enableFeedback: true,
                        icon: Icon(FontAwesomeIcons.download, color: downloading ? Colors.grey : Colors.white,),
                        onPressed: () async {

                          if(!downloading){
                            setState(() {
                              downloading = true;
                            });
                            if(await PermissionHandler().checkPermissionStatus(PermissionGroup.storage) != PermissionStatus.granted){
                              Map<PermissionGroup, PermissionStatus> permission = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                              if(permission[PermissionGroup.storage] != PermissionStatus.granted){
                                setState(() {
                                  downloading = false;
                                });
                                return;
                              }
                            }

                            if(widget.imageFile != null) {
                              await ImageGallerySaver.saveImage(widget.imageFile.readAsBytesSync());
                            }else if(widget.imageBytes != null){
                              await ImageGallerySaver.saveImage(widget.imageBytes);
                            }else{
                              var response = await  Dio().get(widget.imageUrl, options: Options(responseType: ResponseType.bytes));
                              await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
                            }
                            Toast.show(locText(context, key: "image_saved"), context, duration: 3);
                            setState(() {
                              downloading = false;
                            });
                          }
                        },
                      ),
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
              top: 0, left: 0,
              child: Container(
                width:  MediaQuery.of(context).size.width,
                color: Colors.black45,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, left: 3, top: 2),
                    child: HazizzBackButton.light(),
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
