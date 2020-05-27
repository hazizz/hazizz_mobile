import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/enums/group_types_enum.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'dialog_collection.dart';

class ChooseSubjectDialog extends StatefulWidget {

  final int groupId;
  final List<PojoSubject> data;

  ChooseSubjectDialog({Key key, @required this.groupId, @required this.data}) : super(key: key);

  @override
  _ChooseSubjectDialog createState() => new _ChooseSubjectDialog();
}

class _ChooseSubjectDialog extends State<ChooseSubjectDialog> {


  List<PojoSubject> subjectsData = List();

  bool addedEmptySubject = false;

  @override
  void initState() {

    for(PojoSubject s in widget.data){
      if(s.subscribed || !s.subscriberOnly){
        subjectsData.add(s);
      }
    }

    super.initState();
  }

  bool passwordVisible = true;

  GroupTypeEnum groupValue = GroupTypeEnum.OPEN;


  final double width = 300;
  final double height = 100;

  final double searchBarHeight = 50;



  setGroupTypeValue(GroupTypeEnum groupType){

    groupValue = groupType;
  }


  @override
  Widget build(BuildContext context) {

    if(!addedEmptySubject){
      subjectsData.insert(0, getEmptyPojoSubject(context));
      addedEmptySubject = true;
    }


    double subjectHeights;

    if(subjectsData.length > 6){
      subjectHeights = 6 * 38.0;

    }else{
      subjectHeights = subjectsData.length * 38.0;

    }

    double height = 80 + subjectHeights;
    double width = 280;


    var dialog = HazizzDialog(height: height, width: width,
      header: Container(
        width: width,
        height: 40,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text(localize(context, key: "select_subject"),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              )
          ),
        ),
      ),
      content: Container(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            children: <Widget>[
              Builder(
                builder: (context){
                  if(subjectsData.isEmpty){
                    return Text(localize(context, key: "no_subjects_yet"));
                  }
                  return Container();
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: subjectsData.length,
                  itemBuilder: (BuildContext context, int index) {



                    return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, subjectsData[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30, top: 4, bottom: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).primaryColor
                            ),
                            width: width,
                            child: Center(
                              child: Text(
                                subjectsData[index].name, //   data[index].name,
                                style: TextStyle(
                                    fontSize: 25
                                ),
                              ),
                            ),
                          ),
                        )
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actionButtons: Row(
        children: <Widget>[
          Builder(
            builder: (context){
              if(subjectsData.length == 1 && subjectsData[0].id == 0) {
                return FlatButton(
                  child: new Text(localize(context, key: "add_subject").toUpperCase()),
                  onPressed: () async {
                    PojoSubject result = await showAddSubjectDialog(context, groupId: widget.groupId);
                    if(result != null){
                      setState(() {

                        subjectsData.add(result);
                      });
                    }
                  },
                );
              }
              return Container();
            },
          ),
          FlatButton(
            child: new Text(localize(context, key: "close").toUpperCase()),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
        ],
      ),
    );
    return dialog;
  }
}