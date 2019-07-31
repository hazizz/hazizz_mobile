// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeOfDay convertToHazizzTimeOfDay(String str_time){
  try{
    List<String> timePeriod = str_time.split(":");

    HazizzTimeOfDay hazizzTimeOfDay;
    int hour = int.parse(timePeriod[0]);
    int minute = int.parse(timePeriod[1]);
    hazizzTimeOfDay = HazizzTimeOfDay(hour: hour, minute: minute);
    return hazizzTimeOfDay;
  }catch(ex){
    print(ex);
    return null;
  }
}


PojoClass _$PojoClassFromJson(Map<String, dynamic> json) {
  return PojoClass(
      date:
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      startOfClass:
      json['startOfClass'] == null ? null : convertToHazizzTimeOfDay(json['startOfClass'] as String),
      endOfClass:
      json['endOfClass'] == null ? null : convertToHazizzTimeOfDay(json['endOfClass'] as String),
      periodNumber: json['periodNumber'] as int,
      cancelled: json['cancelled'] as bool,
      standIn: json['standIn'] as bool,
      subject: json['subject'] as String,
      className: json['className'] as String,
      teacher: json['teacher'] as String,
      room: json['room'] as String,
      topic: json['topic'] as String);
}

Map<String, dynamic> _$PojoClassToJson(PojoClass instance) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'startOfClass': instance.startOfClass,
  'endOfClass': instance.endOfClass,
  'periodNumber': instance.periodNumber,
  'cancelled': instance.cancelled,
  'standIn': instance.standIn,
  'subject': instance.subject,
  'className': instance.className,
  'teacher': instance.teacher,
  'room': instance.room,
  'topic': instance.topic
};