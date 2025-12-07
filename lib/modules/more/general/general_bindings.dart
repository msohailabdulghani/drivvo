import 'package:drivvo/modules/more/general/general_controller.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneralController>(() => GeneralController());
  }
}
