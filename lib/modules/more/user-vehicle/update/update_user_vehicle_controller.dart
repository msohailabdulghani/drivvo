import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/vehicle/user_vehicle_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserVehicleController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final nameController = TextEditingController();
  final vehicleController = TextEditingController();

  var model = UserVehicleModel().obs;
  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    model.value = Get.arguments as UserVehicleModel;

    nameController.text =
        "${model.value.user.firstName} ${model.value.user.lastName}";
    vehicleController.text = model.value.vehicle.name;
  }

  @override
  void onClose() {
    nameController.dispose();
    vehicleController.dispose();
    super.onClose();
  }

  Future<void> saveData() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();

      Utils.showProgressDialog();

      try {
        final map = {
          "user": model.value.user.toJson(),
          "vehicle": model.value.vehicle.toJson(model.value.vehicle.id),
        };

        await FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.USER_VEHICLE)
            .doc(model.value.id)
            .update(map);

        Get.back(closeOverlays: true);
      } catch (e) {
        Get.back(closeOverlays: true);
        Utils.showSnackBar(message: 'something_went_wrong'.tr, success: false);
      }
    }
  }
}
