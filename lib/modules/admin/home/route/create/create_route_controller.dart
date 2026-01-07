import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/last_record_model.dart';
import 'package:drivvo/model/route/route_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateRouteController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late AppService appService;

  var filePath = "".obs;
  var lastOdometer = 0.obs;
  var model = RouteModel().obs;

  var initalOdometer = 0.obs;
  int totalAmount = 0;

  var showConflictingCard = false.obs;
  late LastRecordModel lastRecord;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final reasonController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final initialOdometerController = TextEditingController();
  final finalOdometerController = TextEditingController();
  final valuePerKmController = TextEditingController();
  final totalController = TextEditingController();
  final driverController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;
  bool get isAdmin => appService.appUser.value.userType == Constants.ADMIN;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    final now = DateTime.now();
    model.value.startDate = now;
    model.value.endDate = now.add(Duration(days: 1));
    startDateController.text = Utils.formatDate(date: now);
    startTimeController.text = DateFormat('hh:mm a').format(now);
    endDateController.text = Utils.formatDate(date: now.add(Duration(days: 1)));
    endTimeController.text = DateFormat('hh:mm a').format(now);

    reasonController.text = "select_reason".tr;
    originController.text = "select_origin".tr;
    destinationController.text = "select_destination".tr;
    driverController.text = "select_your_driver".tr;

    lastOdometer.value = isAdmin
        ? appService.vehicleModel.value.lastOdometer
        : appService.driverVehicleModel.value.lastOdometer;
    calculateTotal();
  }

  @override
  void onClose() {
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
    reasonController.dispose();
    originController.dispose();
    destinationController.dispose();
    initialOdometerController.dispose();
    finalOdometerController.dispose();
    valuePerKmController.dispose();
    totalController.dispose();
    driverController.dispose();
    super.onClose();
  }

  void onSelectReason(String? reason) {
    if (reason != null) {
      model.value.reason = reason;
    }
  }

  void selectDate({required bool isStartDate}) async {
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

      if (isStartDate) {
        startDateController.text = date;
        model.value.startDate = picked;
      } else {
        endDateController.text = date;
        model.value.endDate = picked;
      }
    }
  }

  void selectTime({required bool isStartTime}) async {
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

      if (isStartTime) {
        startTimeController.text = time;
        model.value.startTime = time;
      } else {
        endTimeController.text = time;
        model.value.endTime = time;
      }
    }
  }

  void calculateTotal() {
    final initial = int.tryParse(initialOdometerController.text) ?? 0;
    initalOdometer.value = initial;
    final finalOdo = int.tryParse(finalOdometerController.text) ?? 0;
    final valuePerKm = int.tryParse(valuePerKmController.text) ?? 0;

    if (finalOdo > initial) {
      final total = (finalOdo - initial) * valuePerKm;
      totalController.text = total.toString();
      model.value.total = total;
    } else {
      totalController.text = "0";
      model.value.total = 0;
    }
  }

  Future<void> saveRoute() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      DateTime modelDate = DateTime(
        model.value.startDate.year,
        model.value.startDate.month,
        model.value.startDate.day,
      );
      DateTime lastDate = DateTime(
        lastRecord.date.year,
        lastRecord.date.month,
        lastRecord.date.day,
      );

      if (modelDate.isBefore(lastDate)) {
        debugPrint("Last record date is after route start date");
        showConflictingCard.value = true;
        return;
      }

      Utils.showProgressDialog();

      String? uploadedImageUrl;
      if (filePath.value.isNotEmpty) {
        try {
          uploadedImageUrl = await Utils.uploadImage(
            collectionPath: DatabaseTables.INCOME_IMAGES,
            filePath: filePath.value,
          );
          model.value.imagePath = uploadedImageUrl;
        } catch (e) {
          if (Get.isDialogOpen == true) Get.back();
          Utils.showSnackBar(message: "image_upload_failed".tr, success: false);
          return;
        }
      }

      final map = {
        "user_id": appService.appUser.value.id,
        "vehicle_id": appService.currentVehicleId.value,
        "origin": originController.text.trim(),
        "start_date": model.value.startDate,
        "start_time": startTimeController.text.trim(),
        "end_date": model.value.endDate,
        "end_time": endTimeController.text.trim(),
        "initial_odometer": int.tryParse(initialOdometerController.text) ?? 0,
        "destination": destinationController.text.trim(),
        "final_odometer": int.tryParse(finalOdometerController.text) ?? 0,
        "value_per_km": int.tryParse(valuePerKmController.text) ?? 0,
        "total": int.tryParse(totalController.text) ?? 0,
        "driver_name": model.value.driverName,
        "reason": reasonController.text.trim(),
        "file_path": filePath.value,
        "notes": model.value.notes,
        "image_path": model.value.imagePath,
        "driver_id": isAdmin ? "" : appService.appUser.value.id,
      };

      final lastRecordMap = {
        "type": "route",
        "date": model.value.startDate,
        "odometer": model.value.initialOdometer,
      };

      try {
        final adminId = isAdmin
            ? appService.appUser.value.id
            : appService.appUser.value.adminId;

        final vehicleId = isAdmin
            ? appService.currentVehicleId.value
            : appService.driverCurrentVehicleId.value;

        final batch = FirebaseFirestore.instance.batch();

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(adminId)
            .collection(DatabaseTables.VEHICLES)
            .doc(vehicleId);

        final userRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id);

        batch.set(vehicleRef, {
          'route_list': FieldValue.arrayUnion([map]),
          "last_odometer": int.tryParse(finalOdometerController.text) ?? 0,
        }, SetOptions(merge: true));

        batch.set(userRef, {
          "last_record": lastRecordMap,
        }, SetOptions(merge: true));

        await batch.commit();

        if (Get.isDialogOpen == true) Get.back();
        Get.back();
        Utils.showSnackBar(message: "route_added".tr, success: true);
      } on FirebaseException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
