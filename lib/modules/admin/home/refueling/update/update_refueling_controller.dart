import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/last_record_model.dart';
import 'package:drivvo/model/refueling/refueling_model.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/modules/admin/reports/reports_controller.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateRefuelingController extends GetxController {
  String? _lastManualEdit;
  String? _secondLastManualEdit;
  final formKey = GlobalKey<FormState>();

  late AppService appService;

  var filePath = "".obs;
  var isFullTank = false.obs;
  var model = RefuelingModel().obs;
  var moreOptionsExpanded = false.obs;
  var missedPreviousRefueling = false.obs;

  var lastOdometer = 0.obs;

  var showConflictingCard = false.obs;
  late LastRecordModel lastRecord;
  late Map<String, dynamic> oldRefuelingMap;

  var isFirstTime = true;
  var fuelValue = "".obs;

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();
  final fuelController = TextEditingController();
  final litersController = TextEditingController();
  final totalCostController = TextEditingController();
  final gasStationCostController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final reasonController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    if (Get.arguments != null && Get.arguments is Map) {
      final RefuelingModel refueling = Get.arguments['refueling'];
      model.value = refueling;
      oldRefuelingMap = refueling.rawMap;

      // Initialize with existing data
      dateController.text = Utils.formatDate(date: refueling.date);
      timeController.text = refueling.time;
      priceController.text = refueling.price.toString();
      fuelController.text = refueling.fuelType;
      litersController.text = refueling.liter.toString();
      totalCostController.text = refueling.totalCost.toString();
      gasStationCostController.text = refueling.fuelStation.toString();
      isFullTank.value = refueling.fullTank;
      missedPreviousRefueling.value = refueling.missedPrevious;
      fuelValue.value = refueling.fuelType;
    }

    lastOdometer.value = appService.vehicleModel.value.lastOdometer;
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    priceController.dispose();
    totalCostController.dispose();
    litersController.dispose();
    fuelController.dispose();
    paymentMethodController.dispose();
    super.onClose();
  }

  void updateManualEdit(String field) {
    if (_lastManualEdit != field) {
      _secondLastManualEdit = _lastManualEdit;
      _lastManualEdit = field;
    }
  }

  void onPriceChanged(String? value) {
    if (value == null || value.isEmpty) {
      model.value.price = 0;
      return;
    }
    final price = int.tryParse(value.replaceAll(',', ''));
    if (price == null) return;

    model.value.price = price;
    updateManualEdit('price');
    if (isFirstTime) {
      _secondLastManualEdit = "liter";
      isFirstTime = false;
    }
    calculateThirdValue();
  }

  void onTotalCostChanged(String? value) {
    if (value == null || value.isEmpty) {
      model.value.totalCost = 0;
      return;
    }
    final sanitized = value.replaceAll(',', '');
    final totalCost = double.tryParse(sanitized);
    if (totalCost == null) return;

    model.value.totalCost = totalCost.toInt();
    updateManualEdit('totalCost');
    if (isFirstTime) {
      _secondLastManualEdit = "price";
      isFirstTime = false;
    }
    calculateThirdValue();
  }

  void onLitersChanged(String? value) {
    if (value == null || value.isEmpty) {
      model.value.liter = 0;
      return;
    }
    final liter = double.tryParse(value.replaceAll(',', ''));
    if (liter == null) return;

    model.value.liter = liter.toInt();
    updateManualEdit('liter');
    if (isFirstTime) {
      _secondLastManualEdit = "price";
      isFirstTime = false;
    }
    calculateThirdValue();
  }

  void calculateThirdValue() {
    double price =
        double.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    double totalCost =
        double.tryParse(totalCostController.text.replaceAll(',', '')) ?? 0;
    double liter =
        double.tryParse(litersController.text.replaceAll(',', '')) ?? 0;

    if ((_lastManualEdit == 'liter' && _secondLastManualEdit == 'price') ||
        (_lastManualEdit == 'price' && _secondLastManualEdit == 'liter')) {
      if (price > 0 && liter > 0) {
        final calc = price * liter;
        totalCostController.text = calc.toStringAsFixed(2);
        model.value.totalCost = calc.toInt();
      }
    } else if ((_lastManualEdit == 'price' &&
            _secondLastManualEdit == 'totalCost') ||
        (_lastManualEdit == 'totalCost' && _secondLastManualEdit == 'price')) {
      if (price > 0 && totalCost > 0) {
        final calc = totalCost / price;
        litersController.text = calc.toStringAsFixed(2);
        model.value.liter = calc.toInt();
      }
    } else if ((_lastManualEdit == 'liter' &&
            _secondLastManualEdit == 'totalCost') ||
        (_lastManualEdit == 'totalCost' && _secondLastManualEdit == 'liter')) {
      if (liter > 0 && totalCost > 0) {
        final calc = totalCost / liter;
        priceController.text = calc.toStringAsFixed(2);
        model.value.price = calc.toInt();
      }
    }
  }

  void toggleMoreOptions() {
    moreOptionsExpanded.value = !moreOptionsExpanded.value;
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

  Future<void> updateRefueling() async {
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
        debugPrint("Model date is before last date");
        showConflictingCard.value = true;
        return;
      }

      Utils.showProgressDialog();

      double liter = double.parse(litersController.text);
      double price = double.parse(priceController.text);
      double totalCost = double.parse(totalCostController.text);

      final newRefuelingMap = {
        "user_id": appService.appUser.value.id,
        "vehicle_id": appService.currentVehicleId.value,
        "time": timeController.text.trim(),
        "date": model.value.date,
        "odometer": model.value.odometer,
        "price": price.toInt(),
        "liter": liter.toInt(),
        "total_cost": totalCost.toInt(),
        "fuel_type": fuelController.text.trim(),
        "fuel_station": gasStationCostController.text.trim(),
        "full_tank": isFullTank.value,
        "missed_previous": missedPreviousRefueling.value,
        "payment_method": paymentMethodController.text.trim(),
        "notes": model.value.notes,
        "driver_name": model.value.driverName,
      };

      try {
        final batch = FirebaseFirestore.instance.batch();

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.VEHICLES)
            .doc(appService.currentVehicleId.value);

        batch.set(vehicleRef, {
          'refueling_list': FieldValue.arrayRemove([oldRefuelingMap]),
        }, SetOptions(merge: true));

        batch.set(vehicleRef, {
          'refueling_list': FieldValue.arrayUnion([newRefuelingMap]),
        }, SetOptions(merge: true));

        if (model.value.odometer >= lastOdometer.value) {
          batch.update(vehicleRef, {"last_odometer": model.value.odometer});
        }

        await batch.commit();

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadTimelineData();
        }

        if (Get.isRegistered<ReportsController>()) {
          Get.find<ReportsController>().calculateAllReports();
        }

        if (Get.isDialogOpen == true) Get.back();
        Get.back();

        Utils.showSnackBar(message: "refueling_updated".tr, success: true);
      } on FirebaseException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }
}
