import 'package:drivvo/modules/reminder/create/create_reminder_controller.dart';
import 'package:get/get.dart';

class CreateReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateReminderController>(() => CreateReminderController());
  }
}
