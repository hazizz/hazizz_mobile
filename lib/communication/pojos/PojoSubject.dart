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
  bool subscribed;

  PojoSubject(this.id, this.name, this.subscriberOnly, this.manager, this.subscribed);

  factory PojoSubject.fromJson(Map<String, dynamic> json) =>
      _$PojoSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$PojoSubjectToJson(this);

  bool operator ==(dynamic other) {
    if(other is PojoSubject){
      return this.id == other.id;
    }
    return false;

  }

}