import 'package:mobile/blocs/kreta/grades_bloc.dart';
import 'package:mobile/blocs/kreta/schedule_bloc.dart';
import 'package:mobile/blocs/other/custom_schedule_bloc.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/managers/preference_manager.dart';

class MainTabBlocs{

  static final MainTabBlocs _singleton = new MainTabBlocs._internal();
  factory MainTabBlocs() {
    return _singleton;
  }
  MainTabBlocs._internal();

  int initialIndex = PreferenceManager.tasksPage;

  final TasksBloc tasksBloc = new TasksBloc();
   final ScheduleBloc schedulesBloc = new ScheduleBloc();
   final CustomScheduleBloc customScheduleBloc = new CustomScheduleBloc();
   final GradesBloc gradesBloc = new GradesBloc();

  void fetchAll(){
    tasksBloc.add(TasksFetchEvent());
    schedulesBloc.add(ScheduleFetchEvent());
    gradesBloc.add(GradesFetchEvent());
  }

  void initialize()async{
    fetchAll();
    initialIndex = await PreferenceManager.getStartPageIndex();
  }
}







