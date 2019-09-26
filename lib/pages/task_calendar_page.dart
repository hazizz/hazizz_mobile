import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/task_calendar_bloc.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/listItems/task_item_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:table_calendar/table_calendar.dart';

import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';


class TaskCalendarPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTabName(BuildContext context){
    return locText(context, key: "tasks").toUpperCase();
  }

  TaskCalendarPage({Key key, }) : super(key: key);

  @override
  _TaskCalendarPage createState() => _TaskCalendarPage();
}

class _TaskCalendarPage extends State<TaskCalendarPage> with AutomaticKeepAliveClientMixin {

  CalendarController calendarController;

  DateTime now = DateTime.now();

  TasksCalendarBloc tasksCalendarBloc;

  _TaskCalendarPage();

  Map<DateTime, List> _events = {};
  List _selectedEvents;

  List<Widget> currentTasksList = [];


  bool fabIsInactive = false;

  bool firstTime = true;

  DateTime currentDay = DateTime.now();

  @override
  void initState() {
    tasksCalendarBloc = TasksCalendarBloc();
    tasksCalendarBloc.dispatch(TasksCalendarFetchEvent());

    calendarController  = CalendarController();

    final _selectedDay = DateTime.now();
    currentDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    super.initState();
  }

  @override
  void dispose() {
    calendarController?.dispose();
    super.dispose();
  }

  Widget _buildEventsMarker(DateTime date, List events) {

    List<Widget> eventTasks = [];

    var diff = now.difference(new DateTime(date.year, 1, 1, 0, 0));
    final nowDayOfYear = diff.inDays;

    diff = date.difference(new DateTime(date.year, 1, 1, 0, 0));
    final currentDayDayOfYear = diff.inDays;

    for(PojoTask t in events){
      Color innerColor;
      Color externalColor;

      if(t.completed){
        innerColor = Colors.green;
      }else{
        innerColor = Colors.red;
      }

      if(nowDayOfYear >= currentDayDayOfYear+1){
        externalColor = Colors.grey;
      }else{
        externalColor = innerColor ;
      }

      eventTasks.add(
          Padding(
            padding: const EdgeInsets.only(left: 0.5, right: 0.5),
            child: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                 /* BoxShadow(
                    color: externalColor,
                    blurRadius: 1, // has the effect of softening the shadow
                    spreadRadius: 0.7, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      1.6, // vertical, move down 10
                    ),
                  )
                  */
                ],
               // borderRadius: new BorderRadius.all(...),
              //  gradient: new LinearGradient(...),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 10.0,
                    height: 10.0,
                    padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,// You can use like this way or like the below line
                      //borderRadius: new BorderRadius.circular(30.0),
                      color: externalColor,
                    ),
                    // child: new Text(_count.toString(), style: new TextStyle(color: Colors.white, fontSize: 50.0)),// You can add a Icon instead of text also, like below.
                    //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                  ),
                  Positioned(
                    left: 2.5, top: 2.5,
                    child: Container(
                      width: 5.0,
                      height: 5.0,
                      padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,// You can use like this way or like the below line
                        //borderRadius: new BorderRadius.circular(30.0),
                        color: innerColor,
                      ),
                      // child: new Text(_count.toString(), style: new TextStyle(color: Colors.white, fontSize: 50.0)),// You can add a Icon instead of text also, like below.
                      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                    ),
                  ),

                ],
              ),
            ),
          )
      );

     // externalColor  = null;
    }


    return Row(
      children: eventTasks,
    );
  }

  onDaySelected(DateTime date, List<dynamic> tasks){


    print("szolga: ${date}, ${tasks.toString()}");

    currentDay = date;
    if(DateTime.now().isBefore(date)){
      setState(() {
        fabIsInactive = true;
      });
    }else{
      setState(() {
        fabIsInactive = false;
      });
    }
    List<Widget> a = [];
    if(tasks != null){
      for(PojoTask t in tasks){
        a.add(TaskItemWidget(originalPojoTask: t, key: Key(t.toJson().toString()),));
      }
    }else{
      HazizzLogger.printLog("calendar: tasks is null");
    }
    setState(() {
      currentTasksList = a;
    });
  }

  Widget _buildTableCalendar(Map<DateTime, List<PojoTask>> ev) {
    return TableCalendar(


      availableCalendarFormats: {CalendarFormat.month: ""},
      //initialCalendarFormat: CalendarFormat.month,
      headerVisible: true,
      onDaySelected: (DateTime date, List<dynamic> tasks){
        onDaySelected(date, tasks);
      },
      builders: CalendarBuilders(

        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );

          }
          return children;

        },
      ),
      locale: "${Localizations.localeOf(context).languageCode}_${Localizations.localeOf(context).countryCode}",
      calendarController: calendarController,
      events: ev,
     // holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).primaryColorDark,
        todayColor: Theme.of(context).primaryColor.withAlpha(140),
        markersColor: Colors.brown[700],
        outsideDaysVisible: true,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
     // onDaySelected: _onDaySelected,
    //  onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Text(locText(context, key: "task_calendar")),
      ),
      floatingActionButton:AnimatedOpacity(
        opacity: !fabIsInactive ? 0.0 : 1.0,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton(
          // heroTag: "hero_fab_tasks_main",
         // backgroundColor: fabIsInactive ? Theme.of(context).accentColor : Colors.grey,

          onPressed: fabIsInactive ? (){
            Navigator.pushNamed(context, "/createTask");
          } : null,
          tooltip: 'Increment',
          child: Icon(FontAwesomeIcons.plus),
        ),
      ),

      body: RefreshIndicator(
          child: Stack(
            children: <Widget>[
              ListView(),
              BlocBuilder(
                  bloc: tasksCalendarBloc,
                  builder: (_, TasksCalendarState state) {
                    Map<DateTime, List<PojoTask>> events = {};
                    if (state is TasksCalendarLoadedState) {
                      events = state.tasks;

                      print("szolgas: ${events[currentDay].toString()}");

                    //  calendarController.
                      if(firstTime){
                        _buildTableCalendar(events);

                       // "${currentDay.year}-${currentDay.month}, currentDay.day}"

                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                            onDaySelected(/*DateTime(currentDay.year, currentDay.month, currentDay.day, 12)*/
                            DateTime.parse( "2019-09-25 12:00:00.000Z"), events[DateTime.parse( "2019-09-25 12:00:00.000Z")])
                        );
                        firstTime = false;
                      }


                      return ListView(
                        children: <Widget>[
                          _buildTableCalendar(events),
                          Center(
                            child: Builder(
                              builder: (context){
                                if(currentTasksList.isNotEmpty){
                                  return Column(
                                      children: currentTasksList
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Text(locText(context, key: "no_tasks_for_this_day")),
                                );
                              },
                            )

                          )
                        ],
                      );
                     // return _buildTableCalendar(events);

                    } else if (state is ResponseEmpty) {
                    } else if (state is ResponseWaiting) {

                    }
                    return Center(child: CircularProgressIndicator());
                  }
              ),

            ],
          ),
          onRefresh: () async => tasksCalendarBloc.dispatch(TasksCalendarFetchEvent()) //await getData()
      ),


    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


