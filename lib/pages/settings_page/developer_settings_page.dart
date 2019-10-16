
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/storage/cache_manager.dart';
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

import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/custom/hazizz_time_of_day.dart';

class DeveloperSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "developer_settings");
  }


  DeveloperSettingsPage({Key key}) : super(key: key);

  @override
  _DeveloperSettingsPage createState() => _DeveloperSettingsPage();
}

class _DeveloperSettingsPage extends State<DeveloperSettingsPage> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    // widget.myGroupsBloc.dispatch(FetchData());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Hero(
      tag: "developer_settings",
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
                    leading: Icon(FontAwesomeIcons.fileAlt),

                    title: Text(locText(context, key: "logs")),
                    onTap: (){
                      Navigator.pushNamed(context, "/settings/developer/logs");
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.times, color: Colors.red,),

                  title: Text(locText(context, key: "delete_me")),
                  onTap: () async {
                    await showSureToDeleteMeDialog(context);
                  },
                ),

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
