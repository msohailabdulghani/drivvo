import 'package:drivvo/services/app_service.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  late AppService appService;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }
}
