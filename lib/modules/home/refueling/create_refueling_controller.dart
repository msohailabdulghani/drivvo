import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateRefuelingController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final odometerController = TextEditingController();
  final priceController = TextEditingController();
  final totalCostController = TextEditingController();
  final gallonsController = TextEditingController();
  final driverController = TextEditingController();
  final notesController = TextEditingController();

  // Date & Time
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;

  // Switch states
  var isFillingTank = true.obs;
  var missedPreviousRefueling = false.obs;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    super.onInit();
    // Initialize with current date and time
    final now = DateTime.now();
    selectedDate.value = DateFormat('yyyy-MM-dd').format(now);
    selectedTime.value = DateFormat('HH:mm').format(now);
  }

  @override
  void onClose() {
    odometerController.dispose();
    priceController.dispose();
    totalCostController.dispose();
    gallonsController.dispose();
    driverController.dispose();
    notesController.dispose();
    super.onClose();
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
      selectedDate.value = DateFormat('yyyy-MM-dd').format(picked);
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
      selectedTime.value = DateFormat('HH:mm').format(dt);
    }
  }

  void saveRefueling() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.back();
    }
  }
}
