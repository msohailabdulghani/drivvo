import 'package:drivvo/utils/constants.dart';
import 'package:get/get.dart';

class DateRangeController extends GetxController {
  late DateTime startDate, endDate;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    final result = Get.arguments;
    // startDate = result['startDate'];
    // endDate = result['endDate'];
    if (result != null && result is Map) {
      startDate = result['startDate'] ?? DateTime.now();
      endDate = result['endDate'] ?? DateTime.now();
    } else {
      startDate = DateTime.now();
      endDate = DateTime.now();
    }
    super.onInit();
  }
}
