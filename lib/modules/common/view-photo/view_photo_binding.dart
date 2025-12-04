import 'package:drivvo/modules/common/view-photo/view_photo_controller.dart';
import 'package:get/get.dart';

class ViewPhotoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewPhotoController>(() => ViewPhotoController());
  }
}
