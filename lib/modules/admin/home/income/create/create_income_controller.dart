import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/income/income_model.dart';
import 'package:drivvo/model/last_record_model.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/modules/admin/reports/reports_controller.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateIncomeController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late AppService appService;

  var filePath = "".obs;
  var lastOdometer = 0.obs;
  var model = IncomeModel().obs;

  var showConflictingCard = false.obs;
  late LastRecordModel lastRecord;

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final incomeTypeController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    final now = DateTime.now();
    model.value.date = now;
    dateController.text = Utils.formatDate(date: now);
    timeController.text = DateFormat('hh:mm a').format(now);

    incomeTypeController.text = "select_income_type".tr;

    lastOdometer.value = appService.vehicleModel.value.lastOdometer;
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    incomeTypeController.dispose();
    super.onClose();
  }

  void onSelectIncomeType(String? type) {
    if (type != null) {
      model.value.incomeType = type;
    }
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
      model.value.date = picked;
    }
  }

  void selectTime() async {
    final context = Get.context;
    if (context == null) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final time = DateFormat('hh:mm a').format(dt);
      timeController.text = time;
      model.value.time = time;
    }
  }

  Future<void> saveIncome() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      DateTime modelDate = DateTime(
        model.value.date.year,
        model.value.date.month,
        model.value.date.day,
      );
      DateTime lastDate = DateTime(
        lastRecord.date.year,
        lastRecord.date.month,
        lastRecord.date.day,
      );

      if (modelDate.isBefore(lastDate)) {
        debugPrint("Last Date is bigger");
        showConflictingCard.value = true;
        return;
      }

      Utils.showProgressDialog();

      final map = {
        "user_id": appService.appUser.value.id,
        "vehicle_id": appService.currentVehicleId.value,
        "time": timeController.text.trim(),
        "date": model.value.date,
        "odometer": model.value.odometer,
        "income_type": incomeTypeController.text.trim(),
        "value": model.value.value,
        "driver_name": model.value.driverName,
        "file_path": filePath.value,
        "notes": model.value.notes,
      };

      final lastRecordMap = {
        "type": "income",
        "date": model.value.date,
        "odometer": model.value.odometer,
      };

      try {
        final batch = FirebaseFirestore.instance.batch();

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.VEHICLES)
            .doc(appService.currentVehicleId.value);

        final userRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id);

        batch.set(vehicleRef, {
          'income_list': FieldValue.arrayUnion([map]),
          "last_odometer": model.value.odometer,
        }, SetOptions(merge: true));

        batch.update(userRef, {"last_record": lastRecordMap});

        await batch.commit();

        if (Get.isDialogOpen == true) Get.back();
        Get.back();

        Utils.showSnackBar(message: "income_added".tr, success: true);

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadTimelineData();
        }

        if (Get.isRegistered<ReportsController>()) {
          Get.find<ReportsController>().calculateAllReports();
        }
      } on FirebaseException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
