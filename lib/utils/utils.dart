import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
  static TextStyle getTextStyle({
    required double baseSize,
    required bool isBold,
    required Color color,
    required bool isUrdu,
  }) {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
      fontSize: isUrdu ? baseSize + 2 : baseSize,
      fontFamily: isUrdu ? "U-FONT-R" : "D-FONT-R",
    );
  }

  static SnackbarController showSnackBar({
    required String message,
    required bool success,
  }) {
    return Get.snackbar(
      "",
      "",
      backgroundColor: success
          ? Colors.green.withValues(alpha: 0.6)
          : Colors.red.withValues(alpha: 0.6),

      icon: const Icon(Icons.info),

      // Remove default text
      titleText: Text(
        success ? "success".tr : "failed".tr,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
              ? 16
              : 18,
          fontFamily:
              Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
              ? "D-FONT-R"
              : "U-FONT-R",
          color: Colors.black,
        ),
      ),

      messageText: Text(
        message.tr,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
              ? 14
              : 16,
          fontStyle: FontStyle.normal,
          fontFamily:
              Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
              ? "D-FONT-R"
              : "U-FONT-R",
          color: Colors.black,
        ),
      ),
    );
  }

  static void showProgressDialog(BuildContext context) {
    Get.dialog(
      Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.isDarkMode ? const Color(0xFF39374C) : Colors.white,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: Text("D"),
                  // Image.asset(
                  //   "assets/images/main_logo.png",
                  //   width: 40,
                  //   height: 40,
                  // ),
                ),
                const SizedBox(
                  height: 52,
                  width: 52,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0XffFB5C7C),
                    ),
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static String formatDate({dynamic date}) {
    if (date == null) {
      return "--";
    }
    return DateFormat("dd MMM yyyy").format(date);
  }

  static String formatMonthday({dynamic date}) {
    if (date == null) {
      return "--";
    }
    return DateFormat("MMM dd").format(date);
  }

  static String formatMonthYear({dynamic date, bool fullMonth = false}) {
    if (date == null) {
      return "--";
    }
    if (fullMonth) {
      return DateFormat("MMMM yyyy").format(date);
    }
    return DateFormat("MMM yyyy").format(date);
  }

  static final years = List.generate(
    20,
    (index) => DateTime.now().year - index,
  );

  static final List<GeneralModel> manufacturers = [
    GeneralModel(id: 1, name: "Toyota"),
    GeneralModel(id: 2, name: "Volkswagen"),
    GeneralModel(id: 3, name: "Ford"),
    GeneralModel(id: 4, name: "Honda"),
    GeneralModel(id: 5, name: "Nissan"),
    GeneralModel(id: 6, name: "Hyundai"),
    GeneralModel(id: 7, name: "Kia"),
    GeneralModel(id: 8, name: "Mercedes-Benz"),
    GeneralModel(id: 9, name: "BMW"),
    GeneralModel(id: 10, name: "Audi"),
    GeneralModel(id: 11, name: "Chevrolet"),
    GeneralModel(id: 12, name: "Tesla"),
    GeneralModel(id: 13, name: "Renault"),
    GeneralModel(id: 14, name: "Fiat"),
    GeneralModel(id: 15, name: "Peugeot"),
    GeneralModel(id: 16, name: "Suzuki"),
    GeneralModel(id: 17, name: "Mazda"),
    GeneralModel(id: 18, name: "Subaru"),
    GeneralModel(id: 19, name: "Mitsubishi"),
    GeneralModel(id: 20, name: "Volvo"),
    GeneralModel(id: 21, name: "Dacia"),
    GeneralModel(id: 22, name: "Lexus"),
    GeneralModel(id: 23, name: "Dodge"),
    GeneralModel(id: 24, name: "Jeep"),
    GeneralModel(id: 25, name: "Jaguar"),
    GeneralModel(id: 26, name: "Land Rover"),
    GeneralModel(id: 27, name: "Porsche"),
    GeneralModel(id: 28, name: "Skoda"),
    GeneralModel(id: 29, name: "Seat"),
    GeneralModel(id: 30, name: "Opel"),
    GeneralModel(id: 31, name: "Citroën"),
    GeneralModel(id: 32, name: "Chery"),
    GeneralModel(id: 33, name: "BYD"),
    GeneralModel(id: 34, name: "Great Wall"),
    GeneralModel(id: 35, name: "GWM"),
    GeneralModel(id: 36, name: "Haval"),
    GeneralModel(id: 37, name: "Tata"),
    GeneralModel(id: 38, name: "MG"),
    GeneralModel(id: 39, name: "Dongfeng"),
    GeneralModel(id: 40, name: "Geely"),
    GeneralModel(id: 41, name: "Saab"),
    GeneralModel(id: 42, name: "Maserati"),
    GeneralModel(id: 43, name: "Bentley"),
    GeneralModel(id: 44, name: "Rolls-Royce"),
    GeneralModel(id: 45, name: "Ferrari"),
    GeneralModel(id: 46, name: "Lamborghini"),
    GeneralModel(id: 47, name: "Alfa Romeo"),
    GeneralModel(id: 48, name: "DS (DS Automobiles)"),
    GeneralModel(id: 49, name: "Daihatsu"),
    GeneralModel(id: 50, name: "Infiniti"),
    GeneralModel(id: 51, name: "Isuzu"),
  ];
}
