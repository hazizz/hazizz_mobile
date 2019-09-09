import 'PojoGrade.dart';

class PojoGradeWithSubject extends PojoGrade{



  PojoGradeWithSubject({DateTime date, DateTime creationDate, String subject, String topic,
    String gradeType, String grade, int weight}) : super(date: date, creationDate: creationDate, subject: subject, topic: topic, gradeType: gradeType, grade: grade, weight: weight){
  }

}