import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/communication/pojos/PojoComplient.dart';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PojoSubject &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}