import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/model/onboarding_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

  static void getFirebaseException(FirebaseException e) {
    if (Get.isDialogOpen == true) Get.back();
    if (e.code == 'email-already-in-use') {
      Utils.showSnackBar(message: "email_already_in_use", success: false);
    } else if (e.code == 'weak-password') {
      Utils.showSnackBar(message: "weak_password", success: false);
    } else if (e.code == 'permission-denied') {
      Utils.showSnackBar(message: "permission_denied".tr, success: false);
    } else if (e.code == 'unavailable') {
      Utils.showSnackBar(message: "network_error".tr, success: false);
    } else if (e.code == "user-not-found") {
      Utils.showSnackBar(message: "no_user_found", success: false);
    } else if (e.code == "wrong-password") {
      Utils.showSnackBar(message: "wrong_password", success: false);
    } else if (e.code == "invalid-credential") {
      Utils.showSnackBar(message: "invalid_email_or_password", success: false);
    } else if (e.code == "too-many-requests") {
      Utils.showSnackBar(message: "too_many_requests", success: false);
    } else {
      Utils.showSnackBar(message: "something_wrong".tr, success: false);
    }
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

  static void showProgressDialog() {
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
                  child: Image.asset(
                    "assets/images/main_logo.png",
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(
                  height: 52,
                  width: 52,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Utils.appColor),
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

  static Future<void> onPickedFile({
    required XFile? pickedFile,
    required Function(String path) onTap,
  }) async {
    if (pickedFile != null) {
      try {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Utils.appColor,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
              aspectRatioPresets: [CropAspectRatioPreset.square],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset
                    .square, // IMPORTANT: iOS supports only one custom aspect ratio in preset list
              ],
            ),
          ],
        );
        if (croppedFile != null) {
          onTap(croppedFile.path);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
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
                  color: Get.isDarkMode ? Colors.white : Colors.black,
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
                      color: Get.isDarkMode ? Colors.white : Colors.black,
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
                      color: Get.isDarkMode ? Colors.white : Colors.black,
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
    const defaultFormat = "dd MMM yyyy";
    final format = Get.isRegistered<AppService>()
        ? Get.find<AppService>().selectedDateFormat.value
        : defaultFormat;
    return DateFormat(format).format(date);
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

  static final List<Map<String, String>> currencies = [
    // Americas
    {
      'name': 'Pakistani Rupee',
      'code': 'PKR',
      'symbol': 'Rs',
      'format': 'Rs 1,000.00',
    },
    {
      'name': 'US Dollar',
      'code': 'USD',
      'symbol': '\$',
      'format': '\$1,000.00',
    },
    {
      'name': 'Canadian Dollar',
      'code': 'CAD',
      'symbol': 'CA\$',
      'format': 'CA\$1,000.00',
    },
    {
      'name': 'Mexican Peso',
      'code': 'MXN',
      'symbol': 'MX\$',
      'format': 'MX\$1,000.00',
    },
    {
      'name': 'Brazilian Real',
      'code': 'BRL',
      'symbol': 'R\$',
      'format': 'R\$1.000,00',
    },
    {
      'name': 'Argentine Peso',
      'code': 'ARS',
      'symbol': 'AR\$',
      'format': 'AR\$1.000,00',
    },
    {
      'name': 'Chilean Peso',
      'code': 'CLP',
      'symbol': 'CL\$',
      'format': 'CL\$1.000',
    },
    {
      'name': 'Colombian Peso',
      'code': 'COP',
      'symbol': 'CO\$',
      'format': 'CO\$1.000,00',
    },
    {
      'name': 'Peruvian Sol',
      'code': 'PEN',
      'symbol': 'S/',
      'format': 'S/1,000.00',
    },
    {
      'name': 'Uruguayan Peso',
      'code': 'UYU',
      'symbol': '\$U',
      'format': '\$U1.000,00',
    },
    {
      'name': 'Paraguayan Guarani',
      'code': 'PYG',
      'symbol': '₲',
      'format': '₲1.000',
    },
    {
      'name': 'Venezuelan Bolivar',
      'code': 'VES',
      'symbol': 'Bs.',
      'format': 'Bs.1.000,00',
    },
    {
      'name': 'Jamaican Dollar',
      'code': 'JMD',
      'symbol': 'J\$',
      'format': 'J\$1,000.00',
    },
    {
      'name': 'Trinidad Dollar',
      'code': 'TTD',
      'symbol': 'TT\$',
      'format': 'TT\$1,000.00',
    },

    // Europe
    {'name': 'Euro', 'code': 'EUR', 'symbol': '€', 'format': '€1.000,00'},
    {
      'name': 'British Pound',
      'code': 'GBP',
      'symbol': '£',
      'format': '£1,000.00',
    },
    {
      'name': 'Swiss Franc',
      'code': 'CHF',
      'symbol': 'CHF',
      'format': 'CHF 1\'000.00',
    },
    {
      'name': 'Swedish Krona',
      'code': 'SEK',
      'symbol': 'kr',
      'format': '1 000,00 kr',
    },
    {
      'name': 'Norwegian Krone',
      'code': 'NOK',
      'symbol': 'kr',
      'format': '1 000,00 kr',
    },
    {
      'name': 'Danish Krone',
      'code': 'DKK',
      'symbol': 'kr',
      'format': '1.000,00 kr',
    },
    {
      'name': 'Polish Zloty',
      'code': 'PLN',
      'symbol': 'zł',
      'format': '1 000,00 zł',
    },
    {
      'name': 'Czech Koruna',
      'code': 'CZK',
      'symbol': 'Kč',
      'format': '1 000,00 Kč',
    },
    {
      'name': 'Hungarian Forint',
      'code': 'HUF',
      'symbol': 'Ft',
      'format': '1 000 Ft',
    },
    {
      'name': 'Romanian Leu',
      'code': 'RON',
      'symbol': 'lei',
      'format': '1.000,00 lei',
    },
    {
      'name': 'Bulgarian Lev',
      'code': 'BGN',
      'symbol': 'лв',
      'format': '1 000,00 лв',
    },
    {
      'name': 'Croatian Kuna',
      'code': 'HRK',
      'symbol': 'kn',
      'format': '1.000,00 kn',
    },
    {
      'name': 'Serbian Dinar',
      'code': 'RSD',
      'symbol': 'дин.',
      'format': '1.000,00 дин.',
    },
    {
      'name': 'Ukrainian Hryvnia',
      'code': 'UAH',
      'symbol': '₴',
      'format': '1 000,00 ₴',
    },
    {
      'name': 'Russian Ruble',
      'code': 'RUB',
      'symbol': '₽',
      'format': '1 000,00 ₽',
    },
    {
      'name': 'Turkish Lira',
      'code': 'TRY',
      'symbol': '₺',
      'format': '₺1.000,00',
    },
    {
      'name': 'Icelandic Krona',
      'code': 'ISK',
      'symbol': 'kr',
      'format': '1.000 kr',
    },

    // Asia
    {'name': 'Japanese Yen', 'code': 'JPY', 'symbol': '¥', 'format': '¥1,000'},
    {
      'name': 'Chinese Yuan',
      'code': 'CNY',
      'symbol': '¥',
      'format': '¥1,000.00',
    },
    {
      'name': 'Hong Kong Dollar',
      'code': 'HKD',
      'symbol': 'HK\$',
      'format': 'HK\$1,000.00',
    },
    {
      'name': 'Taiwan Dollar',
      'code': 'TWD',
      'symbol': 'NT\$',
      'format': 'NT\$1,000',
    },
    {
      'name': 'South Korean Won',
      'code': 'KRW',
      'symbol': '₩',
      'format': '₩1,000',
    },
    {
      'name': 'Indian Rupee',
      'code': 'INR',
      'symbol': '₹',
      'format': '₹1,00,000.00',
    },

    {
      'name': 'Bangladeshi Taka',
      'code': 'BDT',
      'symbol': '৳',
      'format': '৳1,000.00',
    },
    {
      'name': 'Sri Lankan Rupee',
      'code': 'LKR',
      'symbol': 'Rs',
      'format': 'Rs 1,000.00',
    },
    {
      'name': 'Nepalese Rupee',
      'code': 'NPR',
      'symbol': 'रू',
      'format': 'रू 1,000.00',
    },
    {'name': 'Thai Baht', 'code': 'THB', 'symbol': '฿', 'format': '฿1,000.00'},
    {
      'name': 'Vietnamese Dong',
      'code': 'VND',
      'symbol': '₫',
      'format': '1.000 ₫',
    },
    {
      'name': 'Malaysian Ringgit',
      'code': 'MYR',
      'symbol': 'RM',
      'format': 'RM1,000.00',
    },
    {
      'name': 'Singapore Dollar',
      'code': 'SGD',
      'symbol': 'S\$',
      'format': 'S\$1,000.00',
    },
    {
      'name': 'Indonesian Rupiah',
      'code': 'IDR',
      'symbol': 'Rp',
      'format': 'Rp1.000',
    },
    {
      'name': 'Philippine Peso',
      'code': 'PHP',
      'symbol': '₱',
      'format': '₱1,000.00',
    },
    {'name': 'Myanmar Kyat', 'code': 'MMK', 'symbol': 'K', 'format': 'K1,000'},
    {
      'name': 'Cambodian Riel',
      'code': 'KHR',
      'symbol': '៛',
      'format': '៛1,000',
    },
    {'name': 'Lao Kip', 'code': 'LAK', 'symbol': '₭', 'format': '₭1,000'},
    {
      'name': 'Brunei Dollar',
      'code': 'BND',
      'symbol': 'B\$',
      'format': 'B\$1,000.00',
    },

    // Middle East
    {
      'name': 'UAE Dirham',
      'code': 'AED',
      'symbol': 'د.إ',
      'format': 'د.إ 1,000.00',
    },
    {
      'name': 'Saudi Riyal',
      'code': 'SAR',
      'symbol': 'ر.س',
      'format': 'ر.س 1,000.00',
    },
    {
      'name': 'Qatari Riyal',
      'code': 'QAR',
      'symbol': 'ر.ق',
      'format': 'ر.ق 1,000.00',
    },
    {
      'name': 'Kuwaiti Dinar',
      'code': 'KWD',
      'symbol': 'د.ك',
      'format': 'د.ك 1,000.000',
    },
    {
      'name': 'Bahraini Dinar',
      'code': 'BHD',
      'symbol': 'د.ب',
      'format': 'د.ب 1,000.000',
    },
    {
      'name': 'Omani Rial',
      'code': 'OMR',
      'symbol': 'ر.ع.',
      'format': 'ر.ع. 1,000.000',
    },
    {
      'name': 'Jordanian Dinar',
      'code': 'JOD',
      'symbol': 'د.أ',
      'format': 'د.أ 1,000.000',
    },
    {
      'name': 'Lebanese Pound',
      'code': 'LBP',
      'symbol': 'ل.ل',
      'format': 'ل.ل 1,000',
    },
    {
      'name': 'Israeli Shekel',
      'code': 'ILS',
      'symbol': '₪',
      'format': '₪1,000.00',
    },
    {
      'name': 'Iraqi Dinar',
      'code': 'IQD',
      'symbol': 'ع.د',
      'format': 'ع.د 1,000',
    },
    {'name': 'Iranian Rial', 'code': 'IRR', 'symbol': '﷼', 'format': '﷼1,000'},
    {
      'name': 'Yemeni Rial',
      'code': 'YER',
      'symbol': '﷼',
      'format': '﷼1,000.00',
    },
    {
      'name': 'Syrian Pound',
      'code': 'SYP',
      'symbol': '£S',
      'format': '£S1,000',
    },
    {
      'name': 'Egyptian Pound',
      'code': 'EGP',
      'symbol': 'E£',
      'format': 'E£1,000.00',
    },

    // Africa
    {
      'name': 'South African Rand',
      'code': 'ZAR',
      'symbol': 'R',
      'format': 'R1 000,00',
    },
    {
      'name': 'Nigerian Naira',
      'code': 'NGN',
      'symbol': '₦',
      'format': '₦1,000.00',
    },
    {
      'name': 'Kenyan Shilling',
      'code': 'KES',
      'symbol': 'KSh',
      'format': 'KSh1,000.00',
    },
    {
      'name': 'Ghanaian Cedi',
      'code': 'GHS',
      'symbol': 'GH₵',
      'format': 'GH₵1,000.00',
    },
    {
      'name': 'Tanzanian Shilling',
      'code': 'TZS',
      'symbol': 'TSh',
      'format': 'TSh1,000',
    },
    {
      'name': 'Ugandan Shilling',
      'code': 'UGX',
      'symbol': 'USh',
      'format': 'USh1,000',
    },
    {
      'name': 'Ethiopian Birr',
      'code': 'ETB',
      'symbol': 'Br',
      'format': 'Br1,000.00',
    },
    {
      'name': 'Moroccan Dirham',
      'code': 'MAD',
      'symbol': 'د.م.',
      'format': 'د.م. 1,000.00',
    },
    {
      'name': 'Algerian Dinar',
      'code': 'DZD',
      'symbol': 'د.ج',
      'format': 'د.ج 1,000.00',
    },
    {
      'name': 'Tunisian Dinar',
      'code': 'TND',
      'symbol': 'د.ت',
      'format': 'د.ت 1,000.000',
    },
    {
      'name': 'Libyan Dinar',
      'code': 'LYD',
      'symbol': 'ل.د',
      'format': 'ل.د 1,000.000',
    },
    {
      'name': 'CFA Franc BCEAO',
      'code': 'XOF',
      'symbol': 'CFA',
      'format': 'CFA 1 000',
    },
    {
      'name': 'CFA Franc BEAC',
      'code': 'XAF',
      'symbol': 'FCFA',
      'format': 'FCFA 1 000',
    },
    {
      'name': 'Botswana Pula',
      'code': 'BWP',
      'symbol': 'P',
      'format': 'P1,000.00',
    },
    {
      'name': 'Zambian Kwacha',
      'code': 'ZMW',
      'symbol': 'ZK',
      'format': 'ZK1,000.00',
    },
    {
      'name': 'Rwandan Franc',
      'code': 'RWF',
      'symbol': 'FRw',
      'format': 'FRw 1,000',
    },
    {
      'name': 'Mauritian Rupee',
      'code': 'MUR',
      'symbol': '₨',
      'format': '₨1,000',
    },

    // Oceania
    {
      'name': 'Australian Dollar',
      'code': 'AUD',
      'symbol': 'A\$',
      'format': 'A\$1,000.00',
    },
    {
      'name': 'New Zealand Dollar',
      'code': 'NZD',
      'symbol': 'NZ\$',
      'format': 'NZ\$1,000.00',
    },
    {
      'name': 'Fiji Dollar',
      'code': 'FJD',
      'symbol': 'FJ\$',
      'format': 'FJ\$1,000.00',
    },
    {
      'name': 'Papua New Guinea Kina',
      'code': 'PGK',
      'symbol': 'K',
      'format': 'K1,000.00',
    },
    {
      'name': 'Samoan Tala',
      'code': 'WST',
      'symbol': 'WS\$',
      'format': 'WS\$1,000.00',
    },
    {
      'name': 'Tongan Paanga',
      'code': 'TOP',
      'symbol': 'T\$',
      'format': 'T\$1,000.00',
    },
    {
      'name': 'Vanuatu Vatu',
      'code': 'VUV',
      'symbol': 'VT',
      'format': 'VT1,000',
    },
    {
      'name': 'Solomon Islands Dollar',
      'code': 'SBD',
      'symbol': 'SI\$',
      'format': 'SI\$1,000.00',
    },

    // Central Asia & Caucasus
    {
      'name': 'Kazakhstani Tenge',
      'code': 'KZT',
      'symbol': '₸',
      'format': '₸1 000,00',
    },
    {
      'name': 'Uzbekistani Som',
      'code': 'UZS',
      'symbol': 'сўм',
      'format': 'сўм 1 000',
    },
    {
      'name': 'Georgian Lari',
      'code': 'GEL',
      'symbol': '₾',
      'format': '₾1,000.00',
    },
    {'name': 'Armenian Dram', 'code': 'AMD', 'symbol': '֏', 'format': '֏1,000'},
    {
      'name': 'Azerbaijani Manat',
      'code': 'AZN',
      'symbol': '₼',
      'format': '₼1,000.00',
    },
    {
      'name': 'Turkmenistan Manat',
      'code': 'TMT',
      'symbol': 'm',
      'format': 'm1,000.00',
    },
    {
      'name': 'Kyrgyzstani Som',
      'code': 'KGS',
      'symbol': 'сом',
      'format': 'сом 1,000.00',
    },
    {
      'name': 'Tajikistani Somoni',
      'code': 'TJS',
      'symbol': 'ЅМ',
      'format': 'ЅМ1,000.00',
    },

    // Other
    {
      'name': 'Afghan Afghani',
      'code': 'AFN',
      'symbol': '؋',
      'format': '؋1,000.00',
    },
    {'name': 'Bitcoin', 'code': 'BTC', 'symbol': '₿', 'format': '₿0.00000000'},
  ];

  static final List<String> vehicleTypesList = [
    'car',
    'bike',
    'truck',
    'bus',
    'others',
  ];

  static final List<OnboardingModel> userTypeList = [
    OnboardingModel(
      title: "user_type_admin_title",
      description: "user_type_admin_desc",
      imagePath: "",
    ),
    OnboardingModel(
      title: "user_type_driver_title",
      description: "user_type_driver_desc",
      imagePath: "",
    ),
  ];

  static final List<String> fuelTypeList = [
    'Liquids',
    'Liquefied petroleum gas',
    'Compressed natural gas',
    'Electrical',
  ];

  static final List<String> dayMonthList = ['day', 'month'];

  static List<DateTime> getDatesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    final List<DateTime> dates = [];

    // Normalize to avoid time issues
    DateTime current = DateTime(start.year, start.month, start.day);
    DateTime last = DateTime(end.year, end.month, end.day);

    while (!current.isAfter(last)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  static List<Map<String, int>> getMonthsBetween(DateTime start, DateTime end) {
    if (start.isAfter(end)) return [];

    final List<Map<String, int>> months = [];

    DateTime current = DateTime(start.year, start.month);
    DateTime last = DateTime(end.year, end.month);

    while (!current.isAfter(last)) {
      months.add({'year': current.year, 'month': current.month});

      current = DateTime(current.year, current.month + 1);
    }

    return months;
  }

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
