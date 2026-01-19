import 'dart:async';
import 'dart:io';

import 'package:drivvo/model/reminder/reminder_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  // Mutex/lock to prevent concurrent scheduling
  bool _isScheduling = false;
  Completer<void>? _schedulingCompleter;

  Future<void> init() async {
    if (_initialized) return;

    // Initialize Timezone
    await _configureLocalTimeZone();

    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            onNotificationTap(notificationResponse);
          },
    );

    // Create notification channel for Android (required for Android 8.0+)
    if (Platform.isAndroid) {
      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        'daily_channel',
        'Daily Notifications',
        description: 'Daily scheduled notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: const Color(0xFF00FF00),
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      debugPrint("Android notification channel created: ${channel.id}");
    }

    _initialized = true;
    debugPrint("Flutter Local Notifications initialized");

    // Request permissions
    await requestPermission();

    // Test Notification
    bool? isAllowed = false;

    if (Platform.isAndroid) {
      isAllowed = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
    } else if (Platform.isIOS) {
      // For iOS, we assume notifications are allowed if permissions were granted
      isAllowed = true;
    }

    if (isAllowed == true) {
      debugPrint(
        "Permissions granted. Scheduling test notification in 5 seconds.",
      );
      // Timer(const Duration(seconds: 5), () {
      //   showNotification(
      //     title: "Test Notification",
      //     body: "If you see this, notifications are working!",
      //   );
      // });
    } else {
      debugPrint(
        "Notifications not allowed, skipping test notification. User must enable permissions in Settings.",
      );
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      debugPrint("Detected Local Timezone: $timeZoneName");
      tz.setLocalLocation(tz.getLocation(timeZoneName.toString()));
      debugPrint("Timezone initialized: ${tz.local.name}");
    } catch (e) {
      debugPrint("Could not set local location: $e");
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
        debugPrint("Fallback to UTC");
      } catch (_) {}
    }
  }

  Future<void> onNotificationTap(NotificationResponse response) async {
    // Handle notification tap logic here
    debugPrint("Notification tapped: ${response.payload}");
    // Example: Get.toNamed(AppRoutes.NotificationPage);
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      // Request permission for Android 13+
      await androidImplementation?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 1,
    String? payload,
  }) async {
    // Ensure we are initialized or just try properly

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Daily scheduled notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          playSound: true,
          enableVibration: true,
          enableLights: true,
          visibility: NotificationVisibility.public,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule a single notification for a specific DateTime
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    try {
      if (time.isBefore(DateTime.now())) {
        debugPrint("Cannot schedule notification in the past: $time");
        return;
      }

      final tzDateTime = tz.TZDateTime.from(time, tz.local);
      debugPrint("Scheduling notification for local time: $time");
      debugPrint(
        "Converted to TZDateTime (Location: ${tz.local.name}): $tzDateTime",
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Notifications',
            channelDescription: 'Daily scheduled notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            visibility: NotificationVisibility.public,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint("Notification successfully scheduled for $time");
    } catch (e) {
      debugPrint("Error scheduling notification: $e");
    }
  }

  // Schedule multiple notifications from models
  Future<void> scheduleReminders({
    required List<ReminderModel> reminders,
  }) async {
    if (_isScheduling) {
      debugPrint("Schedule reminders already in progress, waiting...");
      if (_schedulingCompleter != null) {
        await _schedulingCompleter!.future;
      }
      if (_isScheduling) return;
    }

    _isScheduling = true;
    _schedulingCompleter = Completer<void>();

    try {
      await cancelAll();
      debugPrint("Cancelled previous notifications");

      int id = 100;
      final appService = Get.find<AppService>();
      final notifTimeStr = appService.notificationTime.value;

      int preferredHour = 9;
      int preferredMinute = 0;

      // Parse Notification Time
      try {
        final parts = notifTimeStr.split(' ');
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
        debugPrint("Processing Reminder: $subType. isDaily: $isDaily. ID: $id");

        if (isDaily) {
          // Schedule Daily Repeated Notification
          await scheduleDailyReminder(
            id: id++,
            title: "Reminder",
            body: "${reminder.type.toUpperCase()}: $subType",
            hour: preferredHour,
            minute: preferredMinute,
          );
        } else {
          // Schedule Single Notification at Next Due Date
          DateTime targetDate = reminder.startDate;

          // Apply preferred time to the target date
          final scheduledDateTime = DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
            preferredHour,
            preferredMinute,
          );

          final now = DateTime.now();
          debugPrint("ScheduledDT: $scheduledDateTime vs Now: $now");

          if (scheduledDateTime.isAfter(now)) {
            // If scheduling for the future, go ahead.
            // Warning: If it's less than a few seconds in the future, iOS might miss it.
            await scheduleNotification(
              id: id++,
              title: "Reminder",
              body: "${reminder.type.toUpperCase()}: $subType",
              time: scheduledDateTime,
            );
          } else {
            debugPrint("Skipping past reminder: $scheduledDateTime");
          }
        }
      }

      debugPrint("Successfully scheduled reminders");
    } catch (e) {
      debugPrint("Error scheduling reminders: $e");
      rethrow;
    } finally {
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
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Daily scheduled notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          visibility: NotificationVisibility.public,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint("Daily reminder scheduled at $hour:$minute");
  }

  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    debugPrint("All notifications cancelled");
  }
}
