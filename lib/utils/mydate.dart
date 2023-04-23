import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Lấy giờ trong thời gian
class MyDate {
  static String formatDate(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    var date = DateFormat('HH:mm').format(sent);
    return date;
  }

//Lấy thời gian theo định dạng dd/MM/yyyy
  static String formatDateWithDDMMYYYY(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    var date = DateFormat('dd/MM/yyyy').format(sent);
    return date;
  }
}
