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
    HazizzLogger.printLog(ex);
    return null;
  }
}

String convertBack(HazizzTimeOfDay a){
  int hour = a.hour;
  int minute = a.minute;
  String str_hour = a.hour.toString();
  String str_minute = a.minute.toString();
  if(hour < 10){
    str_hour = "0$str_hour";
  }
  if(minute < 10){
    str_minute = "0$str_minute";
  }
  return "${str_hour}:${str_minute}:00";
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
      className: (json['className'] as String) ,
      teacher: json['teacher'] as String,
      room: json['room'] as String,
      topic: json['topic'] as String);
}

Map<String, dynamic> _$PojoClassToJson(PojoClass instance) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'startOfClass': convertBack(instance.startOfClass),
  'endOfClass': convertBack(instance.endOfClass),
  'periodNumber': instance.periodNumber,
  'cancelled': instance.cancelled,
  'standIn': instance.standIn,
  'subject': instance.subject,
  'className': instance.className,
  'teacher': instance.teacher,
  'room': instance.room,
  'topic': instance.topic
};