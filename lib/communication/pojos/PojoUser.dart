import 'package:json_annotation/json_annotation.dart';
import 'Pojo.dart';

part 'PojoUser.g.dart';

@JsonSerializable()
class PojoUser implements Pojo {

  int id;
  String username;
  String displayName;
  DateTime registrationDate;

  PojoUser({this.id, this.username, this.displayName, this.registrationDate});

  factory PojoUser.fromJson(Map<String, dynamic> json) =>
      _$PojoUserFromJson(json);

  Map<String, dynamic> toJson() => _$PojoUserToJson(this);

}
