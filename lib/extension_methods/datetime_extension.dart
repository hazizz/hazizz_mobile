import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {

  DateTime operator -(Duration other) {
    return this.subtract(other);

  }

  DateTime operator +(Duration other) {
    return this.add(other);
  }

  String get hazizzRequestDateFormat => DateFormat("yyyy-MM-dd").format(this);

}