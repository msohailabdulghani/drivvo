import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/reminder/reminder_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/services/notification_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:get/get.dart';

class ReminderController extends GetxController {
  late AppService appService;
  var isLoading = false.obs;
  var reminderList = <ReminderModel>[].obs;
  var lastOdometer = 0.obs;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  StreamSubscription? _subscription;
  bool isFirstTime = true;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
    getReminders();

    lastOdometer.value = appService.appUser.value.lastOdometer;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> getReminders() async {
    _subscription?.cancel();

    isLoading.value = true;

    try {
      _subscription = FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.REMINDER)
          .snapshots()
          .listen((docSnapshot) {
            if (docSnapshot.docs.isNotEmpty) {
              reminderList.value = docSnapshot.docs.map((doc) {
                return ReminderModel.fromJson(doc.data());
              }).toList();

              if (isFirstTime && reminderList.isNotEmpty) {
                NotificationService().scheduleReminders(
                  reminders: reminderList,
                );
                isFirstTime = false;
              }
              isLoading.value = false;
            }
            isLoading.value = false;
          });
    } catch (e) {
      isLoading.value = false;
      Utils.showSnackBar(message: "something_went_wrong".tr, success: false);
    }
  }

  int getDistance(ReminderModel model) {
    return model.odometer - lastOdometer.value;
  }

  int getDays(DateTime targetDate) {
    DateTime today = DateTime.now();

    // Normalize both to remove time difference
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);
    DateTime normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    if (normalizedTarget.isAfter(normalizedToday)) {
      int daysCount = normalizedTarget.difference(normalizedToday).inDays;
      return daysCount;
    } else {
      return 0;
    }
  }
}
