import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverVehiclesController extends GetxController {
  late AppService appService;
  var isLoading = false.obs;

  List<VehicleModel> vehicleList = [];
  var filterVehiclesList = <VehicleModel>[].obs;
  final searchInputController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    searchInputController.addListener(() {
      onSearchVehicle(searchInputController.text);
    });
    getVehicleList();
  }

  Future<void> getBackToHome({required VehicleModel vehicle}) async {
    await appService.setDriverCurrentVehicle(vehicle.name);
    await appService.setDriverCurrentVehicleId(vehicle.id);

    await appService.getDriverCurrentVehicle();
    if (Get.isRegistered<DriverHomeController>()) {
      await Get.find<DriverHomeController>().loadTimelineData();
    }
    Get.back();
  }

  Future<void> getVehicleList() async {
    isLoading.value = true;
    vehicleList.clear();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.adminId)
          .collection(DatabaseTables.VEHICLES)
          .where("driver_id", isEqualTo: appService.appUser.value.id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        vehicleList.addAll(
          snapshot.docs
              .map((doc) => VehicleModel.fromJson(doc.data()))
              .toList(),
        );
      }
      onSearchVehicle("");
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  void onSearchVehicle(String text) {
    filterVehiclesList.value = vehicleList
        .where(
          (e) =>
              e.name.toLowerCase().contains(text.toLowerCase()) || text.isEmpty,
        )
        .toList();
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
  }
}
