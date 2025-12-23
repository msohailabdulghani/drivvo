import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:get/get.dart';

class PlanController extends GetxController {
  late AppService appService;

  var isYearlyBilling = false.obs;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  void toggleBilling(bool value) {
    isYearlyBilling.value = value;
  }
}
