import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreController extends GetxController {
  late AppService appService;
  var currentLanguage = "english".obs;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  var registeredVehicles = 0.obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    getAllVehicleList();

    // Load saved language
    final savedLanguageCode = appService.savedLanguage;
    if (savedLanguageCode == 'ur') {
      currentLanguage.value = "urdu";
    } else {
      currentLanguage.value = "english";
    }
  }

  Future<void> getAllVehicleList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.VEHICLES)
          .get();

      if (snapshot.docs.isNotEmpty) {
        registeredVehicles.value = snapshot.docs.length;
      }
    } catch (e) {
      // Log error or set default value
      registeredVehicles.value = 0;
    }
  }

  void showLanguageDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "select_language".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Get.locale?.languageCode ==
                          Constants.DEFAULT_LANGUAGE_CODE
                      ? 16
                      : 18,
                  fontFamily:
                      Get.locale?.languageCode ==
                          Constants.DEFAULT_LANGUAGE_CODE
                      ? "D-FONT-R"
                      : "U-FONT-R",
                ),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption(
                languageName: "english",
                languageCode: "en",
                country: "US",
                isSelected: currentLanguage.value == "english",
              ),
              const SizedBox(height: 10),
              _buildLanguageOption(
                languageName: "urdu",
                languageCode: "ur",
                country: "PK",
                isSelected: currentLanguage.value == "urdu",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "cancel".tr,
                      style: Utils.getTextStyle(
                        baseSize: 16,
                        isBold: false,
                        color: Colors.grey,
                        isUrdu: isUrdu,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageName,
    required String languageCode,
    required String country,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        changeLanguage(languageCode: languageCode, country: country);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00796B).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00796B)
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                languageName.tr,
                style: Utils.getTextStyle(
                  baseSize: 16,
                  isBold: true,
                  color: isSelected ? const Color(0xFF00796B) : Colors.black,
                  isUrdu: isUrdu,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF00796B),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void changeLanguage({required String languageCode, required String country}) {
    final locale = Locale(languageCode);
    Get.updateLocale(locale);

    // Update current language name
    if (languageCode == 'ur') {
      currentLanguage.value = "urdu";
    } else {
      currentLanguage.value = "english";
    }

    appService.changeLanguage(languageCode, country);
  }
}
