import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/google_drive_manager.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dialogs.dart';

class SureToDeleteAllHazizzImageDialog extends StatefulWidget {

  SureToDeleteAllHazizzImageDialog();

  @override
  _SureToDeleteAllHazizzImageDialog createState() => new _SureToDeleteAllHazizzImageDialog();
}

class _SureToDeleteAllHazizzImageDialog extends State<SureToDeleteAllHazizzImageDialog> {


  String groupName;

  bool isLoading = false;

  bool isMember = false;

  bool someThingWentWrong = false;

  @override
  void initState() {


    super.initState();
  }


  final double width = 300;
  final double height = 120;


  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
        header: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              color: HazizzTheme.red,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child:
                  Center(
                    child: Builder(builder: (context){
                      return AutoSizeText(locText(context, key: "areyousure_delete_all_images"),
                          maxFontSize: 20,
                          minFontSize: 12,
                          maxLines: 10,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )
                      );

                    }),
                  )
              ),
            ),
            Builder(builder: (context){
              if(isLoading){
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey.withAlpha(120),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Container();
            })

          ],
        ),
        content: Container(),
        actionButtons: Builder(builder: (context){

          return Row(children: <Widget>[
            FlatButton(
              child: Text(locText(context, key: "no").toUpperCase(),),
              onPressed: (){
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(locText(context, key: "yes").toUpperCase(),),
              onPressed: () async {

                setState(() {
                  isLoading = true;
                });
                GoogleDriveManager().deleteAllHazizzImages();

                Navigator.pop(context, true);

                setState(() {
                  isLoading = false;
                });

              },
            )
          ],);

        })
    );
    return dialog;
  }
}