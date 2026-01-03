import 'package:drivvo/modules/more/user-vehicle/update/update_user_vehicle_controller.dart';
import 'package:get/get.dart';

class UpdateUserVehicleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateUserVehicleController>(
      () => UpdateUserVehicleController(),
    );
  }
}
