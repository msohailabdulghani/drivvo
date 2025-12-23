import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
  static const Color appColor = Color(0xFF047772);

  static TextStyle getTextStyle({
    required double baseSize,
    required bool isBold,
    required Color color,
    required bool isUrdu,
  }) {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
      fontSize: isUrdu ? baseSize + 3 : baseSize,
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

  // Format date as "dd MMM" (e.g., "17 dec")
  static String formatAccountDate(DateTime date) {
    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }

  // !Format date as "dd MMM" (e.g., "17 Dec")
  // static String formatAccountDate(DateTime date) {
  //   return DateFormat("dd MMM").format(date).toLowerCase();
  // }

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

  static void showAlertDialog({
    required String confirmMsg,
    required Function onTapYes,
    required bool isUrdu,
  }) {
    Get.defaultDialog(
      title: "",
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        width: Get.mediaQuery.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.isDarkMode ? const Color(0xFF39374C) : Colors.white,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                confirmMsg.tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  baseSize: 14,
                  isBold: false,
                  color: Colors.black,
                  isUrdu: isUrdu,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "no".tr,
                    style: getTextStyle(
                      baseSize: 14,
                      isBold: true,
                      color: Colors.black,
                      isUrdu: isUrdu,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => onTapYes(),
                  child: Text(
                    "yes".tr,
                    style: getTextStyle(
                      baseSize: 14,
                      isBold: true,
                      color: Colors.black,
                      isUrdu: isUrdu,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.transparent,
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
    70,
    (index) => DateTime.now().year - index,
  );

  static final List<GeneralModel> manufacturers = [
    GeneralModel(id: "1", name: "Toyota"),
    GeneralModel(id: "2", name: "Volkswagen"),
    GeneralModel(id: "3", name: "Ford"),
    GeneralModel(id: "4", name: "Honda"),
    GeneralModel(id: "5", name: "Nissan"),
    GeneralModel(id: "6", name: "Hyundai"),
    GeneralModel(id: "7", name: "Kia"),
    GeneralModel(id: "8", name: "Mercedes-Benz"),
    GeneralModel(id: "9", name: "BMW"),
    GeneralModel(id: "10", name: "Audi"),
    GeneralModel(id: "11", name: "Chevrolet"),
    GeneralModel(id: "12", name: "Tesla"),
    GeneralModel(id: "13", name: "Renault"),
    GeneralModel(id: "14", name: "Fiat"),
    GeneralModel(id: "15", name: "Peugeot"),
    GeneralModel(id: "16", name: "Suzuki"),
    GeneralModel(id: "17", name: "Mazda"),
    GeneralModel(id: "18", name: "Subaru"),
    GeneralModel(id: "19", name: "Mitsubishi"),
    GeneralModel(id: "20", name: "Volvo"),
    GeneralModel(id: "21", name: "Dacia"),
    GeneralModel(id: "22", name: "Lexus"),
    GeneralModel(id: "23", name: "Dodge"),
    GeneralModel(id: "24", name: "Jeep"),
    GeneralModel(id: "25", name: "Jaguar"),
    GeneralModel(id: "26", name: "Land Rover"),
    GeneralModel(id: "27", name: "Porsche"),
    GeneralModel(id: "28", name: "Skoda"),
    GeneralModel(id: "29", name: "Seat"),
    GeneralModel(id: "30", name: "Opel"),
    GeneralModel(id: "31", name: "Citroën"),
    GeneralModel(id: "32", name: "Chery"),
    GeneralModel(id: "33", name: "BYD"),
    GeneralModel(id: "34", name: "Great Wall"),
    GeneralModel(id: "35", name: "GWM"),
    GeneralModel(id: "36", name: "Haval"),
    GeneralModel(id: "37", name: "Tata"),
    GeneralModel(id: "38", name: "MG"),
    GeneralModel(id: "39", name: "Dongfeng"),
    GeneralModel(id: "40", name: "Geely"),
    GeneralModel(id: "41", name: "Saab"),
    GeneralModel(id: "42", name: "Maserati"),
    GeneralModel(id: "43", name: "Bentley"),
    GeneralModel(id: "44", name: "Rolls-Royce"),
    GeneralModel(id: "45", name: "Ferrari"),
    GeneralModel(id: "46", name: "Lamborghini"),
    GeneralModel(id: "47", name: "Alfa Romeo"),
    GeneralModel(id: "48", name: "DS (DS Automobiles)"),
    GeneralModel(id: "49", name: "Daihatsu"),
    GeneralModel(id: "50", name: "Infiniti"),
    GeneralModel(id: "51", name: "Isuzu"),
    // --- Japanese ---
    GeneralModel(id: "52", name: "Acura"),
    GeneralModel(id: "53", name: "Scion"),
    GeneralModel(id: "54", name: "Hino"),
    GeneralModel(id: "55", name: "UD Trucks"),

    // --- Korean ---
    GeneralModel(id: "56", name: "Genesis"),
    GeneralModel(id: "57", name: "Daewoo"),
    GeneralModel(id: "58", name: "SsangYong"),

    // --- Chinese ---
    GeneralModel(id: "59", name: "FAW"),
    GeneralModel(id: "60", name: "BAIC"),
    GeneralModel(id: "61", name: "SAIC"),
    GeneralModel(id: "62", name: "JAC"),
    GeneralModel(id: "63", name: "Zotye"),
    GeneralModel(id: "64", name: "NIO"),
    GeneralModel(id: "65", name: "XPeng"),
    GeneralModel(id: "66", name: "Li Auto"),
    GeneralModel(id: "67", name: "Leapmotor"),
    GeneralModel(id: "68", name: "Seres"),
    GeneralModel(id: "69", name: "Hongqi"),
    GeneralModel(id: "70", name: "Wuling"),

    // --- Indian ---
    GeneralModel(id: "71", name: "Mahindra"),
    GeneralModel(id: "72", name: "Ashok Leyland"),
    GeneralModel(id: "73", name: "Force Motors"),
    GeneralModel(id: "74", name: "Hindustan Motors"),

    // --- European ---
    GeneralModel(id: "75", name: "Aston Martin"),
    GeneralModel(id: "76", name: "Bugatti"),
    GeneralModel(id: "77", name: "Lancia"),
    GeneralModel(id: "78", name: "Smart"),
    GeneralModel(id: "79", name: "Mini"),
    GeneralModel(id: "80", name: "Cupra"),
    GeneralModel(id: "81", name: "Polestar"),
    GeneralModel(id: "82", name: "Koenigsegg"),
    GeneralModel(id: "83", name: "Pagani"),

    // --- American ---
    GeneralModel(id: "84", name: "Cadillac"),
    GeneralModel(id: "85", name: "Buick"),
    GeneralModel(id: "86", name: "GMC"),
    GeneralModel(id: "87", name: "Chrysler"),
    GeneralModel(id: "88", name: "Lincoln"),
    GeneralModel(id: "89", name: "Ram"),
    GeneralModel(id: "90", name: "Rivian"),
    GeneralModel(id: "91", name: "Lucid"),
    GeneralModel(id: "92", name: "Fisker"),

    // --- Electric / New Age ---
    GeneralModel(id: "93", name: "VinFast"),
    GeneralModel(id: "94", name: "Ather"),
    GeneralModel(id: "95", name: "Ola Electric"),
    GeneralModel(id: "96", name: "Proton"),
    GeneralModel(id: "97", name: "Perodua"),

    // --- Commercial / Heavy Vehicles ---
    GeneralModel(id: "98", name: "MAN"),
    GeneralModel(id: "99", name: "Scania"),
    GeneralModel(id: "100", name: "Iveco"),
    GeneralModel(id: "101", name: "Kamaz"),
    GeneralModel(id: "102", name: "Ural"),
  ];

  static List<DateRangeModel> getDateRangeList({required List<String> titles}) {
    List<DateRangeModel> list = [];

    final date = DateTime.now();
    for (final (i, e) in titles.indexed) {
      if (e == "today") {
        final dateStr =
            "${Utils.formatDate(date: date)} To ${Utils.formatDate(date: date)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: date,
            endDate: date,
            dateString: dateStr,
          ),
        );
      } else if (e == "yesterday") {
        final yesterdayDate = date.subtract(const Duration(days: 1));
        final dateStr =
            "${Utils.formatDate(date: yesterdayDate)} To ${Utils.formatDate(date: yesterdayDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: yesterdayDate,
            endDate: yesterdayDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "this_week") {
        final fromDate = date.subtract(const Duration(days: 7));
        final toDate = date;
        final dateStr =
            "${Utils.formatDate(date: fromDate)} To ${Utils.formatDate(date: toDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: fromDate,
            endDate: toDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "this_month") {
        final fromDate = DateTime(date.year, date.month, 1);
        final toDate = date;
        final dateStr =
            "${Utils.formatDate(date: fromDate)} To ${Utils.formatDate(date: toDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: fromDate,
            endDate: toDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "last_month") {
        // final fromDate = DateTime(date.year, date.month - 1, 1);
        // final toDate = DateTime(date.year, date.month, 0);

        final lastMonth = DateTime(date.year, date.month - 1);
        final fromDate = DateTime(lastMonth.year, lastMonth.month, 1);
        final toDate = DateTime(date.year, date.month, 0);
        final dateStr =
            "${Utils.formatDate(date: fromDate)} To ${Utils.formatDate(date: toDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: fromDate,
            endDate: toDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "last_6_months") {
        // final fromDate = DateTime(date.year, date.month - 6, 1);
        // final toDate = DateTime(date.year, date.month, 0);
        final sixMonthsAgo = DateTime(date.year, date.month - 6);
        final fromDate = DateTime(sixMonthsAgo.year, sixMonthsAgo.month, 1);
        final toDate = DateTime(date.year, date.month, 0);
        final dateStr =
            "${Utils.formatDate(date: fromDate)} To ${Utils.formatDate(date: toDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: fromDate,
            endDate: toDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "this_year") {
        final fromDate = DateTime(date.year, 1, 1);
        final toDate = date;
        final dateStr =
            "${Utils.formatDate(date: fromDate)} To ${Utils.formatDate(date: toDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: fromDate,
            endDate: toDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "last_year") {
        final fromDate = DateTime(date.year - 1, 1, 1);
        final toDate = DateTime(date.year - 1, 12, 31);
        final dateStr =
            "${Utils.formatDate(date: fromDate)} To ${Utils.formatDate(date: toDate)}";
        list.add(
          DateRangeModel(
            id: i,
            title: e,
            startDate: fromDate,
            endDate: toDate,
            dateString: dateStr,
          ),
        );
      } else if (e == "custom_date" || e == "all_the_time") {
        list.add(DateRangeModel(id: i, title: e, dateString: e));
      }
    }
    return list;
  }
}
