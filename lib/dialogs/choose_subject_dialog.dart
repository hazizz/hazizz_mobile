import 'package:flutter/material.dart';
import 'package:mobile/blocs/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import '../hazizz_localizations.dart';
import 'dialogs.dart';

class ChooseSubjectDialog extends StatefulWidget {

  int groupId;
  List<PojoSubject> data;

  SubjectItemPickerBloc subjectItemPickerBloc;

  ChooseSubjectDialog({Key key, @required this.groupId, @required this.data, /*@required this.subjectItemPickerBloc*/}) : super(key: key);

  @override
  _ChooseSubjectDialog createState() => new _ChooseSubjectDialog();
}

class _ChooseSubjectDialog extends State<ChooseSubjectDialog> {


  List<PojoSubject> subjects_data = List();

  bool addedEmptySubject = false;

  @override
  void initState() {

    subjects_data.addAll(widget.data);

    super.initState();
  }

  bool passwordVisible = true;

  GroupType groupValue = GroupType.OPEN;


  final double width = 300;
  final double height = 100;

  final double searchBarHeight = 50;

  TextEditingController _subjectTextEditingController = TextEditingController();



  setGroupTypeValue(GroupType groupType){

    groupValue = groupType;
  }


  @override
  Widget build(BuildContext context) {


    //subjects_data = widget.subjectItemPickerBloc.dispatch(ItemP);



    if(!addedEmptySubject){
      subjects_data.insert(0, getEmptyPojoSubject(context));
      addedEmptySubject = true;
    }


    double subjectHeights;

    if(subjects_data.length > 6){
      subjectHeights = 6 * 38.0;

    }else{
      subjectHeights = subjects_data.length * 38.0;

    }

    double height = 80 + subjectHeights;
    double width = 280;


    String errorText = null;

    bool isEnabled = true;


    var dialog = HazizzDialog(height: height, width: width,
      header: Container(
        width: width,
        height: 40,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          Text(locText(context, key: "select_subject"),
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w800,
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
                  if(subjects_data.isEmpty){
                    return Text(locText(context, key: "no_subjects_yet"));
                  }
                  return Container();
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: subjects_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, subjects_data[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30, top: 4, bottom: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Theme
                                    .of(context)
                                    .primaryColor
                            ),
                            width: width,
                            child: Center(
                              child: Text(
                                subjects_data[index].name, //   data[index].name,
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
              if(subjects_data.length == 1 && subjects_data[0].id == 0) {
                return FlatButton(
                  child: new Text(locText(context, key: "add_subject").toUpperCase()),
                  onPressed: () async {
                    PojoSubject result = await showAddSubjectDialog(context, groupId: widget.groupId);
                    if(result != null){
                      setState(() {

                        subjects_data.add(result);
                      });
                    }
                  },
                );
              }
              return Container();
            },
          ),
          FlatButton(
            child: new Text(locText(context, key: "close").toUpperCase()),
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