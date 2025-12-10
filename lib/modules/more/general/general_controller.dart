import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralController extends GetxController {
  late AppService appService;
  var isLoading = false.obs;
  var title = "";

  var generalFilterList = <GeneralModel>[].obs;
  List<GeneralModel> generalList = [];
  final searchInputController = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    title = Get.arguments ?? "";
    super.onInit();

    searchInputController.addListener(() {
      onSearch(searchInputController.text);
    });

    loadDataByTitle();
  }

  void loadDataByTitle() {
    switch (title) {
      case Constants.EXPENSE_TYPES:
        fetchGeneralList(DatabaseTables.EXPENSE_TYPES);
        break;
      case Constants.INCOME_TYPES:
        fetchGeneralList(DatabaseTables.INCOME_TYPES);
        break;
      case Constants.SERVICE_TYPES:
        fetchGeneralList(DatabaseTables.SERVICE_TYPES);
        break;
      case Constants.PAYMENT_METHOD:
        fetchGeneralList(DatabaseTables.PAYMENT_METHOD);
        break;
      case Constants.REASONS:
        fetchGeneralList(DatabaseTables.REASONS);
        break;
      case Constants.FUEL:
        fetchGeneralList(DatabaseTables.FUEL);
        break;
      case Constants.GAS_STATIONS:
        fetchGeneralList(DatabaseTables.GAS_STATIONS);
        break;
      case Constants.PLACES:
        fetchGeneralList(DatabaseTables.PLACES);
        break;
    }
  }

  Future<void> fetchGeneralList(String collectionName) async {
    isLoading.value = true;
    generalList.clear();
    generalFilterList.clear();

    try {
      final snapshot = await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(collectionName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        generalList = snapshot.docs.map((doc) {
          return GeneralModel.fromJson(doc.data());
        }).toList();

        onSearch("");
      } else {
        debugPrint("No data found in $collectionName");
      }
    } catch (e) {
      debugPrint("Error fetching $collectionName: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItem(GeneralModel item) async {
    final collectionName = getCollectionName();

    Utils.showProgressDialog(Get.context!);

    try {
      await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(collectionName)
          .doc(item.id)
          .delete();

      Get.back();
      loadDataByTitle();

      Utils.showSnackBar(message: "deleted_successfully".tr, success: true);
    } catch (e) {
      Get.back();
      Utils.showSnackBar(message: "delete_failed".tr, success: false);
    }
  }

  String getCollectionName() {
    switch (title) {
      case Constants.EXPENSE_TYPES:
        return DatabaseTables.EXPENSE_TYPES;
      case Constants.INCOME_TYPES:
        return DatabaseTables.INCOME_TYPES;
      case Constants.SERVICE_TYPES:
        return DatabaseTables.SERVICE_TYPES;
      case Constants.PAYMENT_METHOD:
        return DatabaseTables.PAYMENT_METHOD;
      case Constants.REASONS:
        return DatabaseTables.REASONS;
      case Constants.FUEL:
        return DatabaseTables.FUEL;
      case Constants.GAS_STATIONS:
        return DatabaseTables.GAS_STATIONS;
      case Constants.PLACES:
        return DatabaseTables.PLACES;
      default:
        return "";
    }
  }

  void onSearch(String text) {
    generalFilterList.value = generalList
        .where((e) => e.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
  }
}
