import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initialize() async {
    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleReminder({
    required int invoiceId,
    required String invoiceNumber,
    required DateTime dueDate,
  }) async {
    final targetDate = dueDate.subtract(const Duration(days: 1));
    final scheduledTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      9,
      0,
    );

    if (scheduledTime.isBefore(DateTime.now())) {
      return; // Only schedules if in the future
    }

    final androidDetails = const AndroidNotificationDetails(
      'invoice_reminders',
      'Invoice Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    final iosDetails = const DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.zonedSchedule(
      invoiceId,
      'Invoice Due Tomorrow',
      'Invoice $invoiceNumber is due tomorrow. Please follow up.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: invoiceId.toString(),
    );
  }

  Future<void> cancelReminder(int invoiceId) async {
    await _notificationsPlugin.cancel(invoiceId);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
