import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/google_drive_manager.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'dialogs.dart';

class GrantAccessToGDRiveDialog extends StatefulWidget {
  GrantAccessToGDRiveDialog({Key key}) : super(key: key);

  @override
  _GrantAccessToGDRiveDialog createState() => new _GrantAccessToGDRiveDialog();
}

class _GrantAccessToGDRiveDialog extends State<GrantAccessToGDRiveDialog> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double height = 100;
    double width = 280;


    var dialog = HazizzDialog(height: height, width: width,
      header: Container(
        width: width,
        height: height,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          AutoSizeText(locText(context, key: "gdrive_grant_permission"),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 20,
            maxFontSize: 20,
            minFontSize: 12,
          ),
        ),
      ),
      actionButtons: Row(
        children: <Widget>[
          FlatButton(
            child: new Text(locText(context, key: "cancel").toUpperCase()),
            onPressed: () async {
              await AppState.setDisallowedGDrive();

              Navigator.pop(context, false);

            },
          ),

          FlatButton(
            child: new Text(locText(context, key: "allow").toUpperCase()),
            onPressed: () async {
              bool allowed = await GoogleDriveManager().initialize();
              await AppState.setAllowedGDrive();
              Navigator.pop(context, allowed);
            },
          ),

        ],
      ),
    );
    return dialog;
  }
}