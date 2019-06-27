

import 'package:intl/intl.dart';

String hazizzShowDateFormat(DateTime dateTime){
  return DateFormat("yyyy.MM.dd").format(dateTime);
}

String hazizzRequestDateFormat(DateTime dateTime){
  return DateFormat("yyyy.MM.dd").format(dateTime);
}