import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/my_groups_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/settings_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/listItems/group_item_widget.dart';
import 'package:mobile/listItems/member_item_widget.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:preferences/preferences.dart';

import '../hazizz_localizations.dart';


class SettingsPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTitle(BuildContext context){
    return locText(context, key: "settings");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> with AutomaticKeepAliveClientMixin {

  PreferenceTitle title = PreferenceTitle("asd");

  List<DropdownMenuItem> items = List();

  int currentStartPageItemIndex = 0;


  _SettingsPage();

  @override
  void initState() {
   // widget.myGroupsBloc.dispatch(FetchData());

    StartPageService.getStartPageIndex().then(
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
    print("log: redrawing");
    if(items.isEmpty) {

      List<StartPageItem> startPages = StartPageService.getStartPages(context);
      for(StartPageItem startPage in startPages) {
        items.add(DropdownMenuItem(
          value: startPage.index,
          child: Text(startPage.name,
            textAlign: TextAlign.end,
          ),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.getTitle(context)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
              ListTile(
                    title: Text(locText(context, key: "startPage")),
                    subtitle: Text("subbtitle"),
                    trailing: DropdownButton(
                      
                      items: items,
                      onChanged: (dynamic newStartPageIndex) async {
                        StartPageService.setStartPageIndex(newStartPageIndex);
                        setState(() {
                          currentStartPageItemIndex = newStartPageIndex;
                        });
                      },
                      value: currentStartPageItemIndex,
                    ),
                  ),

              Divider(),
          ],
        ),
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

