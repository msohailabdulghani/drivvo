import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/reminder/reminder_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReminderController extends GetxController {
  late AppService appService;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;
  final formKey = GlobalKey<FormState>();
  final List<String> reminderTyeList = ['expense', 'service'];

  var model = ReminderModel().obs;
  var lastOdometer = 0.obs;

  var selectedIndex = 0.obs;
  var selectedType = "expense".obs;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final expenseController = TextEditingController();
  final serviceController = TextEditingController();
  final targetOdometerController = TextEditingController();

  // One Time Mode Observables
  var oneTimeByDistance = false.obs;
  var oneTimeByDate = true.obs; // Default to date enabled for basic one-time

  // Repeat Mode Observables & Controllers
  var repeatByDistance = false.obs;
  final repeatDistanceIntervalController = TextEditingController();

  var repeatByTime = false.obs;
  final repeatTimeIntervalController = TextEditingController();
  var repeatTimeUnit = "month".obs;

  // To track last valid odometer and date for calculation
  late int currentOdometer;
  late DateTime currentDate;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    expenseController.text = "select_expense_type".tr;
    serviceController.text = "select_service_type".tr;
    model.value.period = "day";

    final now = DateTime.now();
    startDateController.text = Utils.formatDate(date: now);

    lastOdometer.value = appService.vehicleModel.value.lastOdometer;
    currentOdometer = lastOdometer.value;
    currentDate = now;

    // Listeners for auto-calculation
    repeatDistanceIntervalController.addListener(_calculateTargetOdometer);
    repeatTimeIntervalController.addListener(_calculateTargetDate);

    ever(repeatTimeUnit, (_) => _calculateTargetDate());
    ever(repeatByTime, (_) => _calculateTargetDate());
    ever(repeatByDistance, (_) => _calculateTargetOdometer());

    // Initial value for target odometer (current + ?)
    targetOdometerController.text = lastOdometer.value.toString();
  }

  void _calculateTargetOdometer() {
    if (repeatByDistance.value &&
        repeatDistanceIntervalController.text.isNotEmpty) {
      final interval =
          int.tryParse(
            repeatDistanceIntervalController.text.replaceAll(',', ''),
          ) ??
          0;
      if (interval > 0) {
        model.value.odometer = currentOdometer + interval;
        // Update UI or Model? The UI for odometer is a TextInputField, usually manual or auto.
        // We might want to update a controller for the Target Odometer if we had one,
        // but currently it uses TextInputField with initialValue or bindings.
        // Let's assume we need to update the field if we want the user to see it.
        // But the previous view didn't have a controller for odometer, just onSaved.
        // I should probably add a controller for odometer to update it dynamically.
        targetOdometerController.text = model.value.odometer.toString();
      }
    }
  }

  void _calculateTargetDate() {
    if (repeatByTime.value && repeatTimeIntervalController.text.isNotEmpty) {
      final interval = int.tryParse(repeatTimeIntervalController.text) ?? 0;
      if (interval > 0) {
        DateTime target = currentDate;
        switch (repeatTimeUnit.value) {
          case 'day':
            target = target.add(Duration(days: interval));
            break;
          case 'week':
            target = target.add(Duration(days: interval * 7));
            break;
          case 'month':
            target = DateTime(target.year, target.month + interval, target.day);
            break;
          case 'year':
            target = DateTime(target.year + interval, target.month, target.day);
            break;
        }
        startDateController.text = Utils.formatDate(date: target);
        model.value.startDate = target;
      }
    }
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    serviceController.dispose();
    expenseController.dispose();
    targetOdometerController.dispose();
    repeatDistanceIntervalController.dispose();
    repeatTimeIntervalController.dispose();
    super.onClose();
  }

  void onSelectType(String type) {
    selectedType.value = type;
    model.value.type = type;
  }

  void toggleBtn(int index) {
    selectedIndex.value = index;
  }

  void selectDate({required bool isStart}) async {
    final context = Get.context;
    if (context == null) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final date = Utils.formatDate(date: picked);

      if (isStart) {
        model.value.startDate = picked;
        startDateController.text = date;
      } else {
        model.value.endDate = picked;
        endDateController.text = date;
      }
    }
  }

  void onSelectPeriod(String? value) {
    if (value != null) {
      model.value.period = value;
    }
  }

  Future<void> saveReminder() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      Utils.showProgressDialog();
      final ref = FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.REMINDER);

      final id = ref.doc().id;

      final map = {
        "id": id,
        "type": model.value.type,
        "sub_type": selectedType.value == "expense"
            ? expenseController.text.trim()
            : serviceController.text.trim(),
        "notes": model.value.notes,
        "one_time": selectedIndex.value == 0 ? true : false,

        // One Time Logic
        "odometer":
            ((selectedIndex.value == 0 && oneTimeByDistance.value) ||
                (selectedIndex.value == 1 && repeatByDistance.value))
            ? int.tryParse(targetOdometerController.text.replaceAll(',', '')) ??
                  0
            : 0,
        "start_date":
            ((selectedIndex.value == 0 && oneTimeByDate.value) ||
                (selectedIndex.value == 1 && repeatByTime.value))
            ? model.value.startDate
            : null,
        "one_time_by_distance":
            (selectedIndex.value == 0 && oneTimeByDistance.value),
        "one_time_by_date": (selectedIndex.value == 0 && oneTimeByDate.value),

        // Repeat Logic
        "repeat_by_distance":
            (selectedIndex.value == 1 && repeatByDistance.value),
        "repeat_distance_interval":
            (selectedIndex.value == 1 && repeatByDistance.value)
            ? int.tryParse(
                    repeatDistanceIntervalController.text.replaceAll(',', ''),
                  ) ??
                  0
            : 0,

        "repeat_by_time": (selectedIndex.value == 1 && repeatByTime.value),
        "repeat_time_interval": (selectedIndex.value == 1 && repeatByTime.value)
            ? int.tryParse(repeatTimeIntervalController.text) ?? 0
            : 0,
        "repeat_time_unit": (selectedIndex.value == 1 && repeatByTime.value)
            ? repeatTimeUnit.value
            : null,

        // Legacy/Unused fields set to defaults or nulls where appropriate if not in use
        "end_date": null,
        "period": selectedIndex.value == 1
            ? "custom"
            : "", // Indicating custom repetition
      };

      // Validation: At least one condition must be active
      bool isValid = false;
      if (selectedIndex.value == 0) {
        if (oneTimeByDistance.value || oneTimeByDate.value) isValid = true;
      } else {
        if (repeatByDistance.value || repeatByTime.value) isValid = true;
      }

      if (!isValid) {
        Utils.showSnackBar(
          message: "select_condition".tr,
          success: false,
        ); // "Please select at least one condition"
        return;
      }

      try {
        await ref.doc(id).set(map);

        if (Get.isDialogOpen == true) Get.back();
        Get.back();
        Utils.showSnackBar(message: "reminder_added".tr, success: true);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
