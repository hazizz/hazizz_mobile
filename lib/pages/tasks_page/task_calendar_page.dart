import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/tasks/task_calendar_bloc.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/listItems/task_item_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/custom/hazizz_localizations.dart';

class TaskCalendarPage extends StatefulWidget {
  TaskCalendarPage({Key key, }) : super(key: key);

  @override
  _TaskCalendarPage createState() => _TaskCalendarPage();
}

class _TaskCalendarPage extends State<TaskCalendarPage> {

  CalendarController calendarController = CalendarController();

  DateTime now = DateTime.now();

  TasksCalendarBloc tasksCalendarBloc = TasksCalendarBloc();

  _TaskCalendarPage();

  Map<DateTime, List> _events = {};
  List _selectedEvents;

  List<Widget> currentTasksList = [];


  bool fabIsInactive = false;

  bool firstTime = true;

  DateTime currentDay = DateTime.now();

  @override
  void initState() {
    tasksCalendarBloc.add(TasksCalendarFetchEvent());
    currentDay = DateTime.now();
    _selectedEvents = _events[DateTime.now()] ?? [];
    super.initState();
  }

  @override
  void dispose() {
    calendarController?.dispose();
    tasksCalendarBloc.close();
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

      if(t.assignation.name == "THERA"){
        innerColor = HazizzTheme.kreta_blue;
      }
      else if(t.completed != null && t.completed){
        innerColor = Colors.green;
      }else{
        innerColor = Colors.red;
      }

      if(nowDayOfYear >= currentDayDayOfYear+2){
        externalColor = Colors.grey;
      }else{
        externalColor = innerColor ;
      }

      eventTasks.add(
        Padding(
          padding: const EdgeInsets.only(left: 0.5, right: 0.5),
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 10.0,
                  height: 10.0,
                  padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: externalColor,
                  ),
                ),
                Positioned(
                  left: 2.5, top: 2.5,
                  child: Container(
                    width: 5.0,
                    height: 5.0,
                    padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: innerColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }

    return Row(
      children: eventTasks,
    );
  }

  List<Widget> pojoToWidget(List<PojoTask> tasks){
    List<Widget> a = [];
    if(tasks != null){
      for(PojoTask t in tasks){
        a.add(TaskItemWidget(originalPojoTask: t, key: Key(t.toJson().toString()),));
      }
    }else{
      HazizzLogger.printLog("calendar: tasks is null");
    }
    return a;
  }

  onDaySelected(DateTime date, List<dynamic> tasks){

    print("szolga: ${date}, ${tasks.toString()}");

    String day = date.day >= 10 ? date.day.toString() : "0${date.day}";
    String month = date.month >= 10 ? date.month.toString() : "0${date.month}";
    currentDay = DateTime.parse("${date.year}-$month-$day 00:00:00.000");

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
    print("szolga12131: ${a}");
    setState(() {
      currentTasksList = a;
    });
  }

  Widget _buildTableCalendar(Map<DateTime, List<PojoTask>> ev) {
    return TableCalendar(
      availableCalendarFormats: {CalendarFormat.month: ""},
      headerVisible: true,

      onDaySelected: (DateTime date, List<dynamic> tasks){
        print("szolga: onDaySelected called");
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
      availableGestures: AvailableGestures.horizontalSwipe,
      formatAnimation: FormatAnimation.scale,

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Text(localize(context, key: "task_calendar")),
      ),
      floatingActionButton:AnimatedOpacity(
        opacity: !fabIsInactive ? 0.0 : 1.0,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton(
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

                      print("szolgas0: ${events}");
                      print("szolgas: ${events[currentDay].toString()}");

                      if(firstTime){
                        _buildTableCalendar(events);
                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                            setState(() async {
                               onDaySelected(
                                  DateTime.now(), events[DateTime.now()]);
                            })
                        );
                        firstTime = false;
                      }

                      return ListView(
                        children: <Widget>[
                          _buildTableCalendar(events),
                          Center(
                            child: Builder(
                              builder: (context){
                                currentTasksList = pojoToWidget(tasksCalendarBloc.tasks[currentDay]);

                                if(currentTasksList.isNotEmpty){
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                        children: currentTasksList
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Text(localize(context, key: "no_tasks_for_this_day")),
                                );
                              },
                            )

                          )
                        ],
                      );
                    } else if (state is ResponseEmpty) {
                    } else if (state is ResponseWaiting) {

                    }
                    return Center(child: CircularProgressIndicator());
                  }
              ),
            ],
          ),
          onRefresh: () async => tasksCalendarBloc.add(TasksCalendarFetchEvent()) //await getData()
      ),
    );
  }
}


