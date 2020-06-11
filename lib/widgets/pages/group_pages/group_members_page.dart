import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoGroupPermissions.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/widgets/listItems/member_item_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';
import 'package:mobile/custom/hazizz_localizations.dart';


class GroupMembersPage extends StatefulWidget {
  String getTabName(BuildContext context){
    return localize(context, key: "groupMembers").toUpperCase();
  }

  final GroupMembersBloc groupMembersBloc;

  GroupMembersPage({Key key, @required this.groupMembersBloc}) : super(key: key);

  @override
  _GroupMembersPage createState() => _GroupMembersPage(groupMembersBloc);
}

class _GroupMembersPage extends State<GroupMembersPage> with AutomaticKeepAliveClientMixin {

  GroupMembersBloc groupMembersBloc;

  _GroupMembersPage(this.groupMembersBloc);

  @override
  void initState() {
    if(groupMembersBloc.state is ResponseError) {
      groupMembersBloc.add(FetchData());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: BlocBuilder(
        bloc: GroupBlocs().myPermissionBloc,
        builder: (context, state){
          Widget showFab ()=> FloatingActionButton(
            child: Icon(FontAwesomeIcons.userPlus),
            heroTag: "hero_fab_members",
            onPressed: (){
              showInviteDialog(context, group: groupMembersBloc.group);
            },
          );

          if(GroupBlocs().group.groupType == "OPEN"){
            return showFab();
          }
          else if(state is MyPermissionSetState){
            if(state.permission == GroupPermissionsEnum.OWNER
            || state.permission == GroupPermissionsEnum.MODERATOR){
              return showFab();
            }
            return Container();
          }
          return Container();
        },
      ),
      body: new RefreshIndicator(
        child: Stack(
          children: <Widget>[
            ListView(),
            BlocBuilder(
              bloc: groupMembersBloc,
              builder: (_, HState state) {
                if (state is ResponseDataLoaded) {

                  PojoGroupPermissions memberPermissions = state.data;
                  List<MemberItemWidget> membersWidget = List();

                  Function onKicked = (){
                    groupMembersBloc.add(FetchData());
                  };

                  for(PojoUser member in memberPermissions.owner){
                    membersWidget.add(MemberItemWidget(member: member, permission: GroupPermissionsEnum.OWNER, onKicked: onKicked,));
                  }
                  for(PojoUser member in memberPermissions.moderator){
                    membersWidget.add(MemberItemWidget(member: member, permission: GroupPermissionsEnum.MODERATOR, onKicked: onKicked));
                  }
                  for(PojoUser member in memberPermissions.user){
                    membersWidget.add(MemberItemWidget(member: member, permission: GroupPermissionsEnum.USER, onKicked: onKicked));
                  }
                  for(PojoUser member in memberPermissions.nullPermission){
                    membersWidget.add(MemberItemWidget(member: member, permission: GroupPermissionsEnum.NULL, onKicked: onKicked));
                  }

                  return new ListView.builder(
                    itemCount: membersWidget.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(index >= membersWidget.length-1){
                        return addScrollSpace(membersWidget[index]);
                      }
                      return membersWidget[index];
                    }
                  );
                } else if (state is ResponseEmpty) {
                  return Container();
                } else if (state is ResponseWaiting) {
                  return Center(child: CircularProgressIndicator(),);
                }
                return Center(child: Text(localize(context, key: "info_something_went_wrong")));
              }
            ),
          ],
        ),
        onRefresh: () async => groupMembersBloc.add(FetchData()) //await getData()
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}


