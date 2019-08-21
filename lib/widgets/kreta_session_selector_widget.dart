import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/selected_session_bloc.dart';
import 'package:mobile/blocs/sessions_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/hazizz_localizations.dart';
import 'package:mobile/listItems/session_item_widget.dart';

class SessionSelectorWidget extends StatefulWidget {

  SessionSelectorWidget({Key key}) : super(key: key){
  }

  @override
  _SessionSelectorWidget createState() => _SessionSelectorWidget();
}

class _SessionSelectorWidget extends State<SessionSelectorWidget> with AutomaticKeepAliveClientMixin {

  SessionsBloc sessionsBloc = SessionsBloc();
  
  @override
  void initState() {
    initalizeSelectedSession();
    sessionsBloc.dispatch(FetchData());

    super.initState();
  }

  List<PojoSession> sessions = List();
  SessionItemWidget selectedSessionWidget;

  void selectSession(int index){
    PojoSession selectedSession = sessions[index];
    sessions.removeAt(index);
    selectedSessionWidget = SessionItemWidget(session: selectedSession,);
  }

  void initalizeSelectedSession(){
    SelectedSessionState currentState = SelectedSessionBloc().currentState;
    if(currentState is SelectedSessionEmptyState){
      print("log: qwe: SelectedSessionEmptyState");
    }else if(currentState is SelectedSessionInactiveState){
      print("log: qwe: SelectedSessionInactiveState");

    }else if(currentState is SelectedSessionFineState){
      print("log: qwe: SelectedSessionFineState");

      PojoSession selectedSession = currentState.session;
      sessions.remove(selectedSession);
      selectedSessionWidget = SessionItemWidget(session: selectedSession,);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,// "create_session_hero_tag",
        child: Icon(FontAwesomeIcons.plus),
        onPressed: (){
          Navigator.pushNamed(context, "/kreta/login", arguments: (){
            Navigator.pop(context);
          });
        },
      ),
      body: RefreshIndicator(
          child: Stack(
            children: <Widget>[
              ListView(),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [

                        BlocBuilder(
                          bloc: SelectedSessionBloc(),
                          builder: (context, state){
                            String info = "";
                            if(state is SelectedSessionEmptyState){
                              print("log: qwe: SelectedSessionEmptyState");
                              info = "no selected account";
                            }else if(state is SelectedSessionInactiveState){
                              print("log: qwe: SelectedSessionInactiveState");
                              info = "selected account is inactive";

                            }else if(state is SelectedSessionFineState){
                              print("log: qwe: SelectedSessionFineState");

                              PojoSession selectedSession = state.session;
                              //   sessions.remove(selectedSession);
                              selectedSessionWidget = SessionItemWidget(session: selectedSession,);
                            }



                            return Column(
                              children: <Widget>[
                                Text(info),
                                Text("Selected session goes here"),
                                DragTarget(
                                  builder: (context, c, r){
                                    return Container(width: 400, height: 100, color: Colors.grey, child: selectedSessionWidget,);
                                  },
                                )
                              ],
                            );

                          },
                        ),

                        /*
                        Column(
                          children: <Widget>[
                            Text("Selected session goes here"),
                            DragTarget(
                              builder: (context, c, r){
                                return BlocBuilder(
                                  bloc: SelectedSessionBloc(),
                                  builder: (context, state){

                                    if(state is SelectedSessionEmptyState){
                                      print("log: qwe: SelectedSessionEmptyState");
                                    }else if(state is SelectedSessionInactiveState){
                                      print("log: qwe: SelectedSessionInactiveState");

                                    }else if(state is SelectedSessionFineState){
                                      print("log: qwe: SelectedSessionFineState");

                                      PojoSession selectedSession = state.session;
                                   //   sessions.remove(selectedSession);
                                      selectedSessionWidget = SessionItemWidget(session: selectedSession,);
                                    }
                                    return Container(width: 400, height: 100, color: Colors.grey, child: selectedSessionWidget,);

                                  },
                                );
                              },
                            )
                          ],
                        ),
                        */

                        Expanded(
                          child: BlocBuilder(
                            bloc: sessionsBloc,
                            builder: (_, HState state) {
                              if (state is ResponseDataLoaded) {
                                List<PojoSession> sessions1 = state.data;


                                if(sessions1.isEmpty){
                                  return Center(child: Text(locText(context, key: "no_kreta_account_added_yet")));
                                }


                                /*
                                List<Widget> sessionWidgets = List();
                                for(PojoSession s in sessions){
                                  sessionWidgets.add(SessionItemWidget(session: s));
                                }
                                */

                                /*
                                if( SelectedSessionBloc().selectedSession != null){
                                 // sessions.remove(SSessielectedonBloc().selectedSession);
                                  for(PojoSession s in sessions){
                                    if(s.id == SelectedSessionBloc().selectedSession.id){
                                      sessions.remove(s);
                                      break;
                                    }
                                  }
                                }

                                return new ListView.builder(
                                    itemCount: sessions.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return SessionItemWidget(session: sessions[index],);
                                    }
                                );
                                */

                                return BlocBuilder(
                                  bloc: SelectedSessionBloc(),
                                  builder: (context2, state2){
                                    sessions.clear();
                                    sessions.addAll(sessions1);


                                    print("session change: $state2: ${sessions1}");
                                    if( SelectedSessionBloc().selectedSession != null){
                                      // sessions.remove(SSessielectedonBloc().selectedSession);
                                      for(PojoSession s in sessions){
                                        if(s.id == SelectedSessionBloc().selectedSession.id){
                                          sessions.remove(s);
                                          break;
                                        }
                                      }
                                    }
                                    if(sessions.isNotEmpty){
                                      return new ListView.builder(
                                          itemCount: sessions.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return SessionItemWidget(session: sessions[index],);
                                          }
                                      );
                                    }
                                    return Text("You better go create account");


                                  },
                                );

                              } else if (state is ResponseWaiting) {
                                return Center(child: CircularProgressIndicator(),);
                              }
                              return Center(
                                  child: Text("Uchecked State: ${state.toString()}"));
                            }
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              )

            ],
          ),
          onRefresh: () async => sessionsBloc.dispatch(FetchData()) //await getData()
      ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


