import 'package:drivvo/modules/home/home_controller.dart';
import 'package:drivvo/modules/more/more_controller.dart';
import 'package:drivvo/modules/quick-menu/quick_menu_controller.dart';
import 'package:drivvo/modules/reminder/reminder_controller.dart';
import 'package:drivvo/modules/reports/reports_controller.dart';
import 'package:drivvo/modules/root/root_controller.dart';
import 'package:get/get.dart';

class RootBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ReportsController>(() => ReportsController());
    Get.lazyPut<QuickMenuController>(() => QuickMenuController());
    Get.lazyPut<ReminderController>(() => ReminderController());
    Get.lazyPut<MoreController>(() => MoreController());
  }
}
