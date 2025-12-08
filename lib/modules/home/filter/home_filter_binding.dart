import 'package:drivvo/modules/home/filter/home_filter_controller.dart';
import 'package:get/get.dart';

class HomeFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
