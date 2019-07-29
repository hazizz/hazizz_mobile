import 'package:bloc/bloc.dart';
//import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/preference_services.dart';

import '../../request_sender.dart';
import '../../hazizz_response.dart';
import '../../hazizz_time_of_day.dart';
import '../request_event.dart';
import '../response_states.dart';

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

  PojoSchedules classes;

  int currentDayIndex = DateTime.now().weekday-1;

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {


    int timeOfDayToMinutes(HazizzTimeOfDay timeOfDay){
      return timeOfDay.minute + timeOfDay.hour * 60;
    }

    HazizzTimeOfDay minutesToTimeOfDay(int minutes){

      int hour = minutes ~/ 60;
      int minute = minutes % 60;

      return HazizzTimeOfDay(hour: hour, minute: minute);
    }

    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new DummyKretaGetSchedules());

        if(hazizzResponse.isSuccessful){
          classes = hazizzResponse.convertedData;
          print("log: oy133");
          yield ResponseDataLoaded(data: classes);



          List<PojoClass> todayClasses = classes.classes[currentDayIndex.toString()];

          HazizzTimeOfDay now = HazizzTimeOfDay.now();


          HazizzTimeOfDay closestBefore;
          HazizzTimeOfDay closestAfter;

          for(int i = 0; i < todayClasses.length; i++){
            PojoClass pojoClass = todayClasses[i];

            if(i == 0){
              // még nem történt meg
              if(pojoClass.startOfClass > now){
                // első óra még nem indult el
              }else if(pojoClass.startOfClass < now && pojoClass.endOfClass > now){
                // első óra már el indult, de nem ért végett
              }
            }

            else if(i-1 == todayClasses.length){
              if(pojoClass.startOfClass > now){
                // utlsó óra még nem indult el
              }else if(pojoClass.startOfClass < now && pojoClass.endOfClass > now){
                // utlsó óra már el indult, de nem ért végett
              }else{
                // az utlsó órának vége
              }
            }


            else{

              // itt már error mentesen lehet az elöző és a következő órához hasónlitani


            }




          }



        }
        else if(hazizzResponse.isError){
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
       //   yield ResponseError(error: responseData);
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

  MainTasksBloc tasksBloc = new MainTasksBloc();
  MainSchedulesBloc schedulesBloc = new MainSchedulesBloc();
  MainGradesBloc gradesBloc = new MainGradesBloc();

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







