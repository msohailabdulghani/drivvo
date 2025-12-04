import 'package:drivvo/services/app_service.dart';
import 'package:get/get.dart';

class ViewPhotoController extends GetxController {
  String url = "";
  final appService = Get.find<AppService>();

  @override
  void onInit() {
    final result = Get.arguments;
    url = result["url"];
    super.onInit();
  }
}
