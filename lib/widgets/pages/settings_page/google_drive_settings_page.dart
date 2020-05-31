import 'package:googleapis/drive/v3.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/managers/google_drive_manager.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class GoogleDriveSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return localize(context, key: "settings");
  }

  GoogleDriveSettingsPage({Key key}) : super(key: key);

  @override
  _GoogleDriveSettingsPage createState() => _GoogleDriveSettingsPage();
}

class _GoogleDriveSettingsPage extends State<GoogleDriveSettingsPage> {

  FileList fileList;

  int gotResponse = 0;

  bool gotAllResponse = false;

  void checkIfGotAllResponse(){
    gotResponse++;
    if(gotResponse >= 2){
      setState(() {
        gotAllResponse = true;
      });
    }
  }

  bool allowed = false;

  List<PojoTask> tasks = [];

  _GoogleDriveSettingsPage();

  @override
  void initState() {
    final DateTime now = DateTime.now();
    getResponse(GetTasksFromMe(
      qStartingDate: now.subtract(365.seconds).hazizzRequestDateFormat,
      qEndDate: now.add(365.seconds).hazizzRequestDateFormat
    )).then((HazizzResponse h){
      tasks = h.convertedData;
      checkIfGotAllResponse();
      print("tasks length: ${tasks.length}");
    });
    AppState.isAllowedGDrive().then((isAllowed){
      if(isAllowed){
        GoogleDriveManager().initialize().then((val){
          getGDriveImages();
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          allowed = isAllowed;
        });
      });
    });
    super.initState();
  }

  Future<void> getGDriveImages() async{
    GoogleDriveManager().getAllHazizzImages().then((list){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted){
          setState(() {
            fileList = list;
            checkIfGotAllResponse();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gDriveImages = [];

    if(fileList != null && fileList.files != null){
      print("filelist: ${fileList.files}");
     // File file in fileList.files
      for(int i = 0; i < fileList.files.length; i++){
        File file = fileList.files[i];

        int taskId;
        print("task: 0: ${file.name.split("_")[0]}");
        try{
          taskId = int.parse(file.name.split("_")[0]);
          print("task: 1: $taskId");
        }catch(e){}

        String salt;

        if(taskId != null){
          for(PojoTask task in tasks){
            print("task: 2: ${task.id}");

            if(task.id == taskId){
              print("task: 3 found: ${task.id}");
              salt = task.salt;
              break;
            }
          }
        }

        gDriveImages.add(
          Container(
            height: 100,
            child: ImageViewer.fromGoogleDrive(
              file.webContentLink,
              heroTag: file.webContentLink,
              salt: salt,
              height: 100,
              onSmallDelete: () async {
                bool deleted = await showSureToDeleteGDriveImageDialog(context, fileId: file.id);
                //  await GoogleDriveManager().deleteHazizzImage(file.id);
                if(deleted){
                  fileList = await GoogleDriveManager().getAllHazizzImages();
                  setState(() {
                    // gDriveImages.clear();

                    gDriveImages.removeAt(i);
                  });
                }
              },
              onDelete: () async {
                bool deleted = await showSureToDeleteGDriveImageDialog(context, fileId: file.id);
              //  await GoogleDriveManager().deleteHazizzImage(file.id);
                if(deleted){
                  fileList = await GoogleDriveManager().getAllHazizzImages();
                  setState(() {
                    // gDriveImages.clear();

                    gDriveImages.removeAt(i);
                  });
                }

                Navigator.pop(context);
              },
            ),
          )
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Text(localize(context, key: "google_drive_settings")),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(localize(context, key: "gdrive_info")),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ListTile(
                title: Text(localize(context, key: "gdrive_enable")),
                trailing: Switch(
                  value: allowed,
                  onChanged: (value) async {
                    if(value){
                      value = await showGrantAccessToGDRiveDialog(context);
                      setState(() {
                        allowed = value;
                      });
                      getGDriveImages();
                    }else{

                      await AppState.setDisallowedGDrive();
                      if(gDriveImages == null || gDriveImages.isNotEmpty){
                        await showSureToDeleteAllGDriveImageDialog(context);
                      }
                      setState(() {
                        allowed = value;
                      });
                    }
                  }
                )
              ),
            ),
            Builder(
              builder: (context){
                if(!allowed) return Container();
                return Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                      title: Text("${localize(context, key: "delete_all_gdrive_images")}:"),
                      trailing: RaisedButton(
                        child: Text(localize(context, key: "delete").toUpperCase(), style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          if(await showSureToDeleteAllGDriveImageDialog(context)){
                             setState(() {
                               gDriveImages.clear();
                             });
                          }
                        },
                      )
                    ),
                    Divider(),
                    Container(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return getGDriveImages();
                        },
                        child: Stack(
                          children: <Widget>[
                            //  ListView(),
                            Builder(
                              builder: (context){
                                if(!allowed) return Container();
                                if(!gotAllResponse) return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                                else if(gDriveImages == null || gDriveImages.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text("no_images_gdrive".localize(context))
                                    )
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
                                  child: Wrap(
                                    runAlignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    alignment: WrapAlignment.start,
                                    runSpacing: 8,
                                    spacing: 8,
                                    children: gDriveImages,
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
      )
    );
  }
}
