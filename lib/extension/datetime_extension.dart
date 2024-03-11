import 'package:intl/intl.dart';

List<String> month = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

extension DateTimeExtend on DateTime {
  String nameMonth() {
    return month[this.month - 1];
  }

  String formatddMMyyyy() {
    return '${day.toString().padLeft(2, '0')} ${month[this.month - 1]} $year';
  }

  DateTime firstOfWeek() {
    DateTime data = subtract(Duration(days: weekday - 1));
    if (data.month < this.month) {
      data = DateTime(year, this.month, 1);
    }
    return data;
  }

  DateTime endOfWeek() {
    DateTime newDay = add(Duration(days: (DateTime.daysPerWeek - weekday)));
    if (newDay.month != this.month) {
      newDay = newDay.subtract(Duration(days: newDay.day));
    }
    return newDay;
    // return add(Duration(days: (DateTime.daysPerWeek - weekday)));
  }

  String nameOfDay() {
    return DateFormat('EEEE').format(this);
  }

  String ddmmyyyy() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String yyyymmdd() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
