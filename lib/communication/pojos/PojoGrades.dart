import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';

part 'PojoGrades.gg.dart';

// removing so it wont recreate
//@JsonSerializable()
class PojoGrades extends Pojo{

  // final Map<String, List<PojoClass>> classes;

  final Map<String, List<PojoGrade>> grades;

  PojoGrades(this.grades);

  factory PojoGrades.fromJson(Map<String, dynamic> json) =>
      _$PojoGradesFromJson(json);
}