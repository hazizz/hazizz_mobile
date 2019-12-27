
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/notification/notification.dart';

class KretaSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "kreta_settings");
  }

  KretaSettingsPage({Key key}) : super(key: key);

  @override
  _KretaSettingsPage createState() => _KretaSettingsPage();
}

class _KretaSettingsPage extends State<KretaSettingsPage>  {


  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;

  bool isRemember = true;
  String notificationTime = "";

  IconData iconBell;

  @override
  void initState() {
    KretaSessionManager.isRememberPassword().then((value){
      setState(() {
        isRemember = value;
        if(value){
          iconBell = FontAwesomeIcons.solidBell;
        }else{
          iconBell = FontAwesomeIcons.solidBellSlash;
        }
      });
    });

    HazizzNotification.getNotificationTime().then((value){
      setState(() {
        notificationTime = value.toHazizzFormat();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "kreta_settings",
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
                          SelectedSessionBloc().dispatch(SelectedSessionSetEvent(selectedSession));
                          setState(() {
                            iconBell = FontAwesomeIcons.solidBellSlash;
                            isRemember = value;

                          });
                        }
                      }
                    )
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
