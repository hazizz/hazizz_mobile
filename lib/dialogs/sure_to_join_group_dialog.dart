import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/create_group_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'package:mobile/request_sender.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';
import 'dialogs.dart';

class SureToJoinGroupDialog extends StatefulWidget {

  int groupId;

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
    RequestSender().getResponse(RetrieveGroup.withoutMe(p_groupId: widget.groupId)).then((HazizzResponse hazizzResponse){
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
        });

        setState(() {
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
                return Text(locText(context, key: "try_again_later"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    )
                );
              }
              if(!isLoading){
                if(!isMember){
                  return Text(locText(context, key: "sure_to_join_group", args: [groupName] ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )
                  );
                }

                return Text(locText(context, key: "already_a_member_of_group", args: [groupName]  ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    )
                );
              }
              return Center(child: Text(locText(context, key: "loading"), style: TextStyle(fontSize: 20),));
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
                child: Text(locText(context, key: "ok").toUpperCase(),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],);
          }

          return Row(children: <Widget>[
            FlatButton(
              child: Text(locText(context, key: "no").toUpperCase(),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(locText(context, key: "yes").toUpperCase(),),
              onPressed: () async {

                setState(() {
                  isLoading = true;
                });
                HazizzResponse hazizzResponse = await RequestSender().getResponse(JoinGroup(p_groupId: group.id));

                if(hazizzResponse.isSuccessful){
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