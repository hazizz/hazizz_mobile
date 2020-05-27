import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/group/create_group_bloc.dart';
import 'package:mobile/enums/group_types_enum.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'dialog_collection.dart';

class CreateGroupDialog extends StatefulWidget {

  CreateGroupDialog();

  @override
  _CreateGroupDialog createState() => new _CreateGroupDialog();
}

class _CreateGroupDialog extends State<CreateGroupDialog> {

  CreateGroupBloc createGroupBloc;
  
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupPasswordController = TextEditingController();

  GroupTypeEnum groupType;


  @override
  void initState() {
    createGroupBloc = CreateGroupBloc();
    super.initState();
  }

  bool passwordVisible = true;

  GroupTypeEnum groupValue = GroupTypeEnum.OPEN;


  final double width = 300;
  final double height = 260;

  final double searchBarHeight = 50;


  setGroupTypeValue(GroupTypeEnum groupType){
    groupPasswordController.text = "";

    groupValue = groupType;
  }

  String errorText = "";

  
  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
      header: Container(
        width: width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text(localize(context, key: "create_group"),
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w800,
              )
          ),
        ),
      ),
      content: Container(
          height: 280,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                    inputFormatters:[
                      LengthLimitingTextInputFormatter(20),
                    ],
                      style: TextStyle(fontSize: 18),
                      controller: groupNameController,
                      decoration: InputDecoration(
                        labelText: localize(context, key: "group"),
                      )
                ),
                BlocBuilder(
                  bloc: createGroupBloc,
                  builder: (context, state){
                    if(state is CreateGroupInvalidState){
                      return Text(localize(context, key: "error_groupName_length_error"), style: TextStyle(color: Colors.red),);
                    }else if(state is CreateGroupGroupNameTakenState){
                      return Text(localize(context, key: "error_groupName_taken"), style: TextStyle(color: Colors.red),);
                    }
                    return Container();
                  },
                ),
                Text(localize(context, key: "group_name_suggestion")),

        /*
                Builder(
                    builder: (context){
                      var color = null;
                      const double padding = 8;
                      double height2 = 0;
                      if(groupValue == GroupType.PASSWORD){
                        height2 = 60;
                        color = Colors.transparent;
                      }




                      return Padding(
                        padding: const EdgeInsets.only(left: padding, right: padding),
                        child: AnimatedContainer(

                          color: color,
                          height: height2,
                          duration: Duration(milliseconds: 360),
                          child: TextField(

                              obscureText: passwordVisible,
                              style: TextStyle(fontSize: 18),
                              controller: groupPasswordController,
                              decoration: InputDecoration(
                                labelText: "Password",

                                suffix: IconButton(
                                  padding: const EdgeInsets.only(top:  20),
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon

                                    passwordVisible
                                        ? FontAwesomeIcons.solidEyeSlash
                                        : FontAwesomeIcons.solidEye,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                                //  suffixIcon:

                                //  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                              )
                          ),
                        ),
                      );
                    }
                ),
                */

                if (false) Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          setGroupTypeValue(GroupTypeEnum.OPEN);
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            groupValue: groupValue,
                            value: GroupTypeEnum.OPEN,
                            onChanged: (GroupTypeEnum value) {
                              setState(() {
                                setGroupTypeValue(GroupTypeEnum.OPEN);
                              });
                            },
                          ),
                          Text("OPEN")
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          setGroupTypeValue(GroupTypeEnum.CLOSED);
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            groupValue: groupValue,
                            value: GroupTypeEnum.CLOSED,
                            onChanged: (GroupTypeEnum value) {
                              setState(() {
                                setGroupTypeValue(GroupTypeEnum.CLOSED);
                              });
                            },
                          ),
                          Text("CLOSED"),
                        ],
                      ),
                    ),
                  ],
                ),


                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(localize(context, key: "close").toUpperCase()),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(localize(context, key: "create").toUpperCase()),
                      onPressed: (){
                        createGroupBloc.add(CreateGroupCreateEvent(groupType: groupValue, groupName: groupNameController.text));
                      }
                  )],
                )
              ],
            ),
          )
      ),
      actionButtons: Row(),
    );
    return BlocListener(
      bloc: createGroupBloc,
      listener: (context, state){
        if(state is CreateGroupSuccessfulState){
          Navigator.pop(context, true);
        }
      },
      child: dialog,
    );
  }
}