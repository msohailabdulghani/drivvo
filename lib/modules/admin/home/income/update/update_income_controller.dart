import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/income/income_model.dart';
import 'package:drivvo/model/last_record_model.dart';
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
  final driverController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;
  bool get isAdmin => appService.appUser.value.userType == Constants.ADMIN;

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

      driverController.text = income.driver.firstName.isNotEmpty
          ? '${income.driver.firstName} ${income.driver.lastName}'
          : "";
    }

    lastOdometer.value = isAdmin
        ? appService.vehicleModel.value.lastOdometer
        : appService.driverVehicleModel.value.lastOdometer;
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    incomeTypeController.dispose();
    driverController.dispose();
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

      final newIncomeMap = {
        "user_id": appService.appUser.value.id,
        "vehicle_id": appService.currentVehicleId.value,
        "time": timeController.text.trim(),
        "date": model.value.date,
        "odometer": model.value.odometer,
        "income_type": incomeTypeController.text.trim(),
        "value": model.value.value,
        "file_path": filePath.value,
        "notes": model.value.notes,
        "driver_id": isAdmin
            ? (oldIncomeMap["driver_id"] ?? "")
            : appService.appUser.value.id,
        "driver": isAdmin
            ? model.value.driver.toJson()
            : appService.appUser.value.toJson(),
      };

      final lastRecordMap = {
        "type": "income",
        "date": model.value.date,
        "odometer": model.value.odometer >= lastOdometer.value
            ? model.value.odometer
            : lastOdometer.value,
      };

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

        final userRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(vehicleRef, {
            'income_list': FieldValue.arrayRemove([oldIncomeMap]),
          });

          transaction.update(vehicleRef, {
            'income_list': FieldValue.arrayUnion([newIncomeMap]),
          });

          if (model.value.odometer >= lastOdometer.value) {
            transaction.update(vehicleRef, {
              "last_odometer": model.value.odometer,
            });
          }

          transaction.set(userRef, {
            "last_record": lastRecordMap,
          }, SetOptions(merge: true));
        });

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
