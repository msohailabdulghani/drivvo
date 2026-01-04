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

class CreateRefuelingController extends GetxController {
  String? _lastManualEdit;
  String? _secondLastManualEdit;
  final formKey = GlobalKey<FormState>();

  late AppService appService;

  var filePath = "".obs;
  var isFullTank = false.obs;
  var model = RefuelingModel().obs;
  var moreOptionsExpanded = false.obs;
  var missedPreviousRefueling = false.obs;

  var showConflictingCard = false.obs;
  late LastRecordModel lastRecord;

  var lastOdometer = 0.obs;

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();
  final fuelController = TextEditingController();
  final litersController = TextEditingController();
  final totalCostController = TextEditingController();
  final gasStationCostController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final reasonController = TextEditingController();

  var fuelValue = "".obs;
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

    fuelController.text = "select_fuel".tr;
    gasStationCostController.text = "select_gas_station".tr;
    paymentMethodController.text = "select_payment_method".tr;
    reasonController.text = "select_reason".tr;

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
    gasStationCostController.dispose();
    paymentMethodController.dispose();
    reasonController.dispose();
    super.onClose();
  }

  void updateManualEdit(String field) {
    if (_lastManualEdit != field) {
      _secondLastManualEdit = _lastManualEdit;
      _lastManualEdit = field;
    }
  }

  // Called when user changes price value
  void onPriceChanged(String? value) {
    if (value == null || value.isEmpty) {
      model.value.price = 0;
      return;
    }
    final price = int.tryParse(value.replaceAll(',', ''));
    if (price == null) return;

    model.value.price = int.parse(value);
    updateManualEdit('price');
    calculateThirdValue();
  }

  // Called when user changes total cost value
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
    calculateThirdValue();
  }

  // Called when user changes liters value
  void onLitersChanged(String? value) {
    if (value == null || value.isEmpty) {
      model.value.liter = 0;
      return;
    }
    final liter = double.tryParse(value.replaceAll(',', ''));
    if (liter == null) return;

    model.value.liter = int.parse(value);
    updateManualEdit('liter');
    calculateThirdValue();
  }

  void calculateThirdValue() {
    int price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    int totalCost =
        int.tryParse(totalCostController.text.replaceAll(',', '')) ?? 0;
    int liter = int.tryParse(litersController.text.replaceAll(',', '')) ?? 0;

    // Formula: totalCost = price * liter

    if ((_lastManualEdit == 'liter' && _secondLastManualEdit == 'price') ||
        (_lastManualEdit == 'price' && _secondLastManualEdit == 'liter')) {
      // Calculate Total Cost
      if (price > 0 && liter > 0) {
        final calc = price * liter;
        totalCostController.text = calc.toStringAsFixed(2);
        model.value.totalCost = calc;
      }
    } else if ((_lastManualEdit == 'price' &&
            _secondLastManualEdit == 'totalCost') ||
        (_lastManualEdit == 'totalCost' && _secondLastManualEdit == 'price')) {
      // Calculate Liter
      if (price > 0 && totalCost > 0) {
        final calc = totalCost / price;
        litersController.text = calc.toStringAsFixed(2);
        model.value.liter = calc.toInt();
      }
    } else if ((_lastManualEdit == 'liter' &&
            _secondLastManualEdit == 'totalCost') ||
        (_lastManualEdit == 'totalCost' && _secondLastManualEdit == 'liter')) {
      // Calculate Price
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

  void onSelectFuelType(String? type) {
    if (type != null) {
      model.value.fuelType = type;
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

  Future<void> saveRefueling() async {
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

      double liter = double.parse(litersController.text);
      double price = double.parse(priceController.text);
      double totalCost = double.parse(totalCostController.text);

      final map = {
        "id": appService.appUser.value.id,
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

      final lastRecordMap = {
        "type": "refueling",
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
          'refueling_list': FieldValue.arrayUnion([map]),
          "last_odometer": model.value.odometer,
        }, SetOptions(merge: true));

        batch.update(userRef, {"last_record": lastRecordMap});

        await batch.commit();

        if (Get.isDialogOpen == true) Get.back();
        Get.back();

        Utils.showSnackBar(message: "refueling_added".tr, success: true);

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
