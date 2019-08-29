import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile/caches/data_cache.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/errors.dart';
//import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
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

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  @override
  HState get initialState => ResponseEmpty();

  @override
  void dispose() {
    // TODO: implement dispose
    print("log: DISPOSE222");
    super.dispose();
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    print("log: Event2: ${event.toString()}");
    if (event is FetchData) {
      try {

        yield ResponseWaiting();


        DataCache dataCache = await loadTasksCache();
        if(dataCache!= null){
          lastUpdated = dataCache.lastUpdated;
          tasks = dataCache.data;
          yield ResponseDataLoadedFromCache(data: tasks);
        }



        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe());
        print("log: responseData: ${hazizzResponse}");
        print("log: responseData type:  ${hazizzResponse.runtimeType.toString()}");


        if(hazizzResponse.isSuccessful){
          lastUpdated = DateTime.now();
          tasks = hazizzResponse.convertedData;
          saveTasksCache(tasks);
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
            yield ResponseError(errorResponse: hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(FetchData());
            },
            "tasks_fetch"
            );
          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
                || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT ){
            print("log: noConnectionError22");
            this.dispatch(FetchData());

          }else{
            yield ResponseError(errorResponse: hazizzResponse);

          }


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

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  PojoSchedules classes;

  int currentDayIndex = DateTime.now().weekday-1;

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();

        print("WIATING222");


        DataCache dataCache = await loadScheduleCache();
        if(dataCache!= null){
          lastUpdated = dataCache.lastUpdated;
          classes = dataCache.data;
          yield ResponseDataLoadedFromCache(data: classes);
        }

        DateTime now = DateTime.now();

        int dayOfYear = int.parse(DateFormat("D").format(now));
        int weekOfYear = ((dayOfYear - now.weekday + 10) / 7).floor();

        print("WEEK OF YEAR: $weekOfYear");
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSchedules(/*q_year: now.year, q_weekNumber: weekOfYear*/));

      //  print("classes.: ${classes}");
        if(hazizzResponse.isSuccessful){
          print("classes.classes: ${ hazizzResponse.convertedData}");
          classes = hazizzResponse.convertedData;
          if(classes != null && classes.classes.isNotEmpty){

            lastUpdated = DateTime.now();
            saveScheduleCache(classes);

            print("log: opsie: 0");

            // classes = classesDummy;


            print("log: opsie: 0");

            scheduleEventBloc.dispatch(ScheduleEventUpdateClassesEvent());


            print("log: opsie: 1");

            List<PojoClass> todayClasses = classes.classes[currentDayIndex.toString()];

            print("log: opsie: 2");
            HazizzTimeOfDay now = HazizzTimeOfDay.now();
            print("log: opsie: 3");


            HazizzTimeOfDay closestBefore;
            HazizzTimeOfDay closestAfter;

            yield ResponseDataLoaded(data: classes);

            print("log: oy133");
          }


        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            print("log: noConnectionError22");
            yield ResponseError(errorResponse: hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(FetchData());
            },
            "schedule_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
                || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            print("log: noConnectionError22");
            this.dispatch(FetchData());
          }else{
            yield ResponseError(errorResponse: hazizzResponse);

          }


        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

class MainGradesBloc extends Bloc<HEvent, HState> {

  PojoGrades grades;

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);


  @override
  HState get initialState => ResponseEmpty();


  String calculateAvarage(List<PojoGrade> pojoGrades){
    double gradeAmount = 0;
    double gradeSum = 0;

    for(PojoGrade pojoGrade in pojoGrades){
      if(pojoGrade != null && pojoGrade.grade != null && pojoGrade.weight != null){
        try {
          int grade = int.parse(pojoGrade.grade);
          int weight = pojoGrade.weight;

          if(grade != null) {
            double gradeWeightCurrent = weight / 100;
            gradeAmount += gradeWeightCurrent;
            gradeSum += gradeWeightCurrent * grade;
          }
        }catch(e){

        }

      }
    }
    if(gradeSum != 0 && gradeAmount != 0){

      int decimals = 2;
      int fac = pow(10, decimals);
      double d = gradeSum/gradeAmount;
      d = (d * fac).round() / fac;
    //  print("d: $d");


      return d.toString();
    }
    return "";
  }


  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
            print("log: am0 i here?");

        DataCache dataCache = await loadGradesCache();
        if(dataCache!= null){
          lastUpdated = dataCache.lastUpdated;
          grades = dataCache.data;
          yield ResponseDataLoadedFromCache(data: grades);
        }

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetGrades());

        print("log: hazizzResponse: ${hazizzResponse.dioError}");


        if(hazizzResponse.isSuccessful){
          grades = hazizzResponse.convertedData;
          lastUpdated = DateTime.now();
          saveGradesCache(grades);
          yield ResponseDataLoaded(data: grades);
        }

        /*
        grades = new PojoGrades(
            {"Matek TESZT" : [
              PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "1", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "2", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 100),
              PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "3", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 50),
              PojoGrade(creationDate: DateTime(2013), date: DateTime(2019), grade: "1", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200)],

              "Történelem TESZT" : [
                PojoGrade(creationDate: DateTime(2020), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 100),
                PojoGrade(creationDate: DateTime(2021), date: DateTime(2019), grade: "3", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
                PojoGrade(creationDate: DateTime(2022), date: DateTime(2019), grade: "2", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 50),
                PojoGrade(creationDate: DateTime(2023), date: DateTime(2019), grade: "4", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 100)],

              "Komplex Természet Tudomány" : [
                PojoGrade(creationDate: DateTime(2030), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
                PojoGrade(creationDate: DateTime(2031), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
                PojoGrade(creationDate: DateTime(2032), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
                PojoGrade(creationDate: DateTime(2033), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 600)]
            }
        );
        */


        if(hazizzResponse.isError){
          if(hazizzResponse.dioError == noConnectionError){
            yield ResponseError(errorResponse: hazizzResponse);
            Connection.addConnectionOnlineListener((){
              this.dispatch(FetchData());
            },
            "grades_fetch"
            );
          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
                || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            print("log: noConnectionError22");
            this.dispatch(FetchData());
          } else if(hazizzResponse.hasPojoError && hazizzResponse.pojoError.errorCode == 138) {
            yield ResponseError(errorResponse: hazizzResponse);

          }


          else{
            yield ResponseError(errorResponse: hazizzResponse);

          }

          }

        /*
        grades = new PojoGrades(
            {"asd1" : [
              PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
              PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
              PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
              PojoGrade(creationDate: DateTime(2013), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600)],

              "asd2" : [
                PojoGrade(creationDate: DateTime(2020), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight:600),
                PojoGrade(creationDate: DateTime(2021), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
                PojoGrade(creationDate: DateTime(2022), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
                PojoGrade(creationDate: DateTime(2023), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600)],

              "asd3" : [
                PojoGrade(creationDate: DateTime(2030), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
                PojoGrade(creationDate: DateTime(2031), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
                PojoGrade(creationDate: DateTime(2032), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600),
                PojoGrade(creationDate: DateTime(2033), date: DateTime(2019), grade: "1", gradeType: "mindent eldöntő évvégi jegy", subject: "Nyelvtan", topic: "tz topic", weight: 600)]
            }
        );
        */


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







