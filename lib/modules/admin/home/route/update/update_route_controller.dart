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

class UpdateRouteController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late AppService appService;

  var filePath = "".obs;
  var lastOdometer = 0.obs;
  var model = RouteModel().obs;

  var showConfilctingCard = false.obs;
  late LastRecordModel lastRecord;

  late Map<String, dynamic> oldRouteMap;

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
  final notesController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;
  bool get isAdmin => appService.appUser.value.userType == Constants.ADMIN;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    if (Get.arguments != null && Get.arguments is Map) {
      final RouteModel route = Get.arguments['route'];
      model.value = route;
      oldRouteMap = route.rawMap;

      // Initialize with existing data
      startDateController.text = Utils.formatDate(date: route.startDate);
      startTimeController.text = route.startTime;
      endDateController.text = Utils.formatDate(date: route.endDate);
      endTimeController.text = route.endTime;

      originController.text = route.origin;
      destinationController.text = route.destination;
      reasonController.text = route.reason;

      initialOdometerController.text = route.initialOdometer.toString();
      finalOdometerController.text = route.finalOdometer.toString();
      valuePerKmController.text = route.valuePerKm.toString();
      totalController.text = route.total.toString();

      driverController.text = route.driverName;
      notesController.text = route.notes;
      filePath.value = route.filePath;
    }

    lastOdometer.value = isAdmin
        ? appService.vehicleModel.value.lastOdometer
        : appService.driverVehicleModel.value.lastOdometer;
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
    notesController.dispose();
    super.onClose();
  }

  void selectDate({required bool isStartDate}) async {
    final context = Get.context;
    if (context == null) return;

    final DateTime initialDate = isStartDate
        ? model.value.startDate
        : model.value.endDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
      initialTime: TimeOfDay.now(), // Simplified
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

  Future<void> updateRoute() async {
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
        debugPrint("Last Date is bigger");
        showConfilctingCard.value = true;
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

      final newRouteMap = {
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
        "driver_name": driverController.text.trim(),
        "reason": reasonController.text.trim(),
        "file_path": filePath.value,
        "notes": notesController.text.trim(),
        "driver_id": isAdmin
            ? (oldRouteMap["driver_id"] ?? "")
            : appService.appUser.value.id,
      };

      final cc = int.tryParse(finalOdometerController.text.trim());
      if (cc == null) {
        return;
      }
      model.value.finalOdometer = cc;

      try {
        final adminId = isAdmin
            ? appService.appUser.value.id
            : appService.appUser.value.adminId;

        final vehicleId = isAdmin
            ? appService.currentVehicleId.value
            : appService.driverCurrentVehicleId.value;

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(adminId)
            .collection(DatabaseTables.VEHICLES)
            .doc(vehicleId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(vehicleRef, {
            'route_list': FieldValue.arrayRemove([oldRouteMap]),
          });

          transaction.update(vehicleRef, {
            'route_list': FieldValue.arrayUnion([newRouteMap]),
          });

          if (model.value.finalOdometer >= lastOdometer.value) {
            transaction.update(vehicleRef, {
              "last_odometer": model.value.finalOdometer,
            });
          }
        });

        if (Get.isDialogOpen == true) Get.back();
        Get.back();
        Utils.showSnackBar(message: "route_updated".tr, success: true);
      } on FirebaseException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        debugPrint("Error updating route: $e");
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
