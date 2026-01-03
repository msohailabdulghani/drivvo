import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
import 'package:drivvo/modules/driver/more/driver_more_controller.dart';
import 'package:drivvo/modules/driver/root/driver_root_controller.dart';
import 'package:get/get.dart';

class DriverRootBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverRootController>(() => DriverRootController());
    Get.lazyPut<DriverHomeController>(() => DriverHomeController());
    Get.lazyPut<DriverMoreController>(() => DriverMoreController());
  }
}
