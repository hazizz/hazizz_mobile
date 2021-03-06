import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/profile_editor_blocs.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/custom/image_operations.dart';


class ProfileEditorPage extends StatefulWidget {
  ProfileEditorPage({Key key}) : super(key: key);

  @override
  _ProfileEditorPage createState() => _ProfileEditorPage();
}

class _ProfileEditorPage extends State<ProfileEditorPage> with TickerProviderStateMixin{

  _ProfileEditorPage();

  ProfileEditorBlocs profileEditorBlocs = ProfileEditorBlocs();

  @override
  void initState() {
   // widget.myGroupsBloc.add(FetchData());
    super.initState();
  }

  Future<bool> getImage() async {

   // File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File image;

    if(image == null){
      HazizzLogger.printLog("picked image is null ");
      return false;
    }


  /*  image = await ImageCropper.cropImage(
      controlWidgetColor: Theme.of(context).primaryColor,
      controlWidgetVisibility: false,
      circleShape: true,
      toolbarColor: Theme.of(context).primaryColor,
      toolbarWidgetColor: Theme.of(context).iconTheme.color,
      toolbarTitle: locText(context, key: "edit_profile_picture"),
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );*/
    if(image == null){
      return false;
    }

    profileEditorBlocs.pictureEditorBloc.add(ProfilePictureEditorChangedEvent(imageBytes: image.readAsBytesSync()));

    return true;
  }

  @override
  void dispose() {
    profileEditorBlocs.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text("profile_editor".localize(context)),
        ),
        body: Container(
          width: 400,
          height: 700,
          child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                BlocBuilder(
                  bloc: profileEditorBlocs.pictureEditorBloc,
                  builder: (context, state){
                    return Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 140,
                            height: 140,
                            child: GestureDetector(
                              onTap: (){
                              //  getImage();
                              },
                              child: CircleAvatar(
                                  child: BlocBuilder(
                                    bloc: profileEditorBlocs.pictureEditorBloc,
                                    builder: (context, state){
                                    ImageProvider profilePicProvider;
                                    if(profileEditorBlocs.pictureEditorBloc.profilePictureBytes == null){
                                      profilePicProvider = null;
                                      return Text(localize(context, key: "loading"));
                                    }else{

                                      var sad= profileEditorBlocs.pictureEditorBloc.profilePictureBytes;
                                      var sad2 = ImageOperations.fromBytesImageToBase64(sad);
                                      var sad3 = ImageOperations.fromBase64ToBytesImage(sad2);

                                      profilePicProvider = Image.memory(sad3).image;

                                      return Container(
                                        decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            image: profilePicProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: new BorderRadius.all(const Radius.circular(80.0)),
                                        ),
                                      );
                                    }
                                  })
                              ),
                            ),
                          ),
                        ),
                        /*
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Builder(
                            builder: (context){
                              Function onPress;

                              if(state is ProfilePictureEditorChangedState){
                                _currentProfilePicIconData = _checkIconData;
                                onPress = (){
                                  profileEditorBlocs.pictureEditorBloc.add(ProfilePictureEditorSavedEvent());
                                };
                              }else if(state is ProfilePictureEditorFineState){
                                _currentProfilePicIconData = _editIconData;
                                onPress = () async {
                                  await getImage();
                                };
                              }else if(state is ProfilePictureEditorWaitingState){
                                _currentProfilePicIconData = FontAwesomeIcons.spinner;
                                onPress = null;
                              }else{
                                _currentProfilePicIconData = _editIconData;

                                onPress = () async {
                                  await getImage();
                                };
                              }

                              return FloatingActionButton(
                                heroTag: "hero_fab_profile_editor_photo",

                                onPressed: onPress,
                                child: Icon(_currentProfilePicIconData),
                              );
                            },
                          ),
                        )
                        */
                      ],
                    );
                  },
                ),

                BlocBuilder(
                  bloc: profileEditorBlocs.displayNameEditorBloc,
                  builder: (context, state){
                    IconData iconData;
                    if(state is DisplayNameChangedState){
                      iconData = FontAwesomeIcons.check;
                    }else{
                      iconData = FontAwesomeIcons.solidEdit;
                    }

                    return Container(
                      width: 300,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: profileEditorBlocs.displayNameEditorBloc.displayNameController,
                              style: TextStyle(fontSize: 22),
                               maxLength: 20,
                              decoration: InputDecoration(
                                  labelText: localize(context, key: "displayName")
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: "hero_fab_profile_editor_name",
                            child: Icon(iconData),
                            onPressed: false ? (){
                              profileEditorBlocs.displayNameEditorBloc.add(DisplayNameSendEvent());
                            } : null,
                          )
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
        )
    );
  }
}

