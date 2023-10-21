import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateFormatUtil {
  static String FormatDate(
      {required BuildContext context, required String unfromatedDate}) {
    final time = DateTime.fromMillisecondsSinceEpoch(int.parse(unfromatedDate));

    return TimeOfDay.fromDateTime(time).format(context);
  }

  static String formatLastMesgSentTime(
      {required BuildContext context, required String unfromatedDate}) {
    final time = DateTime.fromMillisecondsSinceEpoch(int.parse(unfromatedDate));
    final currentTime = DateTime.now();
    final difference = currentTime.difference(time);
    if (difference.inDays > 0) {
      return "${time.day} ${getMonth(time.month)}";
    } else {
      return TimeOfDay.fromDateTime(time).format(context);
    }
    // return TimeOfDay.fromDateTime(time).format(context);
  }

  static String getMonth(int day) {
    switch (day) {
      case 1:
        return "jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "Naot Available";
  }
}
