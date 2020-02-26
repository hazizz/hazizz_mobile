import 'package:json_annotation/json_annotation.dart';


import 'Pojo.dart';
part 'PojoTheraHealth.g.dart';

@JsonSerializable()
class  PojoTheraHealth implements Pojo {

  String status;
  PojoTheraHealth details;
  PojoTheraHealth theraHealthManager;
  int kretaRequestsInLastHour;
  double kretaSuccessRate;


  PojoTheraHealth(this.status, this.details, this.kretaRequestsInLastHour, this.kretaSuccessRate);

  factory PojoTheraHealth.fromJson(Map<String, dynamic> json) =>
      _$PojoTheraHealthFromJson(json);

  Map<String, dynamic> toJson() => _$PojoTheraHealthToJson(this);

}
