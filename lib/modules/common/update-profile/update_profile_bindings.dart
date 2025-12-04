import 'package:drivvo/modules/common/update-profile/update_profile_controller.dart';
import 'package:get/get.dart';

class UpdateProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateProfileController>(() => UpdateProfileController());
  }
}
