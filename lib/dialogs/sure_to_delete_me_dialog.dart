import 'package:flutter/material.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/user_manager.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/cache_manager.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dialog_collection.dart';

class SureToDeleteMeDialog extends StatefulWidget {
  SureToDeleteMeDialog();
  @override
  _SureToDeleteMeDialog createState() => new _SureToDeleteMeDialog();
}

class _SureToDeleteMeDialog extends State<SureToDeleteMeDialog> {

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  final double width = 300;
  final double height = 90;

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
                      return Text(localize(context, key: "areyousure_delete_me"),
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
        actionButtons: Row(children: <Widget>[
          FlatButton(
            child: Text(localize(context, key: "no").toUpperCase(),),
            onPressed: (){
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(localize(context, key: "yes").toUpperCase(),),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              HazizzResponse hazizzResponse = await RequestSender().getResponse(
                  DeleteMe(pUserId: UserManager.getMyIdSafely)
              );

              if(hazizzResponse.isSuccessful){
                AppState.logout();
              }else{
                print("delete me failed");
              }
              setState(() {
                isLoading = false;
              });

            },
          )
        ],)
    );
    return dialog;
  }
}