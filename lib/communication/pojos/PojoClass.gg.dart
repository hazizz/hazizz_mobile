// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PojoClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeOfDay convertToHazizzTimeOfDay(String str_time){
  try{
    List<String> timePeriod = str_time.split(":");

    TimeOfDay hazizzTimeOfDay;
    int hour = int.parse(timePeriod[0]);
    int minute = int.parse(timePeriod[1]);
    hazizzTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    return hazizzTimeOfDay;
  }catch(ex){
    HazizzLogger.printLog(ex);
    return null;
  }
}

String convertBack(TimeOfDay a){
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
  return "$str_hour:$str_minute:00";
}

PojoClass _$PojoClassFromJson(Map<String, dynamic> json) {

  String start = (json['startOfClass'] != null ? json['startOfClass'] :  json['start'])as String;
  String end = (json['endOfClass'] != null ? json['endOfClass'] :  json['end']) as String;
  String topic = (json['topic'] != null ? json['topic'] :  json['description'])  as String;
  String attendee = (json['className'] != null ? json['className'] :  json['attendee']) as String;
  bool standIn = (json['standIn'] != null ? json['standIn'] :  json['hostReplaced']) as bool;
  String room = (json['room'] != null ? json['room'] :  json['location']) as String;
  String teacher = (json['teacher'] != null ? json['teacher'] :  json['host']) as String;
  String subject = (json['subject'] != null ? json['subject'] :  json['title']) as String;


  return PojoClass(
      accountId: json['accountId'] as String,
      date:
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      startOfClass: convertToHazizzTimeOfDay(start),
      endOfClass: convertToHazizzTimeOfDay(end),
      periodNumber: json['periodNumber'] as int,
      cancelled: json['cancelled'] as bool,
      standIn: standIn,
      subject: subject,
      className: attendee ,
      teacher: teacher,
      room: room,
      topic: topic);
}

Map<String, dynamic> _$PojoClassToJson(PojoClass instance) => <String, dynamic>{
  'accountId': instance.accountId,
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