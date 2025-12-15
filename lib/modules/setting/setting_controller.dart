import 'dart:ui';

import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  late AppService appService;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  // Categories Section
  var selectedTheme = 'Use system default'.obs;
  var selectedLanguage = 'English (United States)'.obs;
  var selectedDateFormat = 'DD/MM/YY'.obs;
  var selectedCurrencyFormat = '\$1,000,200.00'.obs;
  var showThreeDecimalDigits = false.obs;
  var displayDecimalDigits = true.obs;

  // Units Section
  var selectedDistanceUnit = 'km'.obs;
  var selectedFuelUnit = 'Gallon US (Gal)'.obs;
  var selectedVolumeUnit = 'Liter (L)'.obs;
  var selectedFuelEfficiency = 'Mile/Gallon US'.obs;
  var showAverageLastRecords = false.obs;

  // Reminders Section
  var distanceInAdvance = 'Show reminder 300 km in advance.'.obs;
  var daysInAdvance = 'Show reminder 30 days in advance.'.obs;
  var bestTimeForNotifications = '10:30'.obs;
  var refuelingNotifications = true.obs;
  var tirePressureNotifications = true.obs;
  var gasStationNotifications = true.obs;
  var vibrateWhenNotifying = true.obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    _initializeLanguage();
    super.onInit();
  }

  void _initializeLanguage() {
    if (isUrdu) {
      selectedLanguage.value = 'اردو (پاکستان)';
    } else {
      selectedLanguage.value = 'English (United States)';
    }
  }

  void changeLanguage(String language) {
    if (language == 'اردو (پاکستان)') {
      Get.updateLocale(const Locale('ur', 'PK'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }
}
