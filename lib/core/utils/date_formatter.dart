import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('d MMMM yyyy, HH:mm').format(date);
  }

  static String formatCityDate(String city, DateTime date) {
    return '$city, ${formatDate(date)}';
  }
}
