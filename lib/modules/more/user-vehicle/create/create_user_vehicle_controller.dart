import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserVehicleController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final nameController = TextEditingController();
  final vehicleController = TextEditingController();

  var user = AppUser().obs;
  var vehicle = VehicleModel().obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    nameController.text = "select_user".tr;
    vehicleController.text = "select_vehicle".tr;
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
        if (user.value.id.isEmpty) {
          Utils.showSnackBar(message: 'please_select_user'.tr, success: false);
          return;
        }
        if (vehicle.value.id.isEmpty) {
          Utils.showSnackBar(
            message: 'please_select_vehicle'.tr,
            success: false,
          );
          return;
        }

        final ref = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id)
            .collection(DatabaseTables.USER_VEHICLE);

        final id = ref.doc().id;

        final map = {
          "id": id,
          "start_date": DateTime.now(),
          "user": user.value.toJson(),
          "vehicle": vehicle.value.toJson(vehicle.value.id),
        };

        final batch = FirebaseFirestore.instance.batch();

        batch.set(ref.doc(id), map);
        batch.update(
          FirebaseFirestore.instance
              .collection(DatabaseTables.USER_PROFILE)
              .doc(appService.appUser.value.id)
              .collection(DatabaseTables.VEHICLES)
              .doc(vehicle.value.id),
          {"assign_user_id": appService.appUser.value.id},
        );

        await batch.commit();
        Get.back(closeOverlays: true);
        Utils.showSnackBar(
          message: 'vehicle_assigned_to_user'.tr,
          success: true,
        );
      } catch (e) {
        Get.back();
        Utils.showSnackBar(message: 'something_went_wrong'.tr, success: false);
      }
    }
  }
}
