import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:get/get.dart';

class ImportDataController extends GetxController {
  late AppService appService;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  void navigateToRootView() {
    appService.setImportData(value: true);
    Get.offAllNamed(AppRoutes.ROOT_VIEW);
  }
}
