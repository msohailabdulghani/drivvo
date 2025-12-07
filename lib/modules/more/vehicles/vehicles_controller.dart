import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/vehicle_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehiclesController extends GetxController {
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

  Future<void> getVehicleList() async {
    isLoading.value = true;
    vehicleList.clear();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.VEHICLES)
          .get();

      if (snapshot.docs.isNotEmpty) {
        vehicleList.addAll(
          snapshot.docs
              .map((doc) => VehicleModel.fromJson(doc.data()))
              .toList(),
        );
        onSearchVehicle("");
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
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
