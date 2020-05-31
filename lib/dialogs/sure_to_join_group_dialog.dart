import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/firebase_analytics.dart';
import 'dialog_collection.dart';

class SureToJoinGroupDialog extends StatefulWidget {

  final int groupId;

  SureToJoinGroupDialog({@required this.groupId});

  @override
  _SureToJoinGroupDialog createState() => new _SureToJoinGroupDialog();
}

class _SureToJoinGroupDialog extends State<SureToJoinGroupDialog> {

  PojoGroupWithoutMe group;
  String groupName;
  bool isLoading = false;
  bool isMember = false;
  bool someThingWentWrong = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    RequestSender().getResponse(RetrieveGroup.withoutMe(pGroupId: widget.groupId)).then((HazizzResponse hazizzResponse){
      if(hazizzResponse.isSuccessful){
        group = hazizzResponse.convertedData;
        if(group.userCount == group.userCountWithoutMe){
          // még nincs bent
        }else{
          setState(() {
            isMember = true;
          });
        }
        setState(() {
          groupName = group.name;
          isLoading = false;
        });
      }else{
        setState(() {
          someThingWentWrong = true;
        });
      }
    });

    super.initState();
  }

  final double width = 300;
  final double height = 90;

  final double searchBarHeight = 50;

  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
      header: Container(
        width: width,
        height: height,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Center(
            child: Builder(builder: (context){
              if(someThingWentWrong){
                return Text(localize(context, key: "try_again_later"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    )
                );
              }
              if(!isLoading){
                if(!isMember){
                  return Text(localize(context, key: "sure_to_join_group", args: [groupName] ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )
                  );
                }

                return Text(localize(context, key: "already_a_member_of_group", args: [groupName]  ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    )
                );
              }
              return Center(child: Text(localize(context, key: "loading"), style: TextStyle(fontSize: 20),));
            }),
          )
        ),
      ),
      content: Container(),
      actionButtons: Builder(builder: (context){

        if(!isLoading){
          if(isMember || someThingWentWrong){
            return Row(children: <Widget>[
              FlatButton(
                child: Text(localize(context, key: "ok").toUpperCase(),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],);
          }

          return Row(children: <Widget>[
            FlatButton(
              child: Text(localize(context, key: "no").toUpperCase(),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(localize(context, key: "yes").toUpperCase(),),
              onPressed: () async {

                setState(() {
                  isLoading = true;
                });
                HazizzResponse hazizzResponse = await RequestSender().getResponse(JoinGroup(pGroupId: group.id));

                if(hazizzResponse.isSuccessful){
                  FirebaseAnalyticsManager.logJoinGroup(widget.groupId);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/group/groupId/newComer", arguments: group);
                }else{
                  setState(() {
                    someThingWentWrong = true;
                  });
                }
                setState(() {
                  isLoading = false;
                });
              },
            )
          ],);
        }
        return Container();
      })
    );
    return dialog;
  }
}