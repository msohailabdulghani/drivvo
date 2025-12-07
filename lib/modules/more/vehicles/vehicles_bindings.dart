import 'package:drivvo/modules/more/vehicles/vehicles_controller.dart';
import 'package:get/get.dart';

class VehiclesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehiclesController>(() => VehiclesController());
  }
}
