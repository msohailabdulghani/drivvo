import 'package:drivvo/modules/common/date-range/date_range_controller.dart';
import 'package:get/get.dart';

class DateRangeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DateRangeController>(() => DateRangeController());
  }
}
