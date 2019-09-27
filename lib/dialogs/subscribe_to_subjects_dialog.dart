import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/defaults/pojo_subject_empty.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'package:mobile/listItems/subject_item_widget.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'dialogs.dart';

class SubscribeToSubjectDialog extends StatefulWidget {
  SubscribeToSubjectDialog({Key key}) : super(key: key);

  @override
  _SubscribeToSubjectDialog createState() => new _SubscribeToSubjectDialog();
}

class _SubscribeToSubjectDialog extends State<SubscribeToSubjectDialog> {


  @override
  void initState() {
    super.initState();
  }

  void pop(BuildContext context){
    GroupBlocs().groupSubjectsBloc.dispatch(FetchData());
    Navigator.pop(context, null);
  }


  @override
  Widget build(BuildContext context) {

    double height = 300;
    double width = 280;


    var dialog = HazizzDialog(height: height, width: width,
      header: Container(
        width: width,
        height: 40,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
          AutoSizeText(locText(context, key: "choose_subjects_to_subscribe_to"),
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
            maxFontSize: 25,
            minFontSize: 15,
          ),
        ),
      ),
      content: Container(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: BlocBuilder(
            bloc: GroupBlocs().groupSubjectsBloc,
            builder: (context, state){

              List<PojoSubject> subjectsToSubscribe = List();

              if(state is ResponseDataLoaded){
                for(PojoSubject s in state.data){
                  if(s.subscriberOnly){
                    subjectsToSubscribe.add(s);
                  }
                }

                if(subjectsToSubscribe.isNotEmpty){
                  return Container(
                    child: ListView.builder(
                      itemCount: subjectsToSubscribe.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SubjectItemWidget(subject: subjectsToSubscribe[index],);
                      },
                    ),
                  );
                }

                pop(context);
                return Container();


              }else if(state is ResponseError || state is ResponseWaiting){
                return Center(child: CircularProgressIndicator(),);
              }

              pop(context);

              return Container();

            },
          ),
        ),
      ),
      actionButtons: Row(
        children: <Widget>[
          FlatButton(
            child: new Text(locText(context, key: "forward").toUpperCase()),
            onPressed: () {
              pop(context);
            },
          ),
        ],
      ),
    );
    return dialog;
  }
}