import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGeneralController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();

  var title = "";
  var name = "";

  final List<String> fuelTypeList = [
    'Liquids',
    'Liquefied petroleum gas',
    'Compressed natural gas',
    'Electrical',
  ];

  var fuelType = "";

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    title = Get.arguments ?? "";
    super.onInit();
  }

  Future<void> saveData() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();

      String? collectionPath;
      String? successMessage;

      switch (title) {
        case Constants.EXPENSE_TYPES:
          collectionPath = DatabaseTables.EXPENSE_TYPES;
          successMessage = "expense_type_added".tr;
          break;
        case Constants.INCOME_TYPES:
          collectionPath = DatabaseTables.INCOME_TYPES;
          successMessage = "income_type_added".tr;
          break;
        case Constants.SERVICE_TYPES:
          collectionPath = DatabaseTables.SERVICE_TYPES;
          successMessage = "service_type_added".tr;
          break;
        case Constants.PAYMENT_METHOD:
          collectionPath = DatabaseTables.PAYMENT_METHOD;
          successMessage = "payment_method_added".tr;
          break;
        case Constants.REASONS:
          collectionPath = DatabaseTables.REASONS;
          successMessage = "reason_added".tr;
          break;
        case Constants.FUEL:
          collectionPath = DatabaseTables.FUEL;
          successMessage = "fuel_added".tr;
          break;
        case Constants.GAS_STATIONS:
          collectionPath = DatabaseTables.GAS_STATIONS;
          successMessage = "gas_station_added".tr;
          break;
        case Constants.PLACES:
          collectionPath = DatabaseTables.PLACES;
          successMessage = "place_added".tr;
          break;
        default:
          debugPrint("Unknown title: $title");
          return;
      }

      // 2. Call the generic save function
      if (collectionPath.isNotEmpty && successMessage.isNotEmpty) {
        Utils.showProgressDialog(Get.context!);

        try {
          final ref = FirebaseFirestore.instance
              .collection(DatabaseTables.USER_PROFILE)
              .doc(appService.appUser.value.id)
              .collection(collectionPath);

          //final ref = FirebaseFirestore.instance.collection(collectionPath);

          final id = ref.doc().id;
          final map = {"id": id, "name": name};

          if (title == Constants.FUEL) {
            map["fuel_type"] = fuelType;
          }

          if (title == Constants.GAS_STATIONS || title == Constants.PLACES) {
            map["location"] = locationController.text.trim();
          }

          await ref.doc(id).set(map);

          if (Get.isDialogOpen == true) Get.back();
          Get.back();

          Utils.showSnackBar(message: successMessage, success: true);
        } catch (e) {
          debugPrint("Error adding to $collectionPath: $e");
          if (Get.isDialogOpen == true) Get.back();

          Utils.showSnackBar(message: "something_wrong".tr, success: false);
        }
      }
    }
  }

  void onSelectFuelType(String? type) {
    if (type != null) {
      fuelType = type;
    }
  }
}
