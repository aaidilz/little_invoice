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

    await _notificationsPlugin.initialize(settings: initSettings);
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
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'invoice_reminders',
      'Invoice Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.zonedSchedule(
      id: invoiceId,
      title: 'Invoice Due Tomorrow',
      body: 'Invoice $invoiceNumber is due tomorrow. Please follow up.',
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: invoiceId.toString(),
    );
  }

  Future<void> cancelReminder(int invoiceId) async {
    await _notificationsPlugin.cancel(id: invoiceId);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
