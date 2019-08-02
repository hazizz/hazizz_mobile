import 'package:bloc/bloc.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/errors.dart';
//import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dummy/schedule_dummy.dart';
import 'package:mobile/managers/preference_services.dart';

import '../../request_sender.dart';
import '../../hazizz_response.dart';
import '../../hazizz_time_of_day.dart';
import '../request_event.dart';
import '../response_states.dart';
import '../schedule_event_bloc.dart';

class MainTasksBloc extends Bloc<HEvent, HState> {
  List<PojoTask> tasks;

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe());
        print("log: responseData: ${hazizzResponse}");
        print("log: responseData type:  ${hazizzResponse.runtimeType.toString()}");


        if(hazizzResponse.isSuccessful){
          tasks = hazizzResponse.convertedData;
          if(tasks.isNotEmpty) {
            print("log: response is List");
            yield ResponseDataLoaded(data: tasks);
          }else{
            yield ResponseEmpty();
          }
        }
        else if(hazizzResponse.isError){
          print("log: response is List<PojoTask>");


          if(hazizzResponse.dioError == noConnectionError){
            Connection.addConnectionOnlineListener((){
              this.dispatch(FetchData());
            },
            "tasks_fetch"
            );
          }
          yield ResponseError(error: hazizzResponse.pojoError);

        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
        // yield TasksError();
      }
    }
  }
}

class MainSchedulesBloc extends Bloc<HEvent, HState> {

  ScheduleEventBloc scheduleEventBloc;


  MainSchedulesBloc(){
    scheduleEventBloc = ScheduleEventBloc();
  }


  PojoSchedules classes;

  int currentDayIndex = DateTime.now().weekday-1;

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new DummyKretaGetSchedules());

        if(hazizzResponse.isSuccessful || true ){
       //   classes = hazizzResponse.convertedData;
          print("log: opsie: 0");

          classes = classesDummy;


          print("log: opsie: 0");

          scheduleEventBloc.dispatch(ScheduleEventUpdateClassesEvent());


          print("log: opsie: 1");

          List<PojoClass> todayClasses = classes.classes[currentDayIndex.toString()];

          print("log: opsie: 2");
          HazizzTimeOfDay now = HazizzTimeOfDay.now();
          print("log: opsie: 3");


          HazizzTimeOfDay closestBefore;
          HazizzTimeOfDay closestAfter;


          print("log: oy1334: todayClasses.length: ${todayClasses.length}");


          yield ResponseDataLoaded(data: classes);

          print("log: oy133");


        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            print("log: noConnectionError22");
            Connection.addConnectionOnlineListener((){
              this.dispatch(FetchData());
            },
            "schedule_fetch"
            );
          }
          yield ResponseError(error: hazizzResponse.pojoError);


        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

class MainGradesBloc extends Bloc<HEvent, HState> {

  PojoGrades grades;

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
            print("log: am0 i here?");

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new DummyKretaGetGrades());

        print("log: hazizzResponse: ${hazizzResponse.dioError}");
        
        /*
        PojoGrades responseData = new PojoGrades(
          {"asd1" : [
                PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
                PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
                PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
                PojoGrade(creationDate: DateTime(2013), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%")],

            "asd2" : [
              PojoGrade(creationDate: DateTime(2020), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
              PojoGrade(creationDate: DateTime(2021), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
              PojoGrade(creationDate: DateTime(2022), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
              PojoGrade(creationDate: DateTime(2023), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%")],

          "asd3" : [
            PojoGrade(creationDate: DateTime(2030), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
            PojoGrade(creationDate: DateTime(2031), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
            PojoGrade(creationDate: DateTime(2032), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%"),
            PojoGrade(creationDate: DateTime(2033), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: "600%")]
          }
        );
        */
        if(hazizzResponse.isSuccessful){
          grades = hazizzResponse.convertedData;
          yield ResponseDataLoaded(data: grades);
        }
        else if(hazizzResponse.isError){
          if(hazizzResponse.dioError == noConnectionError){
            Connection.addConnectionOnlineListener((){
              this.dispatch(FetchData());
            },
            "grades_fetch"
            );
          }
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

class MainTabBlocs{

   bool isBooked = false;

   void bookBloc(){
    isBooked = true;
  }

  static final MainTabBlocs _singleton = new MainTabBlocs._internal();
  factory MainTabBlocs() {
    return _singleton;
  }
  MainTabBlocs._internal();

  int initialIndex = StartPageService.tasksPage;

  final MainTasksBloc tasksBloc = new MainTasksBloc();
  final MainSchedulesBloc schedulesBloc = new MainSchedulesBloc();
  final MainGradesBloc gradesBloc = new MainGradesBloc();

  void fetchAll(){
    tasksBloc.dispatch(FetchData());
    schedulesBloc.dispatch(FetchData());
    gradesBloc.dispatch(FetchData());
  }

  void initialize()async{
    fetchAll();
    initialIndex = await StartPageService.getStartPageIndex();
  }
}







