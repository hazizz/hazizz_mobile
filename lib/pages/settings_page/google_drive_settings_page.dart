import 'package:googleapis/drive/v3.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/google_drive_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/other/settings_bloc.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';


class GoogleDriveSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "settings");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  GoogleDriveSettingsPage({Key key}) : super(key: key);

  @override
  _GoogleDriveSettingsPage createState() => _GoogleDriveSettingsPage();
}

class _GoogleDriveSettingsPage extends State<GoogleDriveSettingsPage> with AutomaticKeepAliveClientMixin {

  String currentLanguageCode ;//= Locale("en", "EN");

  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;

  FileList fileList;

  bool gotResponse = false;

  _GoogleDriveSettingsPage();


  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // widget.myGroupsBloc.add(FetchData());

    getPreferredLocale().then((preferredLocale){
      setState(() {
        currentLanguageCode = preferredLocale.languageCode;
      });
    });

    PreferenceService.getStartPageIndex().then(
            (int value){
          setState(() {
            currentStartPageItemIndex = value;
          });
        }
    );

    GoogleDriveManager().initialize().then((val){
      GoogleDriveManager().getAllHazizzImages().then((list){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            fileList = list;
            gotResponse = true;
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gDriveImages = [];

    if(fileList != null && fileList.files != null){
     // File file in fileList.files
      for(int i = 0; i < fileList.files.length; i++){
       /* gDriveImages.add(ClipRRect(
          child: Image.network(url, height: 100,),
          borderRadius: BorderRadius.circular(3),
        ),);*/

        File file = fileList.files[i];
        gDriveImages.add(
          Container(
            child: ImageViewer.fromNetwork(
              file.webContentLink,
              heroTag: file.webContentLink,
              height: 100,
              onDelete: () async {
                await GoogleDriveManager().deleteHazizzImage(file.id);
                fileList = await GoogleDriveManager().getAllHazizzImages();
                setState(() {
                 // gDriveImages.clear();

                  gDriveImages.removeAt(i);
                });
                Navigator.pop(context);
              },
            ),
          )
        );
      }
    }

    if(startPageItems.isEmpty) {
      List<StartPageItem> startPages = PreferenceService.getStartPages(context);
      for(StartPageItem startPage in startPages) {
        startPageItems.add(DropdownMenuItem(
          value: startPage.index,
          child: Text(startPage.name,
            textAlign: TextAlign.end,
          ),
        ));
      }
    }
    if(supportedLocaleItems.isEmpty){
      supportedLocales = getSupportedLocales();

      HazizzLogger.printLog("supported locales: ${supportedLocales.toString()}");

      for(Locale locale in supportedLocales) {

        supportedLocaleItems.add(DropdownMenuItem(
          value: locale.languageCode,
          child: Text(locale.languageCode,
            textAlign: TextAlign.end,
          ),
        ));
      }
    }

    HazizzLogger.printLog("log: $supportedLocaleItems");

    return Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(),
            title: Text(locText(context, key: "google_drive_settings")),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, "/about");
                    },
                    title: Text(locText(context, key: "about")),
                    trailing: Switch(
                      value: true,
                      onChanged: (change){

                      },
                    )
                  ),
                ),
                Divider(),
                ListTile(
                    title: Text(locText(context, key: "delete_all_gdrive_images")),
                    trailing: RaisedButton(
                      child: Text(locText(context, key: "delete"), style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        await GoogleDriveManager().deleteAllHazizzImages();
                      },
                    )
                ),
                Divider(),
                ListTile(
                    title: Text(locText(context, key: "delete_all_gdrive_images")),
                    trailing: RaisedButton(
                      child: Text(locText(context, key: "delete"), style: TextStyle(color: Colors.red),),
                      onPressed: () async {
                        await GoogleDriveManager().deleteAllHazizzImages();
                      },
                    )
                ),
                Divider(),

                Builder(
                  builder: (context){
                    if(!gotResponse) return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                    else if(gDriveImages == null || gDriveImages.isEmpty) return Center(child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(locText(context, key: "no_images_gdrive")),
                    ),);
                    return Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
                      child: Wrap(
                        runSpacing: 8,
                        spacing: 8,
                        children: gDriveImages,
                      ),
                    );
                  },
                )
              ],
            ),
          )
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}
