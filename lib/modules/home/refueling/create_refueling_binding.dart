import 'package:drivvo/modules/home/refueling/create_refueling_controller.dart';
import 'package:get/get.dart';

class CreateRefuelingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateRefuelingController>(() => CreateRefuelingController());
  }
}
