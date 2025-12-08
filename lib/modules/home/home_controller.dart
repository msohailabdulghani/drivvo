import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late AppService appService;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  var isFabExpanded = false.obs;

  void toggleFab() {
    isFabExpanded.value = !isFabExpanded.value;
  }
}
