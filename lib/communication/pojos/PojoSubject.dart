import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/communication/pojos/PojoComplient.dart';
import 'package:mobile/communication/pojos/PojoCreator.dart';

import 'Pojo.dart';
part 'PojoSubject.g.dart';

@JsonSerializable()
class  PojoSubject implements Pojo {

  int id;
  String name;
  bool subscriberOnly;
  PojoComplient manager;

  PojoSubject(this.id, this.name, this.subscriberOnly, this.manager);

  factory PojoSubject.fromJson(Map<String, dynamic> json) =>
      _$PojoSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$PojoSubjectToJson(this);

}