import 'package:drivvo/modules/authentication/import-data/import_data_controller.dart';
import 'package:get/get.dart';


class ImportDataBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportDataController>(() => ImportDataController());
  }
}
