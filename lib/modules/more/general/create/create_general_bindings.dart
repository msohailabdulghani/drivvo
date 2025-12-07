import 'package:drivvo/modules/more/general/create/create_general_controller.dart';
import 'package:get/get.dart';

class CreateGeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateGeneralController>(() => CreateGeneralController());
  }
}
