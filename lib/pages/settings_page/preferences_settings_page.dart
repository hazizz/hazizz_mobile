
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/blocs/other/settings_bloc.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class PreferencesSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "preferences");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  PreferencesSettingsPage({Key key}) : super(key: key);

  @override
  _PreferencesSettingsPage createState() => _PreferencesSettingsPage();
}

class _PreferencesSettingsPage extends State<PreferencesSettingsPage> with AutomaticKeepAliveClientMixin {

  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;


  _PreferencesSettingsPage();


  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // widget.myGroupsBloc.add(FetchData());

    PreferenceService.getStartPageIndex().then(
            (int value){
          setState(() {
            currentStartPageItemIndex = value;
          });
        }
    );

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
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
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
                ),
                Divider(),
              ],
            ),
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
