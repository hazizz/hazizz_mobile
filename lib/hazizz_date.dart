

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

String hazizzShowDateFormat(DateTime dateTime){
  return DateFormat("yyyy.MM.dd").format(dateTime);
}

String hazizzRequestDateFormat(DateTime dateTime){
  return DateFormat("yyyy.MM.dd").format(dateTime);
}

Duration hazizzParseDuration(String hhmmss){
  List<String> timeList = hhmmss.split(":");
  List<int> timeListFinal = List();
  for(String time in timeList){
    String t = time.replaceFirst(RegExp('0'), "");
    int a = int.parse(t);
    timeListFinal.add(a);
  }
  Duration duration = Duration(hours: timeListFinal[0],microseconds: timeListFinal[1],seconds: timeListFinal[2]);
  return duration;
}


bool hazizzIsAfterHHMMSS({@required DateTime mainTime, @required Duration compareTime}){
  Duration mainDuration = Duration(hours: mainTime.hour, minutes: mainTime.minute, seconds: mainTime.second);

  int mainInSec = mainDuration.inSeconds;
  int compareInSec = compareTime.inSeconds;

  return compareInSec > mainInSec;
}

bool hazizzIsBeforeHHMMSS({@required DateTime mainTime, @required Duration compareTime}){
  Duration mainDuration = Duration(hours: mainTime.hour, minutes: mainTime.minute, seconds: mainTime.second);

  int mainInSec = mainDuration.inSeconds;
  int compareInSec = compareTime.inSeconds;

  return compareInSec < mainInSec;
}
