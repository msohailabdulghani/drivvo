import 'package:drivvo/modules/driver/vehicle/driver_vehicles_controller.dart';
import 'package:get/get.dart';

class DriverVehiclesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverVehiclesController>(() => DriverVehiclesController());
  }
}
