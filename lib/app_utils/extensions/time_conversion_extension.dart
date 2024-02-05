import 'package:flutter/material.dart';

extension UnixConversion on BuildContext {
  DateTime convertUnixToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

extension DateTimeConversion on BuildContext {
  int convertDateTimeToUnix(DateTime date) {
    return date.toUtc().millisecondsSinceEpoch;
  }
}
