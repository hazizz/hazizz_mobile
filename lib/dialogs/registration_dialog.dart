import 'package:flutter/material.dart';
import 'package:mobile/widgets/hyper_link.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dialog_collection.dart';

class RegistrationDialog extends StatefulWidget {
  RegistrationDialog({Key key}) : super(key: key);

  @override
  _RegistrationDialog createState() => new _RegistrationDialog();
}

class _RegistrationDialog extends State<RegistrationDialog> {

  final double height = 210;

  final double width = 280;

  bool accepted = false;

  String errorText = "";

  @override
  Widget build(BuildContext context) {

    Locale getCurrentLocale(BuildContext context){
      return Localizations.localeOf(context);
    }

    String getLinkPrivacy(){
      String currentLang = getCurrentLocale(context).languageCode;
      if(currentLang != "en" && currentLang != "hu" ){
        currentLang = "en";
      }
      String link = "https://hazizz.github.io/privacy-${currentLang}.txt";
      return link;
    }
    String getLinkTermsOfService(){
      String currentLang = getCurrentLocale(context).languageCode;
      if(currentLang != "en" && currentLang != "hu" ){
        currentLang = "en";
      }
      String link = "https://hazizz.github.io/tos-${currentLang}.txt";
      return link;
    }

    String getGuidelines(){
      String currentLang = getCurrentLocale(context).languageCode;
      if(currentLang != "en" && currentLang != "hu" ){
        currentLang = "en";
      }
      String link = "https://hazizz.github.io/guideline-hu.txt";
      return link;
    }


    HazizzDialog hazizzDialog = HazizzDialog(
        header: Container(
          width: width,

          color: Theme.of(context).primaryColor,

          child: Center(child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom:4),
            child: Text(localize(context, key: "registration"), style: TextStyle(fontSize: 32),),
          )),
        ),

        content: Center(
          child: Container(
            width: width,
            //  color: Theme.of(context).primaryColor,
            child: Padding(
                padding: const EdgeInsets.all(3),
                child:
                //   Text(locText(context, textview_logout_drawer: "kreta_login_later")),
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                     // crossAxisAlignment: CrossAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Checkbox(value: accepted, onChanged: (val){
                            setState(() {
                              accepted = val;
                              if(accepted){
                                errorText = "";
                              }
                            });
                          }),
                          Expanded(
                            child: Container(
                            //  width: width-70,
                              child: Wrap(
                                children: <Widget>[
                                  Text(localize(context, key: "have_to_accept_privacy_tos1"), style: TextStyle(fontSize: 18),),
                                  Hyperlink(getLinkPrivacy(), Text(localize(context, key: "have_to_accept_privacy"), style: TextStyle(fontSize: 18, color: HazizzTheme.red, decoration: TextDecoration.underline,), )),
                                  Text(localize(context, key: "have_to_accept_privacy_tos2"), style: TextStyle(fontSize: 18)),
                                  Hyperlink(getLinkTermsOfService(), Text(localize(context, key: "have_to_accept_tos"), style: TextStyle(fontSize: 18, color: HazizzTheme.red, decoration: TextDecoration.underline,), )),
                                  Text(localize(context, key: "have_to_accept_privacy_tos3"), style: TextStyle(fontSize: 18)),
                                  Hyperlink(getGuidelines(), Text(localize(context, key: "have_to_accept_guidelines"), style: TextStyle(fontSize: 18, color: HazizzTheme.red, decoration: TextDecoration.underline,), )),

                                ],
                              ),
                            ),
                          )



                        ],
                      ),
                    ),
                    Center(child: Text(errorText, style: TextStyle(color: Colors.red), textAlign: TextAlign.center,))
                  ],
                )

            ),
          ),
        ),
        actionButtons:
        Row(
          children: <Widget>[
            FlatButton(
              child: Text(localize(context, key: "cancel").toUpperCase()),
              onPressed: (){
                Navigator.pop(context, false) ;
              },
            ),
            FlatButton(
              child: Text(localize(context, key: "proceed").toUpperCase()),
              onPressed: (){

                if(accepted){
                  Navigator.pop(context, true) ;
                }
                else{
                  setState(() {
                    errorText = localize(context, key: "error_conditionsNotAccepted");
                  });
                }
              },
            )
          ],
        ),
        height: height, width: width);

    return hazizzDialog;

  }
}


















