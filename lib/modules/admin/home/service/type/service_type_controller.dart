import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/expense/expense_type_model.dart';
import 'package:drivvo/modules/admin/home/service/create/create_service_controller.dart';
import 'package:drivvo/modules/admin/home/service/update/update_service_controller.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceTypeController extends GetxController {
  late AppService appService;
  var isLoading = false.obs;

  var isChecked = false.obs;

  late List<ExpenseTypeModel> selectedList;
  bool isFromCreate = false;
  var filterList = <ExpenseTypeModel>[].obs;
  List<ExpenseTypeModel> generalList = [];
  final searchInputController = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    final result = Get.arguments;
    isFromCreate = result["isFromCreate"];
    selectedList = result["list"] as List<ExpenseTypeModel>;
    super.onInit();

    searchInputController.addListener(() {
      onSearch(searchInputController.text);
    });

    getExpeseTypes();
  }

  Future<void> getExpeseTypes() async {
    isLoading.value = true;
    generalList.clear();
    filterList.clear();

    try {
      final snapshot = await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.SERVICE_TYPES)
          .get();

      if (snapshot.docs.isNotEmpty) {
        generalList = snapshot.docs.map((doc) {
          return ExpenseTypeModel.fromJson(doc.data());
        }).toList();

        onSearch("");

        for (final item in filterList) {
          final matchedItem = selectedList.firstWhereOrNull(
            (e) => e.id == item.id,
          );

          if (matchedItem != null) {
            item.value.value = matchedItem.value.value;
            item.isChecked.value = true;
          }

          item.value.refresh();
        }
      }
    } catch (e) {
      debugPrint("Error fetching");
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String text) {
    filterList.value = generalList
        .where((e) => e.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void onTapBack() {
    final selectedList = filterList.where((e) => e.isChecked.value).toList();

    if (isFromCreate) {
      final controller = Get.find<CreateServiceController>();
      controller.serviceTyesList.value = selectedList;
      controller.calculateTotal();
    } else {
      final controller = Get.find<UpdateServiceController>();
      controller.serviceTyesList.value = selectedList;
      controller.calculateTotal();
    }

    Get.back();
  }

  @override
  void onClose() {
    for (var element in generalList) {
      element.focusNode.dispose();
    }
    searchInputController.dispose();
    super.onClose();
  }
}
