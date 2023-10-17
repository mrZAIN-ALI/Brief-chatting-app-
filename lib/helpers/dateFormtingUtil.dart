import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateFormatUtil {
  static String FormatDate(
      {required BuildContext context, required String unfromatedDate}) {
    final time = DateTime.fromMillisecondsSinceEpoch(int.parse(unfromatedDate));

    return TimeOfDay.fromDateTime(time).format(context);
  }
}
