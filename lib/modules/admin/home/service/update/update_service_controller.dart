import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/expense/expense_type_model.dart';
import 'package:drivvo/model/last_record_model.dart';
import 'package:drivvo/model/service/service_model.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/modules/admin/reports/reports_controller.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateServiceController extends GetxController {
  late AppService appService;
  final formKey = GlobalKey<FormState>();

  var serviceTyesList = <ExpenseTypeModel>[].obs;

  var totalAmount = 0.obs;
  var lastOdometer = 0.obs;

  var filePath = "".obs;
  var model = ServiceModel().obs;

  var showConflictingCard = false.obs;
  late LastRecordModel lastRecord;
  late Map<String, dynamic> oldServiceMap;

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final expenseTypeController = TextEditingController();
  final placeController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final reasonController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    if (Get.arguments != null && Get.arguments is Map) {
      final ServiceModel service = Get.arguments['service'];
      model.value = service;
      oldServiceMap = service.rawMap;

      // Initialize lists and observables
      serviceTyesList.value = List.from(service.serviceTypes);
      calculateTotal();
      filePath.value = service.filePath;

      // Initialize with existing data
      dateController.text = Utils.formatDate(date: service.date);
      timeController.text = service.time;
      placeController.text = service.place;
      paymentMethodController.text = service.paymentMethod;
      reasonController.text = service.reason;
      // Update display text
      updateServiceTypeDisplay();
    }

    lastOdometer.value = appService.vehicleModel.value.lastOdometer;
  }

  void updateServiceTypeDisplay() {
    if (serviceTyesList.isEmpty) {
      expenseTypeController.text = "select_expense_type".tr;
    } else {
      expenseTypeController.text = serviceTyesList
          .map((e) => e.name)
          .join(", ");
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    expenseTypeController.dispose();
    placeController.dispose();
    paymentMethodController.dispose();
    reasonController.dispose();
    super.onClose();
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
      dateController.text = Utils.formatDate(date: picked);
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

  Future<void> updateService() async {
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

      final newServiceMap = {
        "user_id": appService.appUser.value.id,
        "vehicle_id": appService.currentVehicleId.value,
        "time": timeController.text.trim(),
        "date": model.value.date,
        "odometer": model.value.odometer,
        "total_amount": totalAmount.value,
        "place": placeController.text.trim(),
        "driver_name": model.value.driverName,
        "payment_method": paymentMethodController.text.trim(),
        "reason": reasonController.text.trim(),
        "file_path": filePath.value,
        "notes": model.value.notes,
        "expense_types": serviceTyesList.map((e) => e.toJson()).toList(),
      };

      try {
        final batch = FirebaseFirestore.instance.batch();

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.VEHICLES)
            .doc(appService.currentVehicleId.value);

        batch.set(vehicleRef, {
          'service_list': FieldValue.arrayRemove([oldServiceMap]),
        }, SetOptions(merge: true));

        batch.set(vehicleRef, {
          'service_list': FieldValue.arrayUnion([newServiceMap]),
        }, SetOptions(merge: true));

        if (model.value.odometer >= lastOdometer.value) {
          batch.update(vehicleRef, {"last_odometer": model.value.odometer});
        }

        await batch.commit();

        if (Get.isDialogOpen == true) Get.back();
        Get.back();

        Utils.showSnackBar(message: "service_updated".tr, success: true);
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
        debugPrint("Error updating service: $e");
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }

  void removeItem(int index) {
    if (index < 0 || index >= serviceTyesList.length) return;
    serviceTyesList.removeAt(index);
    calculateTotal();
    updateServiceTypeDisplay();
    serviceTyesList.refresh();
  }

  void calculateTotal() {
    totalAmount.value = serviceTyesList
        .where((e) => e.isChecked.value)
        .fold(0, (a1, e) => a1 + e.value.value);
  }
}
