import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';


class SessionItemWidget extends StatefulWidget  {

  PojoSession session;

  bool selected = false;

  SessionItemWidget({@required this.session});

  @override
  _SessionItemWidget createState() => _SessionItemWidget();
}


class _SessionItemWidget extends State<SessionItemWidget>{
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    const String value_remove = "remove";
    const String value_reauth = "reauth";
    return GestureDetector(
      onTap: () async {
        await showKretaProfileDialog(context, widget.session);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 30,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  child: Text(widget.session.username, style: TextStyle(fontSize: 16)),
                ),
                Container(
                  // color: PojoType.getColor(widget.pojoTask.type),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                      color: Colors.red
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4, right: 8, bottom: 6),
                    child: Text(widget.session.status, style: TextStyle(fontSize: 14)),
                  )
                ),
              ],
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(widget.session.url, style: TextStyle(fontSize: 14),),
                  ),
                  Spacer(),
                  Builder(
                    builder: (context){

                      List<PopupMenuEntry> menuItems = [
                        PopupMenuItem(
                          value: value_remove,
                          child: GestureDetector(
                            child: Text(locText(context, key: "remove"),
                              style: TextStyle(color: HazizzTheme.red),
                            ),
                          )
                        ),
                      ];

                      if(widget.session.status != "ACTIVE"){
                        menuItems.add(
                          PopupMenuItem(
                              value: value_reauth,
                              child: GestureDetector(
                                child: Text(locText(context, key: "reauth"),
                                  //   style: TextStyle(color: HazizzTheme.red),
                                ),
                              )
                          ),
                        );
                      }

                      return PopupMenuButton(
                        icon: Icon(FontAwesomeIcons.ellipsisV, size: 20,),
                        onSelected: (value) async {
                          HazizzLogger.printLog("session popupmenuitem value: $value");

                          if(value == value_remove){
                            HazizzResponse hazizzResponse = await RequestSender().getResponse(KretaRemoveSessions(p_session: widget.session.id));
                            if(hazizzResponse.isSuccessful){
                              SessionsBloc().add(FetchData());
                            }
                            // ViewTaskBloc().commentBlocs.commentSectionBloc.add(CommentSectionFetchEvent());
                          }
                          if(value == value_reauth){
                            WidgetsBinding.instance.addPostFrameCallback((_) =>
                                Navigator.pushNamed(context, "/kreta/login/auth", arguments: widget.session)
                            );
                            // ViewTaskBloc().commentBlocs.commentSectionBloc.add(CommentSectionFetchEvent());
                          }


                          /*else if(value == value_select){

                        if(widget.session.status != "ACTIVE"){
                          if(await showDialogSessionReauth(context)){
                            WidgetsBinding.instance.addPostFrameCallback((_) =>
                                Navigator.pushNamed(context, "/kreta/login/auth", arguments: widget.session)
                            );
                          }else{
                          }
                        }else{
                          SelectedSessionBloc().add(SelectedSessionSetEvent(widget.session));
                        }
                      }
                      */
                        },
                        itemBuilder: (BuildContext context) {
                          return menuItems;
                        },
                      );

                    },
                  )
                ]
            )
          ]
        )
      ),
    );
  }
}
