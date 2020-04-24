import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/kreta/kreta_notes_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/listItems/note_item_widget.dart';

class KretaNotesPage extends StatefulWidget {
  @override
  _KretaNotesPage createState() => _KretaNotesPage();
}

class _KretaNotesPage extends State<KretaNotesPage> {

  KretaNotesBloc notesBloc = KretaNotesBloc();

  @override
  void initState() {
    notesBloc.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text(locText(context, key: "kreta_notes")),
        ),
        body: RefreshIndicator(
          onRefresh: () async{
            notesBloc.dispatch(FetchData());
          },
          child: Stack(
            children: <Widget>[
              ListView(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder(
                      bloc: notesBloc,
                      builder: (context, state){
                        if(state is ResponseDataLoaded){
                          List<PojoKretaNote> notes = state.data;
                          return ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index){
                              return NoteItemWidget(note: notes[index]);
                            },
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}


