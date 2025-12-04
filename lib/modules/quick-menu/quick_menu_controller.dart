import 'package:drivvo/services/app_service.dart';
import 'package:get/get.dart';

class QuickMenuController extends GetxController {
  late AppService appService;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }
}
