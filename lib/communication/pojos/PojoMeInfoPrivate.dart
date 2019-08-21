
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';

import 'Pojo.dart';
import 'PojoGroup.dart';

part 'PojoMeInfoPrivate.g.dart';

@JsonSerializable()
class PojoMeInfoPrivate extends PojoMeInfo{

  final List<String> permissions;
  final List<PojoGroup> groups;

  PojoMeInfoPrivate(int id, String username, String displayName, this.permissions, this.groups): super(id, username, displayName);

  factory PojoMeInfoPrivate.fromJson(Map<String, dynamic> json) =>
      _$PojoMeInfoPrivateFromJson(json);

  Map<String, dynamic> toJson() => _$PojoMeInfoPrivateToJson(this);

}