import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
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
}
