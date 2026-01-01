import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drivvo/model/reminder/reminder_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher', // App icon
      [
        NotificationChannel(
          channelKey: 'daily_channel',
          channelName: 'Daily Notifications',
          channelDescription: 'Daily scheduled notifications',
          importance: NotificationImportance.Max,
          defaultColor: Colors.blue,
          ledColor: Colors.white,
        ),
      ],
    );

    // Request permission if not granted
    await requestPermission();

    _initialized = true;
    debugPrint("Awesome Notifications initialized");
  }

  Future<void> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 1,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'daily_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // Schedule a single notification for a specific DateTime
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    final appService = Get.find<AppService>();

    final tim = appService.appUser.value.notificationTime;

    final parts = tim.split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'daily_channel',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        year: time.year,
        month: time.month,
        day: time.day,
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: false,
      ),
    );

    debugPrint("Notification scheduled for $time");
  }

  // Schedule multiple notifications from models
  Future<void> scheduleReminders({
    required List<ReminderModel> reminders,
  }) async {
    await cancelAll();
    debugPrint("Cancelled previous notifications");

    int id = 100; // starting ID

    for (var reminder in reminders) {
      // We expect ReminderModel but use dynamic to avoid circular dependency if any,
      // or just import it if it's safe. In this project it seems safe.

      final bool isOneTime = reminder.oneTime;

      if (isOneTime) {
        final time = reminder.startDate;
        if (time.isAfter(DateTime.now())) {
          await scheduleNotification(
            id: id++,
            title: "Reminder",
            body: "${reminder.subType} Reminder",
            time: time,
          );
        }
      } else {
        // Daily reminder
        final startDate = reminder.startDate;
        final endDate = reminder.endDate;

        final subType = reminder.subType;
        final period = reminder.period;

        //!final dateList = Utils.getDatesBetween(start: startDate, end: endDate);
        final months = Utils.getMonthsBetween(startDate, endDate);

        if (period == "day") {
          //! for (var date in dateList) {}
          final appService = Get.find<AppService>();

          final tim = appService.appUser.value.notificationTime;

          final parts = tim.split(' ');
          final timeParts = parts[0].split(':');

          if (timeParts.length < 2) {
            throw FormatException('Invalid time format');
          }

          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);

          await scheduleDailyReminder(
            id: id++,
            title: "Reminder",
            body: "$subType Reminder",
            hour: hour,
            minute: minute,
          );
          continue;
        } else {
          for (var e in months) {
            final int year = e['year']!;
            final int month = e['month']!;

            // Use day = 1 and time = 12:00 PM (safe for all months)
            final DateTime time = DateTime(year, month, 1, 12);

            await scheduleNotification(
              id: id++,
              title: "Reminder",
              body: "$subType Reminder",
              time: time,
            );
          }
          continue;
        }
      }
    }
  }

  // Schedule multiple notifications
  Future<void> scheduleAll({
    required List<DateTime> times,
    required String title,
    required String subTitle,
  }) async {
    await cancelAll();
    debugPrint("Cancelled previous notifications");

    final futureTimes = times.where((t) => t.isAfter(DateTime.now())).toList();

    int id = 500; // separate starting ID to avoid conflict with reminders

    for (var time in futureTimes) {
      String formatted = DateFormat('h:mm a').format(time);
      String date = Utils.formatDate(date: time);

      await scheduleNotification(
        id: id++,
        title: title,
        body: subTitle,
        time: time,
      );

      debugPrint("Notification scheduled for $date at $formatted");
    }
  }

  // Schedule a daily reminder at a specific time
  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'daily_channel',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );

    debugPrint("Daily reminder scheduled at $hour:$minute");
  }

  // Cancel a specific notification
  Future<void> cancel(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAll();
    debugPrint("All notifications cancelled");
  }
}
