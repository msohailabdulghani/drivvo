import 'package:drivvo/model/refueling_model.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateRefuelingController extends GetxController {
  String? _lastEditedField;
  final formKey = GlobalKey<FormState>();

  var filePath = "".obs;
  var isFillingTank = false.obs;
  var model = RefuelingModel().obs;
  var moreOptionsExpanded = false.obs;
  var missedPreviousRefueling = false.obs;

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
    super.onInit();
    final now = DateTime.now();
    dateController.text = Utils.formatDate(date: now);
    timeController.text = DateFormat('hh:mm a').format(now);
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

  // Called when user changes price value
  void onPriceChanged(String? value) {
    if (value == null || value.isEmpty) return;
    final price = double.tryParse(value);
    if (price == null) return;

    model.value.price = price;
    _lastEditedField = 'price';
    calculateThirdValue();
  }

  // Called when user changes total cost value
  void onTotalCostChanged(String? value) {
    if (value == null || value.isEmpty) return;
    final totalCost = double.tryParse(value);
    if (totalCost == null) return;

    model.value.totalCost = totalCost;
    _lastEditedField = 'totalCost';
    calculateThirdValue();
  }

  // Called when user changes liters value
  void onLitersChanged(String? value) {
    if (value == null || value.isEmpty) return;
    final liter = double.tryParse(value);
    if (liter == null) return;

    model.value.liter = liter;
    _lastEditedField = 'liter';
    calculateThirdValue();
  }

  // Calculate the third value based on which two values are filled
  void calculateThirdValue() {
    final price = model.value.price;
    final totalCost = model.value.totalCost;
    final liter = model.value.liter;

    // Formula: totalCost = price * liter
    // If price and totalCost are entered, calculate liters
    if (_lastEditedField != 'liter' && price > 0 && totalCost > 0) {
      final calculatedLiter = totalCost / price;
      model.value.liter = calculatedLiter;
      litersController.text = calculatedLiter.toStringAsFixed(2);
    }
    // If price and liters are entered, calculate totalCost
    else if (_lastEditedField != 'totalCost' && price > 0 && liter > 0) {
      final calculatedTotalCost = price * liter;
      model.value.totalCost = calculatedTotalCost;
      totalCostController.text = calculatedTotalCost.toStringAsFixed(2);

      final currencyFormat = NumberFormat.currency(symbol: '');
      totalCostController.text = currencyFormat.format(calculatedTotalCost);
    }
    // If totalCost and liters are entered, calculate price
    else if (_lastEditedField != 'price' && totalCost > 0 && liter > 0) {
      final calculatedPrice = totalCost / liter;
      model.value.price = calculatedPrice;
      priceController.text = calculatedPrice.toStringAsFixed(2);
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
      model.value.date = date;
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

  Future<void> onPickedFile(XFile? pickedFile) async {
    if (pickedFile != null) {
      try {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Utils.appColor,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
              aspectRatioPresets: [CropAspectRatioPreset.square],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset
                    .square, // IMPORTANT: iOS supports only one custom aspect ratio in preset list
              ],
            ),
          ],
        );
        if (croppedFile != null) {
          filePath.value = croppedFile.path;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void saveRefueling() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.back();
    }
  }
}
