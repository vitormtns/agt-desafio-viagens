import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static final DateFormat _date = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _apiDate = DateFormat('yyyy-MM-dd');

  static String date(DateTime value) => _date.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value);

  static String apiDate(DateTime value) => _apiDate.format(value);
}
