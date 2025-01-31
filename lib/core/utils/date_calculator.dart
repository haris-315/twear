import 'package:intl/intl.dart';

int calculateDifference(String date) {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime dateTime = dateFormat.parse(date);

  DateTime today = DateTime.now();

  Duration difference = dateTime.difference(today);

  return difference.inDays.abs();
}
