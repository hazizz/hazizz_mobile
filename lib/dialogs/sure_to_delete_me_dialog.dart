import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dialogs.dart';

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
                      return Text(locText(context, key: "areyousure_delete_me"),
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
                HazizzResponse hazizzResponse = await RequestSender().getResponse(DeleteMe(userId: (await InfoCache.getMyUserData()).id));

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
          ],);

        })
    );
    return dialog;
  }
}