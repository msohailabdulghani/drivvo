import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/modules/more/more_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateVehiclesController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final manufacturerController = TextEditingController();
  final searchInputController = TextEditingController();

  final manufacturerFilterList = <GeneralModel>[].obs;

  var selectedYear = 2020.obs;
  String manufacturerId = "";

  var isFromImportdata = false.obs;

  var model = VehicleModel();
  var selectedChipName = "Kilometers".obs;
  final List<String> vehicleTypesList = ['car', 'bike', 'truck', 'bus'];
  final List<String> fuelTypesList = ['Liquids', 'CNG', 'Electric'];
  final List<String> tankList = ['one_tank', 'two_tank'];

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
    isFromImportdata.value = Get.arguments as bool? ?? false;
    onSearchManufacturer("");

    searchInputController.addListener(() {
      onSearchManufacturer(searchInputController.text);
    });
  }

  Future<void> saveData() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();

      final ref = FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.VEHICLES);

      final id = ref.doc().id;

      Utils.showProgressDialog(Get.context!);
      final map = model.toJson(id);

      await ref
          .doc(id)
          .set(map)
          .then(
            (_) {
              if (isFromImportdata.value) {
                Get.offAllNamed(AppRoutes.ROOT_VIEW);
                return;
              }
              Get.back(closeOverlays: true);
              Utils.showSnackBar(
                message: "Vechile is added successfully",
                success: true,
              );

              final con = Get.find<MoreController>();
              con.getAllVehicleList();
            },
            onError: (e) {
              Get.back();
            },
          );
    }
  }

  void onSelectManufacturer(GeneralModel? value) {
    if (value != null) {
      manufacturerId = value.id;
      manufacturerController.text = value.name;
      model.manufacturer = value.name;
    }
  }

  void onSearchManufacturer(String text) {
    manufacturerFilterList.value = Utils.manufacturers
        .where(
          (e) =>
              e.name.toLowerCase().contains(text.toLowerCase()) || text.isEmpty,
        )
        .toList();
  }

  void onSelectVehicleType(String type) {
    model.vehicleType = type;
  }

  void onSelectModelyear(int year) {
    model.year = year;
  }

  void onSelectTank(String? tank) {
    if (tank != null) {
      model.tankConfiguration = tank;
    }
  }

  void onSelectFuelType(String? type) {
    if (type != null) {
      model.fuelType = type;
    }
  }

  @override
  void onClose() {
    manufacturerController.dispose();
    searchInputController.dispose();
    super.onClose();
  }
}
