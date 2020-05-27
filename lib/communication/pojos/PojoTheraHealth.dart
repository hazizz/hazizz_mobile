import 'package:meta/meta.dart';
import 'dart:convert';

//part 'PojoTheraHealth.g.dart';

/*
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
*/

// To parse this JSON data, do
//
//     final pojoTheraHealth = pojoTheraHealthFromJson(jsonString);



class PojoTheraHealth {
  final String status;
  final Components components;

  PojoTheraHealth({
    @required this.status,
    @required this.components,
  });

  factory PojoTheraHealth.fromRawJson(String str) => PojoTheraHealth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PojoTheraHealth.fromJson(Map<String, dynamic> json) => PojoTheraHealth(
    status: json["status"],
    components: Components.fromJson(json["components"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "components": components.toJson(),
  };
}

class Components {
  final TheraHealthManager theraHealthManager;

  Components({
    @required this.theraHealthManager,
  });

  factory Components.fromRawJson(String str) => Components.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Components.fromJson(Map<String, dynamic> json) => Components(
    theraHealthManager: TheraHealthManager.fromJson(json["theraHealthManager"]),
  );

  Map<String, dynamic> toJson() => {
    "theraHealthManager": theraHealthManager.toJson(),
  };
}

class TheraHealthManager {
  final String status;
  final Details details;

  TheraHealthManager({
    @required this.status,
    @required this.details,
  });

  factory TheraHealthManager.fromRawJson(String str) => TheraHealthManager.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TheraHealthManager.fromJson(Map<String, dynamic> json) => TheraHealthManager(
    status: json["status"],
    details: Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "details": details.toJson(),
  };
}

class Details {
  final int kretaRequestsInLastHour;
  final double kretaSuccessRate;

  Details({
    @required this.kretaRequestsInLastHour,
    @required this.kretaSuccessRate,
  });

  factory Details.fromRawJson(String str) => Details.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    kretaRequestsInLastHour: json["kretaRequestsInLastHour"],
    kretaSuccessRate: json["kretaSuccessRate"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "kretaRequestsInLastHour": kretaRequestsInLastHour,
    "kretaSuccessRate": kretaSuccessRate,
  };
}
