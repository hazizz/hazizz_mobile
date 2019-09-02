import 'package:json_annotation/json_annotation.dart';

import 'Pojo.dart';
part 'PojoInviteLink.g.dart';


@JsonSerializable()
class PojoInviteLink extends Pojo {
  int id;
  String link;

  PojoInviteLink(this.id, this.link);

  factory PojoInviteLink.fromJson(Map<String, dynamic> json) =>
      _$PojoInviteLinkFromJson(json);


}