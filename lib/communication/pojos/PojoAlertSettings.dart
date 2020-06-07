import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/communication/pojos/Pojo.dart';

part 'PojoAlertSettings.g.dart';

@JsonSerializable()
class PojoAlertSettings  implements Pojo {

  String alarmTime;
  bool mondayEnabled;
  bool tuesdayEnabled;
  bool wednesdayEnabled;
  bool thursdayEnabled;
  bool fridayEnabled;
  bool saturdayEnabled;
  bool sundayEnabled;

  PojoAlertSettings({this.alarmTime, this.mondayEnabled, this.tuesdayEnabled, this.wednesdayEnabled,
                     this.thursdayEnabled, this.fridayEnabled, this.saturdayEnabled, this.sundayEnabled});

  @override
  factory PojoAlertSettings.fromJson(Map<String, dynamic> json) =>
      _$PojoAlertSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PojoAlertSettingsToJson(this);
}






