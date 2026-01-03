import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/vehicle/user_vehicle_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserVehicleController extends GetxController {
  late AppService appService;
  var isLoading = false.obs;

  List<UserVehicleModel> vehicleList = [];
  var filterVehiclesList = <UserVehicleModel>[].obs;
  final searchInputController = TextEditingController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  StreamSubscription? _subscription;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    searchInputController.addListener(() {
      onSearchVehicle(searchInputController.text);
    });

    getVehicleList();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    searchInputController.dispose();
    super.onClose();
  }

  Future<void> getVehicleList() async {
    _subscription?.cancel();
    isLoading.value = true;

    vehicleList.clear();
    filterVehiclesList.clear();

    try {
      _subscription = FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.USER_VEHICLE)
          .snapshots()
          .listen((docSnapshot) {
            if (docSnapshot.docs.isNotEmpty) {
              vehicleList.clear();
              filterVehiclesList.clear();
              vehicleList.addAll(
                docSnapshot.docs
                    .map((doc) => UserVehicleModel.fromJson(doc.data()))
                    .toList(),
              );
              onSearchVehicle("");
            }
          });
    } catch (e) {
      Utils.showSnackBar(message: "something_went_wrong".tr, success: false);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchVehicle(String text) {
    filterVehiclesList.value = vehicleList
        .where(
          (e) =>
              e.vehicle.name.toLowerCase().contains(text.toLowerCase()) ||
              e.vehicle.manufacturer.toLowerCase().contains(
                text.toLowerCase(),
              ) ||
              text.isEmpty,
        )
        .toList();
  }
}
