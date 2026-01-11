import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drivvo/model/reminder/reminder_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  // Mutex/lock to prevent concurrent scheduling
  bool _isScheduling = false;
  Completer<void>? _schedulingCompleter;

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
        hour: time.hour,
        minute: time.minute,
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
    // Mutex: Wait if already scheduling
    if (_isScheduling) {
      debugPrint("Schedule reminders already in progress, waiting...");
      if (_schedulingCompleter != null) {
        await _schedulingCompleter!.future;
      }
      if (_isScheduling) {
        debugPrint("Skipping duplicate schedule request");
        return;
      }
    }

    // Acquire lock
    _isScheduling = true;
    _schedulingCompleter = Completer<void>();

    try {
      await cancelAll();
      debugPrint("Cancelled previous notifications");

      int id = 100; // starting ID
      final appService = Get.find<AppService>();
      final notifTimeStr = appService.notificationTime.value; // "09:00 PM"

      int preferredHour = 9;
      int preferredMinute = 0;

      // Parse Notification Time
      try {
        final parts = notifTimeStr.split(' '); // ["09:00", "PM"]
        final timeParts = parts[0].split(':');
        int h = int.parse(timeParts[0]);
        int m = int.parse(timeParts[1]);

        if (parts.length > 1) {
          if (parts[1].toUpperCase() == "PM" && h != 12) h += 12;
          if (parts[1].toUpperCase() == "AM" && h == 12) h = 0;
        }
        preferredHour = h;
        preferredMinute = m;
      } catch (e) {
        debugPrint("Error parsing notification time '$notifTimeStr': $e");
      }

      for (var reminder in reminders) {
        // Determine if it is a Daily Repeating reminder
        bool isDaily = false;

        // New Logic Check
        if (reminder.repeatByTime &&
            reminder.repeatTimeUnit == 'day' &&
            reminder.repeatTimeInterval == 1) {
          isDaily = true;
        }
        // Legacy Logic Check
        else if (!reminder.oneTime && reminder.period == 'day') {
          isDaily = true;
        }

        final subType = reminder.subType; // Title usually

        if (isDaily) {
          // Schedule Daily Repeated Notification
          await scheduleDailyReminder(
            id: id++,
            title: "Reminder",
            body: "$subType Reminder",
            hour: preferredHour,
            minute: preferredMinute,
          );
        } else {
          // Schedule Single Notification at Next Due Date
          // Covers: One-Time Reminders AND Recurring (Interval > 1 day or custom)

          DateTime targetDate = reminder.startDate;

          // Apply preferred time to the target date
          final scheduledDateTime = DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
            preferredHour,
            preferredMinute,
          );

          if (scheduledDateTime.isAfter(DateTime.now())) {
            await scheduleNotification(
              id: id++,
              title: "Reminder",
              body: "$subType Reminder",
              time: scheduledDateTime,
            );
          }
        }
      }

      debugPrint("Successfully scheduled reminders");
    } catch (e) {
      debugPrint("Error scheduling reminders: $e");
      rethrow;
    } finally {
      // Release lock
      _isScheduling = false;
      if (_schedulingCompleter != null && !_schedulingCompleter!.isCompleted) {
        _schedulingCompleter!.complete();
      }
      _schedulingCompleter = null;
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
