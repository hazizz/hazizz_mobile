import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/create_group_bloc.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'dialogs.dart';

class CreateGroupDialog extends StatefulWidget {

  CreateGroupDialog();

  @override
  _CreateGroupDialog createState() => new _CreateGroupDialog();
}

class _CreateGroupDialog extends State<CreateGroupDialog> {

  CreateGroupBloc createGroupBloc;
  
  TextEditingController groupNameController;

  TextEditingController groupPasswordController;


  @override
  void initState() {
    createGroupBloc = CreateGroupBloc();
    groupNameController = TextEditingController();
    groupPasswordController = TextEditingController();
    super.initState();
  }

  bool passwordVisible = true;

  GroupType groupValue = GroupType.OPEN;


  final double width = 300;
  final double height = 260;

  final double searchBarHeight = 50;


  setGroupTypeValue(GroupType groupType){
    groupPasswordController.text = "";

    groupValue = groupType;
  }

  
  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
      header: Container(
        width: width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text("Create group",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              )
          ),
        ),
      ),
      content: Container(
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: groupNameController,
                    decoration: InputDecoration(
                      labelText: "Group",
                      //  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                    )
                ),
              ),
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

              Container(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 90,
                      top:0,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            setGroupTypeValue(GroupType.OPEN);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Radio(
                              groupValue: groupValue,
                              value: GroupType.OPEN,
                              onChanged: (GroupType value) {
                                setState(() {
                                  setGroupTypeValue(GroupType.OPEN);
                                });
                              },
                            ),
                            Text("OPEN")
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 90,
                      top:28,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            setGroupTypeValue(GroupType.INVITE_ONLY);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Radio(
                              groupValue: groupValue,
                              value: GroupType.INVITE_ONLY,
                              onChanged: (GroupType value) {
                                setState(() {
                                  setGroupTypeValue(GroupType.INVITE_ONLY);

                                });
                              },
                            ),
                            Text("Invite")
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 90,
                      top:56,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            setGroupTypeValue(GroupType.PASSWORD);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              groupValue: groupValue,
                              value: GroupType.PASSWORD,
                              onChanged: (GroupType value) {
                                setState(() {
                                  setGroupTypeValue(GroupType.PASSWORD);
                                });
                              },
                            ),
                            Text("password"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              MaterialButton(
                  child: Text("create"),
                  onPressed: (){
                    print("groupPasswordController.text: ${groupPasswordController.text}");
                    createGroupBloc.dispatch(CreateGroupCreateEvent(groupType: groupValue, groupName: groupNameController.text, password: groupValue == GroupType.PASSWORD ? groupPasswordController.text : null));
                  })
            ],
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