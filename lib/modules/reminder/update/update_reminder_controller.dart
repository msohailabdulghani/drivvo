import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/reminder/reminder_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateReminderController extends GetxController {
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

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    final reminder = Get.arguments;
    if (reminder == null || reminder is! ReminderModel) {
      Get.back();
      Utils.showSnackBar(message: "something_wrong".tr, success: false);
      return;
    }

    model.value = reminder;
    expenseController.text = model.value.type == "expense"
        ? model.value.subType
        : "";
    serviceController.text = model.value.type == "service"
        ? model.value.subType
        : "";

    selectedIndex.value = model.value.oneTime ? 0 : 1;
    selectedType.value = model.value.type == "expense" ? "expense" : "service";

    startDateController.text = Utils.formatDate(date: model.value.startDate);
    if (!model.value.oneTime) {
      endDateController.text = Utils.formatDate(date: model.value.endDate);
    }

    lastOdometer.value = appService.appUser.value.lastOdometer;
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    serviceController.dispose();
    expenseController.dispose();
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

      final map = {
        "type": model.value.type,
        "sub_type": selectedType.value == "expense"
            ? expenseController.text.trim()
            : serviceController.text.trim(),
        "odometer": model.value.odometer,
        "notes": model.value.notes,
        "one_time": selectedIndex.value == 0 ? true : false,
        "start_date": model.value.startDate,
        "end_date": model.value.endDate,
        "period": model.value.period,
      };

      try {
        await FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.REMINDER)
            .doc(model.value.id)
            .update(map);

        if (Get.isDialogOpen == true) Get.back();
        Get.back();
        Utils.showSnackBar(message: "reminder_updated".tr, success: true);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
