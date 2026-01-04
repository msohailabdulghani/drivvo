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

class UpdateIncomeController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late AppService appService;

  var filePath = "".obs;
  var lastOdometer = 0.obs;
  var model = IncomeModel().obs;

  var showConflictingCard = false.obs;
  late LastRecordModel lastRecord;

  // We need to store the original income map to remove it from the array
  late Map<String, dynamic> oldIncomeMap;

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final incomeTypeController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    // Get parameters passed from the previous screen
    if (Get.arguments != null && Get.arguments is Map) {
      final IncomeModel income = Get.arguments['income'];
      model.value = income;
      oldIncomeMap = income.rawMap;

      // Initialize controllers with existing data
      dateController.text = Utils.formatDate(date: income.date);
      timeController.text = income.time;
      incomeTypeController.text = income.incomeType;
      filePath.value = income.filePath;
    }

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
      initialDate: model.value.date,
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
      initialTime: TimeOfDay.fromDateTime(model.value.date),
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

  Future<void> updateIncome() async {
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

      final newIncomeMap = {
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

      try {
        final batch = FirebaseFirestore.instance.batch();

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.VEHICLES)
            .doc(appService.currentVehicleId.value);

        // Single atomic operation
        batch.set(vehicleRef, {
          'income_list': FieldValue.arrayRemove([oldIncomeMap]),
        }, SetOptions(merge: true));

        batch.set(vehicleRef, {
          'income_list': FieldValue.arrayUnion([newIncomeMap]),
        }, SetOptions(merge: true));

        if (model.value.odometer >= lastOdometer.value) {
          batch.update(vehicleRef, {"last_odometer": model.value.odometer});
        }

        await batch.commit();

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadTimelineData();
        }

        if (Get.isRegistered<ReportsController>()) {
          final report = Get.find<ReportsController>();
          report.calculateAllReports();
        }

        if (Get.isDialogOpen == true) Get.back();
        Get.back();
        Utils.showSnackBar(message: "income_updated".tr, success: true);
      } on FirebaseException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        debugPrint("Error updating income: $e");
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
