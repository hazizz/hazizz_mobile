import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'hazizz_back_button.dart';
import 'image_viewer_widget.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class ImageViewerPage extends StatefulWidget {
  final ImageType imageType;
  final Uint8List imageBytes;
  final File imageFile;
  final String imageUrl;

  final Object heroTag;
  final Function onDelete;

  ImageViewerPage.fromNetwork(
      this.imageUrl, {Key key, @required this.heroTag, this.onDelete})
      : imageType = ImageType.NETWORK,
        imageBytes = null, imageFile = null,
        super(key: key);

  ImageViewerPage.fromFile(
      this.imageFile, {Key key, @required this.heroTag, this.onDelete})
      : imageType = ImageType.FILE,
        imageBytes = null, imageUrl = null,
        super(key: key);

  ImageViewerPage.fromBytes(this.imageBytes, {Key key, @required this.heroTag, this.onDelete})
      : imageType= ImageType.MEMORY,
        imageFile = null, imageUrl = null,
        super(key: key);

  ImageViewerPage.fromGoogleDrive(this.imageBytes, {Key key, @required this.heroTag, this.onDelete})
      : imageType = ImageType.MEMORY,
        imageFile = null, imageUrl = null,
        super(key: key);

  @override
  _ImageViewerPage createState() => _ImageViewerPage();
}

class _ImageViewerPage extends State<ImageViewerPage>{

  List<PojoComment> comments = List();

  bool downloading = false;

  Uint8List imageBytes;
  File imageFile;
  String imageUrl;

  @override
  void initState() {
    imageBytes = widget.imageBytes;
    imageFile = widget.imageFile;
    imageUrl = widget.imageUrl;

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
      imageProvider = NetworkImage(imageUrl);
    }else if(widget.imageType == ImageType.FILE){
      imageProvider = FileImage(imageFile);
    }else if(widget.imageType == ImageType.MEMORY){
      imageProvider = MemoryImage(imageBytes);
    }else if(widget.imageType == ImageType.GOOGLE_DRIVE){
      imageProvider = MemoryImage(imageBytes);
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
                    imageProvider: imageProvider,
                    enableRotation: true,
                    maxScale: PhotoViewComputedScale.covered * 2.5,
                    minScale: PhotoViewComputedScale.contained * 0.8,
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
                    if(widget.imageType != ImageType.FILE) Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: IconButton(
                        enableFeedback: true,
                        icon: Icon(FontAwesomeIcons.download, color: downloading ? Colors.grey : Colors.white,),
                        onPressed: () async {
                          if(!downloading){
                            setState(() {
                              downloading = true;
                            });

                            if(! (await Permission.storage.status.isGranted)){//await Permission.checkPermissionStatus(PermissionGroup.storage) != PermissionStatus.granted){
                              PermissionStatus permissionStatus = await Permission.storage.request();
                              if(!permissionStatus.isGranted){
                                setState(() {
                                  downloading = false;
                                });
                                return;
                              }
                            }
                            if(imageFile != null) {
                              await ImageGallerySaver.saveImage(imageFile.readAsBytesSync());
                            }else if(imageBytes != null){
                              await ImageGallerySaver.saveImage(imageBytes);
                            }else{
                              var response = await  Dio().get(imageUrl, options: Options(responseType: ResponseType.bytes));
                              await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
                            }
                            showToast(localize(context, key: "image_saved"), duration: 3.seconds);
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
