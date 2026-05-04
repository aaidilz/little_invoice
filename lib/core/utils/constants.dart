import 'dart:math';
import 'package:intl/intl.dart';

String generateInvoiceNumber() {
  final now = DateTime.now();
  final datePart = DateFormat('yyyyMMdd').format(now);
  final randomPart = (1000 + Random().nextInt(9000)).toString();
  return 'INV-$datePart-$randomPart';
}
