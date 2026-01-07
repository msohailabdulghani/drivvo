import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/model/onboarding_model.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/modules/admin/reports/reports_controller.dart';
import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  static Future<void> loadHomeAndReportData({
    required String snakBarMsg,
  }) async {
    final appService = Get.find<AppService>();

    if (appService.appUser.value.userType.toLowerCase() ==
        Constants.ADMIN.toLowerCase()) {
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadTimelineData();
      }

      if (Get.isRegistered<ReportsController>()) {
        await Get.find<ReportsController>().calculateAllReports();
      }
    } else {
      if (Get.isRegistered<DriverHomeController>()) {
        await Get.find<DriverHomeController>().loadTimelineData();
      }
    }

    if (Get.isDialogOpen == true) Get.back();
    Get.back();
    Utils.showSnackBar(message: snakBarMsg, success: true);
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

  static Future<void> showImagePicker({
    required bool isUrdu,
    required Function(String path) pickFile,
  }) async {
    final ImagePicker imgPicker = ImagePicker();

    Get.defaultDialog(
      title: "choose_option".tr,
      titleStyle: Utils.getTextStyle(
        baseSize: 16,
        isBold: true,
        color: Colors.black,
        isUrdu: isUrdu,
      ),
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Get.back();
                final pickedFile = await imgPicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 100,
                );
                if (pickedFile != null) {
                  onPickedFile(
                    pickedFile: pickedFile,
                    onTap: (path) => pickFile(path),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "take_photo".tr,
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: isUrdu,
                    ),
                  ),
                  const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 0.5, color: Color(0x20000000)),
            const SizedBox(height: 5),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Get.back();
                final pickedFile = await imgPicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 100,
                );
                if (pickedFile != null) {
                  Utils.onPickedFile(
                    pickedFile: pickedFile,
                    onTap: (path) => pickFile(path),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "gallery".tr,
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: isUrdu,
                    ),
                  ),
                  const Icon(
                    Icons.photo_library,
                    color: Colors.black,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<String> uploadImage({
    required String collectionPath,
    required String filePath,
  }) async {
    if (filePath.isEmpty) {
      Utils.showSnackBar(message: "select_photo", success: false);
      return "";
    }

    String getContentType(String path) {
      final extension = path.toLowerCase().split('.').last;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          return 'image/jpeg';
        case 'png':
          return 'image/png';
        case 'gif':
          return 'image/gif';
        case 'webp':
          return 'image/webp';
        default:
          return 'image/jpeg';
      }
    }

    final metadata = SettableMetadata(
      contentType: getContentType(filePath),
      customMetadata: {'picked-file-path': filePath},
    );

    // Generate unique filename
    final extension = filePath.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFileName = '$timestamp.$extension';
    try {
      final snapshot = await FirebaseStorage.instance
          .ref()
          .child(collectionPath)
          //.child(filePath)
          .child(uniqueFileName)
          .putFile(File(filePath), metadata);

      final url = await snapshot.ref.getDownloadURL();
      if (url.isNotEmpty) {
        return url;
      }
    } catch (error) {
      Utils.showSnackBar(message: "image_upload_failed", success: false);
      return "";
    }

    return "";
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
    GeneralModel(
      id: "1",
      name: "Toyota",
      logoUrl: "assets/images/logos/toyota.png",
    ),
    GeneralModel(
      id: "2",
      name: "Volkswagen",
      logoUrl: "assets/images/logos/volkswagen.png",
    ),
    GeneralModel(
      id: "3",
      name: "Ford",
      logoUrl: "assets/images/logos/ford.png",
    ),
    GeneralModel(
      id: "4",
      name: "Honda",
      logoUrl: "assets/images/logos/honda.png",
    ),
    GeneralModel(
      id: "5",
      name: "Nissan",
      logoUrl: "assets/images/logos/nissan.png",
    ),
    GeneralModel(
      id: "6",
      name: "Hyundai",
      logoUrl: "assets/images/logos/hyundai.png",
    ),
    GeneralModel(id: "7", name: "Kia", logoUrl: "assets/images/logos/kia.png"),
    GeneralModel(
      id: "8",
      name: "Mercedes-Benz",
      logoUrl: "assets/images/logos/mercedes.png",
    ),
    GeneralModel(id: "9", name: "BMW", logoUrl: "assets/images/logos/bmw.png"),
    GeneralModel(
      id: "10",
      name: "Audi",
      logoUrl: "assets/images/logos/audi.png",
    ),
    GeneralModel(
      id: "11",
      name: "Chevrolet",
      logoUrl: "assets/images/logos/chevrolet.png",
    ),
    GeneralModel(
      id: "12",
      name: "Tesla",
      logoUrl: "assets/images/logos/tesla.png",
    ),
    GeneralModel(
      id: "13",
      name: "Renault",
      logoUrl: "assets/images/logos/renault.png",
    ),
    GeneralModel(
      id: "14",
      name: "Fiat",
      logoUrl: "assets/images/logos/fiat.png",
    ),
    GeneralModel(
      id: "15",
      name: "Peugeot",
      logoUrl: "assets/images/logos/peugeot.png",
    ),
    GeneralModel(
      id: "16",
      name: "Suzuki",
      logoUrl: "assets/images/logos/suzuki.png",
    ),
    GeneralModel(
      id: "17",
      name: "Mazda",
      logoUrl: "assets/images/logos/mazda.png",
    ),
    GeneralModel(
      id: "18",
      name: "Subaru",
      logoUrl: "assets/images/logos/subaru.png",
    ),
    GeneralModel(
      id: "19",
      name: "Mitsubishi",
      logoUrl: "assets/images/logos/mitsubishi.png",
    ),
    GeneralModel(
      id: "20",
      name: "Volvo",
      logoUrl: "assets/images/logos/volvo.png",
    ),
    GeneralModel(
      id: "21",
      name: "Dacia",
      logoUrl: "assets/images/logos/dacia.png",
    ),
    GeneralModel(
      id: "22",
      name: "Lexus",
      logoUrl: "assets/images/logos/lexus.jpg",
    ),
    GeneralModel(
      id: "23",
      name: "Dodge",
      logoUrl: "assets/images/logos/dodge.png",
    ),
    GeneralModel(
      id: "24",
      name: "Jeep",
      logoUrl: "assets/images/logos/leep.png",
    ),
    GeneralModel(
      id: "25",
      name: "Jaguar",
      logoUrl: "assets/images/logos/jaguar.png",
    ),
    GeneralModel(
      id: "26",
      name: "Land Rover",
      logoUrl: "assets/images/logos/land_rover.png",
    ),
    GeneralModel(
      id: "27",
      name: "Porsche",
      logoUrl: "assets/images/logos/porsche.png",
    ),
    GeneralModel(
      id: "28",
      name: "Skoda",
      logoUrl: "assets/images/logos/sokoda.png",
    ),
    GeneralModel(
      id: "29",
      name: "Seat",
      logoUrl: "assets/images/logos/seat.png",
    ),
    GeneralModel(
      id: "30",
      name: "Opel",
      logoUrl: "assets/images/logos/opel.png",
    ),
    GeneralModel(
      id: "31",
      name: "Citroën",
      logoUrl: "assets/images/logos/citron.png",
    ),
    GeneralModel(
      id: "32",
      name: "Chery",
      logoUrl: "assets/images/logos/chery.png",
    ),
    GeneralModel(id: "33", name: "BYD", logoUrl: "assets/images/logos/byd.png"),
    GeneralModel(
      id: "34",
      name: "Great Wall",
      logoUrl: "assets/images/logos/great_wall.png",
    ),
    GeneralModel(id: "35", name: "GWM", logoUrl: "assets/images/logos/gwm.png"),
    GeneralModel(
      id: "36",
      name: "Haval",
      logoUrl: "assets/images/logos/haval.png",
    ),
    GeneralModel(
      id: "37",
      name: "Tata",
      logoUrl: "assets/images/logos/tata.png",
    ),
    GeneralModel(id: "38", name: "MG", logoUrl: "assets/images/logos/mg.png"),
    GeneralModel(
      id: "39",
      name: "Dongfeng",
      logoUrl: "assets/images/logos/dongfeng.png",
    ),
    GeneralModel(
      id: "40",
      name: "Geely",
      logoUrl: "assets/images/logos/geely.png",
    ),
    GeneralModel(
      id: "41",
      name: "Saab",
      logoUrl: "assets/images/logos/saab.png",
    ),
    GeneralModel(
      id: "42",
      name: "Maserati",
      logoUrl: "assets/images/logos/maserati.png",
    ),
    GeneralModel(
      id: "43",
      name: "Bentley",
      logoUrl: "assets/images/logos/bentley.png",
    ),
    GeneralModel(
      id: "44",
      name: "Rolls-Royce",
      logoUrl: "assets/images/logos/rolls_royce.png",
    ),
    GeneralModel(
      id: "45",
      name: "Ferrari",
      logoUrl: "assets/images/logos/ferrari.png",
    ),
    GeneralModel(
      id: "46",
      name: "Lamborghini",
      logoUrl: "assets/images/logos/lamborghini.png",
    ),
    GeneralModel(
      id: "47",
      name: "Alfa Romeo",
      logoUrl: "assets/images/logos/alfa_romeo.png",
    ),
    GeneralModel(
      id: "48",
      name: "DS (DS Automobiles)",
      logoUrl: "assets/images/logos/da_automobiles.png",
    ),
    GeneralModel(
      id: "49",
      name: "Daihatsu",
      logoUrl: "assets/images/logos/daihatsu.png",
    ),
    GeneralModel(
      id: "50",
      name: "Infiniti",
      logoUrl: "assets/images/logos/infiniti.png",
    ),
    GeneralModel(
      id: "51",
      name: "Isuzu",
      logoUrl: "assets/images/logos/isuzu.png",
    ),
    // --- Japanese ---
    GeneralModel(
      id: "52",
      name: "Acura",
      logoUrl: "assets/images/logos/acura.png",
    ),
    GeneralModel(
      id: "53",
      name: "Scion",
      logoUrl: "assets/images/logos/scion.png",
    ),
    GeneralModel(
      id: "54",
      name: "Hino",
      logoUrl: "assets/images/logos/hino.png",
    ),
    GeneralModel(
      id: "55",
      name: "UD Trucks",
      logoUrl: "assets/images/logos/ud_trucks.png",
    ),

    // --- Korean ---
    GeneralModel(
      id: "56",
      name: "Genesis",
      logoUrl: "assets/images/logos/genesis.png",
    ),
    GeneralModel(
      id: "57",
      name: "Daewoo",
      logoUrl: "assets/images/logos/daewoo.png",
    ),
    GeneralModel(
      id: "58",
      name: "SsangYong",
      logoUrl: "assets/images/logos/ssang_yong.png",
    ),

    // --- Chinese ---
    GeneralModel(id: "59", name: "FAW", logoUrl: "assets/images/logos/faw.png"),
    GeneralModel(
      id: "60",
      name: "BAIC",
      logoUrl: "assets/images/logos/baic.png",
    ),
    GeneralModel(
      id: "61",
      name: "SAIC",
      logoUrl: "assets/images/logos/saic.png",
    ),
    GeneralModel(id: "62", name: "JAC", logoUrl: "assets/images/logos/jac.png"),
    GeneralModel(
      id: "63",
      name: "Zotye",
      logoUrl: "assets/images/logos/zotye.png",
    ),
    GeneralModel(id: "64", name: "NIO", logoUrl: "assets/images/logos/nio.png"),
    GeneralModel(
      id: "65",
      name: "XPeng",
      logoUrl: "assets/images/logos/xpeng.png",
    ),
    GeneralModel(
      id: "66",
      name: "Li Auto",
      logoUrl: "assets/images/logos/li_auto.png",
    ),
    GeneralModel(
      id: "67",
      name: "Leapmotor",
      logoUrl: "assets/images/logos/leapmotor.png",
    ),
    GeneralModel(
      id: "68",
      name: "Seres",
      logoUrl: "assets/images/logos/seres.png",
    ),
    GeneralModel(
      id: "69",
      name: "Hongqi",
      logoUrl: "assets/images/logos/hongqi.png",
    ),
    GeneralModel(
      id: "70",
      name: "Wuling",
      logoUrl: "assets/images/logos/wuling.png",
    ),

    // --- Indian ---
    GeneralModel(
      id: "71",
      name: "Mahindra",
      logoUrl: "assets/images/logos/mahindra.png",
    ),
    GeneralModel(
      id: "72",
      name: "Ashok Leyland",
      logoUrl: "assets/images/logos/ashok_leyland.png",
    ),
    GeneralModel(
      id: "73",
      name: "Force Motors",
      logoUrl: "assets/images/logos/force.png",
    ),
    GeneralModel(
      id: "74",
      name: "Hindustan Motors",
      logoUrl: "assets/images/logos/hindustan_motors.png",
    ),

    // --- European ---
    GeneralModel(
      id: "75",
      name: "Aston Martin",
      logoUrl: "assets/images/logos/aston_martin.png",
    ),
    GeneralModel(
      id: "76",
      name: "Bugatti",
      logoUrl: "assets/images/logos/bugatti.png",
    ),
    GeneralModel(
      id: "77",
      name: "Lancia",
      logoUrl: "assets/images/logos/lancia.png",
    ),
    GeneralModel(
      id: "78",
      name: "Smart",
      logoUrl: "assets/images/logos/smart.png",
    ),
    GeneralModel(
      id: "79",
      name: "Mini",
      logoUrl: "assets/images/logos/mini.png",
    ),
    GeneralModel(
      id: "80",
      name: "Cupra",
      logoUrl: "assets/images/logos/cupra.png",
    ),
    GeneralModel(
      id: "81",
      name: "Polestar",
      logoUrl: "assets/images/logos/polestar.png",
    ),
    GeneralModel(
      id: "82",
      name: "Koenigsegg",
      logoUrl: "assets/images/logos/koenigsegg.png",
    ),
    GeneralModel(
      id: "83",
      name: "Pagani",
      logoUrl: "assets/images/logos/pagani.png",
    ),

    // --- American ---
    GeneralModel(
      id: "84",
      name: "Cadillac",
      logoUrl: "assets/images/logos/cadillac.png",
    ),
    GeneralModel(
      id: "85",
      name: "Buick",
      logoUrl: "assets/images/logos/buick.png",
    ),
    GeneralModel(id: "86", name: "GMC", logoUrl: "assets/images/logos/GMC.png"),
    GeneralModel(
      id: "87",
      name: "Chrysler",
      logoUrl: "assets/images/logos/chrysler.png",
    ),
    GeneralModel(
      id: "88",
      name: "Lincoln",
      logoUrl: "assets/images/logos/lincoln.png",
    ),
    GeneralModel(id: "89", name: "Ram", logoUrl: "assets/images/logos/ram.png"),
    GeneralModel(
      id: "90",
      name: "Rivian",
      logoUrl: "assets/images/logos/rivian.png",
    ),
    GeneralModel(
      id: "91",
      name: "Lucid",
      logoUrl: "assets/images/logos/lucid.png",
    ),
    GeneralModel(
      id: "92",
      name: "Fisker",
      logoUrl: "assets/images/logos/fisker.png",
    ),

    // --- Electric / New Age ---
    GeneralModel(
      id: "93",
      name: "VinFast",
      logoUrl: "assets/images/logos/vin_fast.png",
    ),
    GeneralModel(
      id: "94",
      name: "Ather",
      logoUrl: "assets/images/logos/ather.png",
    ),
    GeneralModel(
      id: "95",
      name: "Ola Electric",
      logoUrl: "assets/images/logos/ola_electric.png",
    ),
    GeneralModel(
      id: "96",
      name: "Proton",
      logoUrl: "assets/images/logos/proton.png",
    ),
    GeneralModel(
      id: "97",
      name: "Perodua",
      logoUrl: "assets/images/logos/perodua.png",
    ),

    // --- Commercial / Heavy Vehicles ---
    GeneralModel(id: "98", name: "MAN", logoUrl: "assets/images/logos/man.png"),
    GeneralModel(
      id: "99",
      name: "Scania",
      logoUrl: "assets/images/logos/scania.png",
    ),
    GeneralModel(
      id: "100",
      name: "Iveco",
      logoUrl: "assets/images/logos/iveco.png",
    ),
    GeneralModel(
      id: "101",
      name: "Kamaz",
      logoUrl: "assets/images/logos/kamaz.png",
    ),
    GeneralModel(
      id: "102",
      name: "Ural",
      logoUrl: "assets/images/logos/ural.png",
    ),

    GeneralModel(
      id: "103",
      name: "Lotus",
      logoUrl: "assets/images/logos/lotus.png",
    ),
    GeneralModel(
      id: "104",
      name: "McLaren",
      logoUrl: "assets/images/logos/mcLaren.png",
    ),
    GeneralModel(
      id: "105",
      name: "Xiaomi",
      logoUrl: "assets/images/logos/xiaomi.png",
    ),
    GeneralModel(
      id: "106",
      name: "Zeekr",
      logoUrl: "assets/images/logos/zeekr.png",
    ),
    GeneralModel(
      id: "107",
      name: "Changan",
      logoUrl: "assets/images/logos/changan.png",
    ),
    GeneralModel(
      id: "108",
      name: "GAC",
      logoUrl: "assets/images/logos/GAC_motor.png",
    ),
    GeneralModel(
      id: "109",
      name: "Vauxhall",
      logoUrl: "assets/images/logos/vauxhall.png",
    ),
    GeneralModel(
      id: "110",
      name: "Mack",
      logoUrl: "assets/images/logos/mack_trucks.png",
    ),
    GeneralModel(
      id: "111",
      name: "Peterbilt",
      logoUrl: "assets/images/logos/peterbilt.png",
    ),
    GeneralModel(
      id: "112",
      name: "Alpine",
      logoUrl: "assets/images/logos/alpine.png",
    ),

    // --- Missing High-Value Additions ---
    GeneralModel(
      id: "113",
      name: "Lada",
      logoUrl: "assets/images/logos/Lada.png",
    ),
    GeneralModel(
      id: "114",
      name: "Maybach",
      logoUrl: "assets/images/logos/Maybach.png",
    ),
    GeneralModel(
      id: "115",
      name: "Abarth",
      logoUrl: "assets/images/logos/Abarth.png",
    ),
    GeneralModel(
      id: "116",
      name: "DAF",
      logoUrl: "assets/images/logos/DAF.png",
    ),
    GeneralModel(
      id: "117",
      name: "Freightliner",
      logoUrl: "assets/images/logos/Freightliner.png",
    ),
    GeneralModel(
      id: "118",
      name: "Lynk & Co",
      logoUrl: "assets/images/logos/Lynk.png",
    ),
    GeneralModel(
      id: "119",
      name: "Hozon (Neta)",
      logoUrl: "assets/images/logos/Neta.png",
    ),
    GeneralModel(
      id: "120",
      name: "Karma",
      logoUrl: "assets/images/logos/Karma.png",
    ),

    // --- 2026 Global Power Players ---
    GeneralModel(
      id: "121",
      name: "Omoda",
      logoUrl: "assets/images/logos/Omoda.png",
    ),
    GeneralModel(
      id: "122",
      name: "Jaecoo",
      logoUrl: "assets/images/logos/Jaecoo.png",
    ),
    GeneralModel(
      id: "123",
      name: "Afeela",
      logoUrl: "assets/images/logos/Afeela.png",
    ),
    GeneralModel(
      id: "124",
      name: "Denza",
      logoUrl: "assets/images/logos/Denza.png",
    ),
    GeneralModel(
      id: "125",
      name: "Yangwang",
      logoUrl: "assets/images/logos/Yangwang.png",
    ),
    GeneralModel(
      id: "126",
      name: "Aion",
      logoUrl: "assets/images/logos/Aion.png",
    ),
    GeneralModel(
      id: "127",
      name: "Hummer",
      logoUrl: "assets/images/logos/Hummer.png",
    ),
    GeneralModel(
      id: "128",
      name: "Skyworth",
      logoUrl: "assets/images/logos/Skyworth.png",
    ),
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

  static Future<void> saveData({required String userDocId}) async {
    String? collectionPath;
    List<GeneralModel> generalList = [];

    for (int i = 0; i < 6; i++) {
      switch (i) {
        case 0:
          collectionPath = DatabaseTables.EXPENSE_TYPES;
          break;
        case 1:
          collectionPath = DatabaseTables.INCOME_TYPES;
          break;
        case 2:
          collectionPath = DatabaseTables.SERVICE_TYPES;
          break;
        case 3:
          collectionPath = DatabaseTables.PAYMENT_METHOD;
          break;
        case 4:
          collectionPath = DatabaseTables.REASONS;
          break;
        case 5:
          collectionPath = DatabaseTables.FUEL;
          break;
        default:
          debugPrint("Unknown title: $i");
          return;
      }
      if (collectionPath.isNotEmpty) {
        generalList.clear();
        try {
          final snapshot = await FirebaseFirestore.instance
              .collection(collectionPath)
              .get();

          if (snapshot.docs.isNotEmpty) {
            generalList = snapshot.docs.map((doc) {
              return GeneralModel.fromJson(doc.data());
            }).toList();

            if (generalList.isNotEmpty) {
              for (var e in generalList) {
                final map = e.toJson();

                await FirebaseFirestore.instance
                    .collection(DatabaseTables.USER_PROFILE)
                    .doc(userDocId)
                    .collection(collectionPath)
                    .doc()
                    .set(map);
              }
            }
          } else {
            debugPrint("No data found in $collectionPath");
          }
        } catch (e) {
          debugPrint("Error fetching $collectionPath: $e");
        }
      }
    }
  }
}
