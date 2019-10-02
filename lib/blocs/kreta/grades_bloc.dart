import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/grades_sort_enum.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/storage/caches/data_cache.dart';

//region EditTask bloc parts
//region EditTask events
abstract class GradesEvent extends HEvent {
  GradesEvent([List props = const []]) : super(props);
}

class GradesFetchEvent extends GradesEvent {
  /*
  bool finishedOnly = true;
  bool unfinishedOnly = false;

  bool expired = false;
  */


  GradesFetchEvent(/*{this.unfinishedOnly, this.expired}*/) :  super([/*unfinishedOnly*/]){

  }
  @override
  String toString() => 'GradesFetchEvent';
}
//endregion

//region SubjectItemListStates
abstract class GradesState extends HState {
  GradesState([List props = const []]) : super(props);
}

class GradesInitialState extends GradesState {
  @override
  String toString() => 'GradesInitialState';
}

class GradesWaitingState extends GradesState {
  @override
  String toString() => 'GradesWaitingState';
}

class GradesLoadedState extends GradesState {
  PojoGrades data;

  GradesLoadedState(this.data) : assert(data!= null), super([data]);
  @override
  String toString() => 'GradesLoadedState';
}

class GradesLoadedCacheState extends GradesState {
  PojoGrades data;
  GradesLoadedCacheState(this.data) : assert(data!= null), super([data]);
  @override
  String toString() => 'GradesLoadedCacheState';
}

class GradesErrorState extends GradesState {
  HazizzResponse hazizzResponse;
  GradesErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'GradesErrorState';
}


//endregion

//region SubjectItemListBloc
class GradesBloc extends Bloc<GradesEvent, GradesState> {


  GradesSort gradesSort = GradesSort.BYSUBJECT;

  GradesBloc(){

  }

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  PojoGrades grades;
  List<PojoGrade> gradesByDate = List();


  @override
  GradesState get initialState => GradesInitialState();

  List<PojoGrade> getGradesByDate(){
    gradesByDate.clear();
    HazizzLogger.printLog("Grades sub1: ${grades.grades.values.length}");


    for(int i = 0; i < grades.grades.values.length; i++){
      print("Grades sub index: ${i}");
      HazizzLogger.printLog("Grades sub2: ${grades.grades.values.toList()[i]}");
      gradesByDate.addAll(grades.grades.values.toList()[i]);
    }



    /*
    for(List<PojoGrade> gradesSubject in grades.grades.values){
      HazizzLogger.printLog("Grades sub3: ${gradesSubject}");
      gradesByDate.addAll(gradesSubject);
    }
    */
    HazizzLogger.printLog("Grades sub LENGTH: ${gradesByDate.length}");

    gradesByDate.sort((a,b) => a.compareTo(b));


    return gradesByDate;
  }

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
      //  HazizzLogger.printLog("d: $d");


      return d.toString();
    }
    return "";
  }




  @override
  Stream<GradesState> mapEventToState(GradesEvent event) async* {
    if (event is GradesFetchEvent) {
      try {

        /*
        if(true){
          grades = new PojoGrades(
              {"Matek TESZT" : [
                PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "1", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
                PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "2", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 100),
                PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "3", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 50),
                PojoGrade(creationDate: DateTime(2013), date: DateTime(2019), grade: "1", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200)],

                "Történelem TESZT" : [
                  PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 100),
                  PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "3", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
                  PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "2", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 50),
                  PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "4", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 100)],

                "Komplex Természet Tudomány" : [
              PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2032), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 600)]

              ,"Komplex Természet Tudomány2" : [
              PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2032), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 600)]
              ,"Komplex Természet Tudomány3" : [
              PojoGrade(creationDate: DateTime(2011), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2012), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2032), date: DateTime(2019), grade: "3", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 200),
              PojoGrade(creationDate: DateTime(2010), date: DateTime(2019), grade: "5", gradeType: "teszt jegy", subject: "Nyelvtan Teszt", topic: "Ez csak teszt", weight: 600)]

              }
          );
          yield GradesLoadedState(grades);
          return;
        }
        */


        yield GradesWaitingState();
        HazizzLogger.printLog("log: am0 i here?");

        DataCache dataCache = await loadGradesCache();
        if(dataCache!= null){
          lastUpdated = dataCache.lastUpdated;
          grades = dataCache.data;
          yield GradesLoadedCacheState(grades);
        }

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetGrades());

        HazizzLogger.printLog("log: hazizzResponse: ${hazizzResponse.dioError}");


        if(hazizzResponse.isSuccessful){
          if(hazizzResponse.convertedData != null){
            grades = hazizzResponse.convertedData;
            lastUpdated = DateTime.now();
            saveGradesCache(grades);
            yield GradesLoadedState(grades);
          }else{
            yield GradesErrorState(hazizzResponse);
          }
        }

        if(hazizzResponse.isError){
          if(hazizzResponse.dioError == noConnectionError){
            yield GradesErrorState(hazizzResponse);
            Connection.addConnectionOnlineListener((){
              this.dispatch(GradesFetchEvent());
            },
                "grades_fetch"
            );
          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            HazizzLogger.printLog("log: noConnectionError22");
            this.dispatch(GradesFetchEvent());
          } else if(hazizzResponse.hasPojoError && hazizzResponse.pojoError.errorCode == 138) {
            yield GradesErrorState(hazizzResponse);

          }

          else{
            yield GradesErrorState(hazizzResponse);

          }
        }

      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}
//endregion
//endregion
