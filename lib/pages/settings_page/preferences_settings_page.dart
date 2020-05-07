import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/managers/preference_services.dart';


class PreferencesSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "preferences");
  }

  PreferencesSettingsPage({Key key}) : super(key: key);

  @override
  _PreferencesSettingsPage createState() => _PreferencesSettingsPage();
}

class _PreferencesSettingsPage extends State<PreferencesSettingsPage> {

  List<DropdownMenuItem> startPageItems = List();

  int currentStartPageItemIndex = 0;

  bool autoLoad = PreferenceService.imageAutoLoad;
  bool autoDownload = PreferenceService.imageAutoDownload;

  bool enabledAd = PreferenceService.enabledAd;


  bool isRemember = true;

  IconData iconBell;

  _PreferencesSettingsPage();

  @override
  void initState() {
    PreferenceService.getStartPageIndex().then((int value){
      setState(() {
        currentStartPageItemIndex = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Hero(
      tag: "settings_preferences",
      child: Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(),
            title: Text(widget.getTitle(context)),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                ListTile(
                    title: Text(locText(context, key: "enable_ads")),
                    leading: Icon(FontAwesomeIcons.ad),
                    trailing: Switch(
                      value: enabledAd,
                      onChanged: (val){
                        setState(() {
                          enabledAd = val;
                          PreferenceService.setEnabledAd(enabledAd);
                        });
                      },
                    )
                ),
                Divider(),
                ListTile(
                    title: Text(locText(context, key: "starting_page")),
                    leading: Icon(FontAwesomeIcons.doorOpen),
                    trailing: DropdownButton(
                      items: startPageItems,
                      onChanged: (dynamic newStartPageIndex) async {
                        PreferenceService.setStartPageIndex(newStartPageIndex);
                        setState(() {
                          currentStartPageItemIndex = newStartPageIndex;
                        });
                      },
                      value: currentStartPageItemIndex,
                    ),
                  ),
                Divider(),
                ListTile(
                  title: Text(locText(context, key: "remember_kreta_password")),
                  trailing: Switch(
                    value: isRemember,
                    onChanged: (value){
                      HazizzLogger.printLog("remember kreta password is enabled: ${value}");
                      KretaSessionManager.setRememberPassword(value);
                      if(value){

                        setState(() {
                          iconBell = FontAwesomeIcons.solidBell;
                          isRemember = value;
                        });
                      }else{
                        PojoSession selectedSession = SelectedSessionBloc().selectedSession;
                        if(selectedSession != null){
                          selectedSession.password = null;
                        }
                        SelectedSessionBloc().add(SelectedSessionSetEvent(selectedSession));
                        setState(() {
                          iconBell = FontAwesomeIcons.solidBellSlash;
                          isRemember = value;

                        });
                      }
                    }
                  )
                ),
                Divider(),
                ListTile(
                  title: Text(locText(context, key: "auto_load_image")),
                  leading: Icon(FontAwesomeIcons.spinner),
                  trailing: Switch(
                    value: autoLoad,
                    onChanged: (val){
                      setState(() {
                        autoLoad = val;
                        PreferenceService.setImageAutoLoad(autoLoad);
                      });
                    },
                  )
                ),
                Divider(),
                ListTile(
                  title: Text(locText(context, key: "auto_download_image")),
                  leading: Icon(FontAwesomeIcons.download),
                  trailing: Switch(
                    value: autoDownload,
                    onChanged: (val){
                      setState(() {
                        autoDownload = val;
                        PreferenceService.setImageAutoDownload(autoDownload);
                      });
                    },
                  )
                ),
                Divider(),
              ],
            ),
          )
      ),
    );
  }
}
