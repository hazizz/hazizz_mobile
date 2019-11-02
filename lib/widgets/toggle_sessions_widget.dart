
import 'package:flutter/material.dart';
import 'package:mobile/blocs/kreta/kreta_notes_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/widgets/toggle_session_button_widget.dart';

class ToggleSessionsWidget extends StatefulWidget {

  @override
  _ToggleSessionsWidget createState() => _ToggleSessionsWidget();
}

class _ToggleSessionsWidget extends State<ToggleSessionsWidget> {

  KretaNotesBloc notesBloc = KretaNotesBloc();

  @override
  void initState() {
    notesBloc.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          ToggleSessionButton(sessionName: "72154615551",isSelected: false, ),
          ToggleSessionButton(sessionName: "72154615551",isSelected: false, ),
          ToggleSessionButton(sessionName: "72154615551",isSelected: false, ),
          ToggleSessionButton(sessionName: "72154615551",isSelected: false, ),
          ToggleSessionButton(sessionName: "72154615551",isSelected: false, ),
        ],
      ),
    );
  }
}


