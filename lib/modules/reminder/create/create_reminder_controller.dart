import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/reminders/reminder_model.dart';
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

  var selectedIndex = 0.obs;
  var selectedType = "expense".obs;
  final dateController = TextEditingController();
  final expenseController = TextEditingController();
  final serviceController = TextEditingController();

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    expenseController.text = "select_expense_type".tr;
    serviceController.text = "select_service_type".tr;

    final now = DateTime.now();
    dateController.text = Utils.formatDate(date: now);
  }

  @override
  void onClose() {
    dateController.dispose();
    serviceController.dispose();
    expenseController.dispose();
    super.onClose();
  }

  void onSelectType(String type) {
    selectedType.value = type;
    model.value.reminderType = type;
  }

  void toggleBtn(int index) {
    selectedIndex.value = index;
  }

  void selectDate() async {
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

      dateController.text = date;
    }
  }

  Future<void> saveReminder() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      Utils.showProgressDialog(Get.context!);

      final map = {
        "vehicle_id": "",
        "date": dateController.text.trim(),
        "odometer": model.value.odometer,
        "reminder_type": selectedType.value == "expense"
            ? "Expense"
            : "Reminder",
        "reminder": selectedType.value == "expense"
            ? expenseController.text.trim()
            : serviceController.text.trim(),
        "notes": model.value.notes,
      };

      try {
        await FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.REMINDER)
            .doc()
            .set(map)
            .then((e) {
              if (Get.isDialogOpen == true) Get.back();
              Get.back();

              Utils.showSnackBar(message: "reminder_added".tr, success: true);
            })
            .catchError((e) {
              if (Get.isDialogOpen == true) Get.back();
              Utils.showSnackBar(message: "something_wrong".tr, success: false);
            });
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();

        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
