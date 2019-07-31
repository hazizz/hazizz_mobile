import 'Pojo.dart';
import 'PojoClass.dart';

part 'PojoSchedules.gg.dart';

// removing so it wont recreate
//@JsonSerializable()
class PojoSchedules extends Pojo{

  final Map<String, List<PojoClass>> classes;

  /*
  final List<PojoClass> monday;
  final List<PojoClass> tuesday;
  final List<PojoClass> wednesday;
  final List<PojoClass> thursday;
  final List<PojoClass> friday;
  final List<PojoClass> saturday;
  final List<PojoClass> sunday;
  */

//  PojoSchedules(this.monday, this.tuesday, this.wednesday, this.thursday,
 //     this.friday, this.saturday, this.sunday);
  PojoSchedules(this.classes);

  factory PojoSchedules.fromJson(Map<String, dynamic> json) =>
      _$PojoSchedulesFromJson(json);
}