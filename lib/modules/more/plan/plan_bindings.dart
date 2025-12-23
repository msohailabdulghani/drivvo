import 'package:drivvo/modules/more/plan/plan_controller.dart';
import 'package:get/get.dart';

class PlanBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanController>(() => PlanController());
  }
}
