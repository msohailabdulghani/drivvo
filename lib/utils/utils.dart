import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/model/onboarding_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/common_function.dart';
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

    // TOCTOU fix: Verify file exists and get file reference atomically
    final file = File(filePath);
    if (!await file.exists()) {
      debugPrint('Upload failed: File does not exist at path: $filePath');
      Utils.showSnackBar(message: "file_not_found", success: false);
      return "";
    }

    // Validate file size (max 10MB)
    const maxFileSize = 10 * 1024 * 1024; // 10MB in bytes
    try {
      final fileSize = await file.length();
      if (fileSize > maxFileSize) {
        Utils.showSnackBar(message: "file_too_large".tr, success: false);
        return "";
      }
      if (fileSize == 0) {
        Utils.showSnackBar(message: "file_empty", success: false);
        return "";
      }
    } catch (e) {
      debugPrint('Error checking file size: $e');
      Utils.showSnackBar(message: "file_read_error", success: false);
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
      // Re-check file exists right before upload to prevent TOCTOU
      if (!await file.exists()) {
        debugPrint('Upload failed: File was deleted before upload: $filePath');
        Utils.showSnackBar(message: "file_not_found", success: false);
        return "";
      }

      final snapshot = await FirebaseStorage.instance
          .ref()
          .child(collectionPath)
          .child(uniqueFileName)
          .putFile(file, metadata);

      final url = await snapshot.ref.getDownloadURL();
      if (url.isNotEmpty) {
        // Clean up temporary file after successful upload
        // Only delete if it's a temporary/cropped file (contains typical temp paths)
        await _cleanupTempFile(filePath);
        return url;
      }
    } on FirebaseException catch (error) {
      debugPrint('Firebase upload error: ${error.code} - ${error.message}');
      Utils.showSnackBar(message: "image_upload_failed", success: false);
      return "";
    } catch (error) {
      debugPrint('Upload error: $error');
      Utils.showSnackBar(message: "image_upload_failed", success: false);
      return "";
    }

    return "";
  }

  /// Clean up temporary file if it's a temporary/cropped file
  static Future<void> _cleanupTempFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        // Check if it's a temporary file (cropped images are typically in temp directories)
        final path = filePath.toLowerCase();
        final isTempFile =
            path.contains('cache') ||
            path.contains('temp') ||
            path.contains('cropped') ||
            path.contains('image_picker');

        if (isTempFile) {
          await file.delete();
          debugPrint('Cleaned up temporary file: $filePath');
        }
      }
    } catch (e) {
      // Silently fail cleanup - file may already be deleted or in use
      debugPrint('Error cleaning up temp file: $e');
    }
  }

  // !Format date as "dd MMM" (e.g., "17 Dec")
  // static String formatAccountDate(DateTime date) {
  //   return DateFormat("dd MMM").format(date).toLowerCase();
  // }

  static Future<void> cleanupFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;

    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Cleaned up file: $filePath');
      }
    } catch (e) {
      debugPrint('Error cleaning up file: $e');
    }
  }

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
                    "assets/images/main_logo_2.png",
                    width: 56,
                    height: 56,
                  ),
                ),
                const SizedBox(
                  height: 58,
                  width: 58,
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
        // TOCTOU fix: Verify file exists before cropping
        final file = File(pickedFile.path);
        if (!await file.exists()) {
          debugPrint('File does not exist: ${pickedFile.path}');
          Utils.showSnackBar(message: "file_not_found", success: false);
          return;
        }

        // Validate file size before cropping
        const maxFileSize = 10 * 1024 * 1024; // 10MB
        final fileSize = await file.length();
        if (fileSize > maxFileSize) {
          Utils.showSnackBar(message: "file_too_large".tr, success: false);
          return;
        }

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
          // Verify cropped file exists before using it
          final croppedFileExists = await File(croppedFile.path).exists();
          if (croppedFileExists) {
            onTap(croppedFile.path);
          } else {
            debugPrint('Cropped file does not exist: ${croppedFile.path}');
            Utils.showSnackBar(message: "file_not_found", success: false);
          }
        }
      } catch (e) {
        debugPrint('Error in onPickedFile: $e');
        Utils.showSnackBar(message: "file_processing_error", success: false);
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

  static String formatDateWithTime({dynamic date}) {
    if (date == null) {
      return "--";
    }
    return DateFormat("dd MMM yyyy hh:mm a").format(date);
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
    GeneralModel(id: "0", name: "Other", logoUrl: ""),
    GeneralModel(
      id: "1",
      name: "9ff",
      logoUrl: "https://www.carlogos.org/logo/9ff-logo-2560x1400.png",
    ),
    GeneralModel(
      id: "2",
      name: "Abadal",
      logoUrl: "https://www.carlogos.org/logo/Abadal-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "3",
      name: "Abarth",
      logoUrl: "https://www.carlogos.org/logo/Abarth-logo-1920x1080.png",
    ),
    // GeneralModel(
    //   id: "4",
    //   name: "Abbott-Detroit",
    //   logoUrl: "https://www.carlogos.org/logo/Abbott-Detroit-logo-640x107.jpg",
    // ),
    GeneralModel(
      id: "5",
      name: "ABT",
      logoUrl:
          "https://www.carlogos.org/logo/ABT-Sportsline-logo-silver-2560x1440.png",
    ),
    GeneralModel(
      id: "6",
      name: "AC",
      logoUrl: "https://www.carlogos.org/logo/AC-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "7",
      name: "Acura",
      logoUrl: "https://www.carlogos.org/logo/Acura-logo-1990-1024x768.png",
    ),
    GeneralModel(
      id: "8",
      name: "Aiways",
      logoUrl:
          "https://www.carlogos.org/car-logos/aiways-logo-2100x1350-show.png",
    ),
    GeneralModel(
      id: "9",
      name: "Aixam",
      logoUrl: "https://www.carlogos.org/logo/Aixam-logo-2010-2048x2048.png",
    ),
    GeneralModel(
      id: "10",
      name: "Alfa Romeo",
      logoUrl:
          "https://www.carlogos.org/logo/Alfa-Romeo-logo-2015-1920x1080.png",
    ),
    GeneralModel(
      id: "11",
      name: "Alpina",
      logoUrl: "https://www.carlogos.org/logo/Alpina-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "12",
      name: "Alpine",
      logoUrl: "https://www.carlogos.org/logo/Alpine-logo-1440x900.png",
    ),
    GeneralModel(
      id: "13",
      name: "Alta",
      logoUrl: "https://www.carlogos.org/logo/Alta-logo-640x138.jpg",
    ),
    GeneralModel(
      id: "14",
      name: "Alvis",
      logoUrl: "https://www.carlogos.org/logo/Alvis-logo-1440x900.png",
    ),
    GeneralModel(
      id: "15",
      name: "AMC",
      logoUrl:
          "https://www.carlogos.org/logo/American-Motors-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "16",
      name: "Apollo",
      logoUrl:
          "https://www.carlogos.org/logo/Apollo-Automobil-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "17",
      name: "Arash",
      logoUrl: "https://www.carlogos.org/logo/Arash-logo-640x410.png",
    ),
    GeneralModel(
      id: "18",
      name: "Arcfox",
      logoUrl:
          "https://www.carlogos.org/car-logos/arcfox-logo-1250x220-show.png",
    ),
    GeneralModel(
      id: "19",
      name: "Ariel",
      logoUrl: "https://www.carlogos.org/logo/Ariel-logo-2000-2500x2500.png",
    ),
    GeneralModel(
      id: "20",
      name: "ARO",
      logoUrl: "https://www.carlogos.org/logo/ARO-logo-640x567.jpg",
    ),
    GeneralModel(
      id: "21",
      name: "Arrinera",
      logoUrl: "https://www.carlogos.org/logo/Arrinera-logo-800x600.png",
    ),
    GeneralModel(
      id: "22",
      name: "Arrival",
      logoUrl:
          "https://www.carlogos.org/car-logos/arrival-logo-2600x350-show.png",
    ),
    GeneralModel(
      id: "23",
      name: "Artega",
      logoUrl: "https://www.carlogos.org/logo/Artega-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "24",
      name: "Ascari",
      logoUrl: "https://www.carlogos.org/logo/Ascari-logo-1995-2560x1440.png",
    ),
    GeneralModel(
      id: "25",
      name: "Askam",
      logoUrl: "https://www.carlogos.org/logo/Askam-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "26",
      name: "Aspark",
      logoUrl:
          "https://www.carlogos.org/car-logos/aspark-logo-1000x1000-show.png",
    ),
    GeneralModel(
      id: "27",
      name: "Aston Martin",
      logoUrl:
          "https://www.carlogos.org/logo/Aston-Martin-logo-2003-6000x3000.png",
    ),
    GeneralModel(
      id: "28",
      name: "Atalanta",
      logoUrl:
          "https://www.carlogos.org/logo/Atalanta-Motors-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "29",
      name: "Auburn",
      logoUrl: "https://www.carlogos.org/logo/Auburn-logo.png",
    ),
    GeneralModel(
      id: "30",
      name: "Audi",
      logoUrl: "https://www.carlogos.org/car-logos/audi-logo-2016-640.png",
    ),
    GeneralModel(
      id: "31",
      name: "Audi Sport",
      logoUrl: "https://www.carlogos.org/logo/Audi-Sport-logo-2500x500.png",
    ),
    GeneralModel(
      id: "32",
      name: "Austin",
      logoUrl: "https://www.carlogos.org/logo/Austin-logo-640x500.jpg",
    ),
    GeneralModel(
      id: "33",
      name: "Autobacs",
      logoUrl: "https://www.carlogos.org/logo/Autobacs-logo-640x462.jpg",
    ),
    GeneralModel(
      id: "34",
      name: "Autobianchi",
      logoUrl: "https://www.carlogos.org/logo/Autobianchi-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "35",
      name: "Axon",
      logoUrl:
          "https://www.carlogos.org/logo/Axon-Automotive-logo-1024x768.png",
    ),
    GeneralModel(
      id: "36",
      name: "BAC",
      logoUrl: "https://www.carlogos.org/logo/BAC-logo-black-1024x768.png",
    ),
    GeneralModel(
      id: "37",
      name: "BAIC Motor",
      logoUrl: "https://www.carlogos.org/logo/BAIC-Motor-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "38",
      name: "Baojun",
      logoUrl: "https://www.carlogos.org/logo/Baojun-logo-2010-1920x1080.png",
    ),
    GeneralModel(
      id: "39",
      name: "BeiBen",
      logoUrl:
          "https://www.carlogos.org/car-logos/beiben-logo-900x1000-show.png",
    ),
    GeneralModel(
      id: "40",
      name: "Bentley",
      logoUrl: "https://www.carlogos.org/car-logos/bentley-logo-2002-640.png",
    ),
    GeneralModel(
      id: "41",
      name: "Berkeley",
      logoUrl: "https://www.carlogos.org/logo/Berkeley-logo.png",
    ),
    GeneralModel(
      id: "42",
      name: "Berliet",
      logoUrl: "https://www.carlogos.org/logo/Berliet-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "43",
      name: "Bertone",
      logoUrl: "https://www.carlogos.org/logo/Bertone-logo-4300x2600.png",
    ),
    GeneralModel(
      id: "44",
      name: "Bestune",
      logoUrl:
          "https://www.carlogos.org/car-logos/bestune-logo-2400x1200-show.png",
    ),
    GeneralModel(
      id: "45",
      name: "BharatBenz",
      logoUrl: "https://www.carlogos.org/logo/BharatBenz-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "46",
      name: "Bitter",
      logoUrl: "https://www.carlogos.org/logo/Bitter-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "47",
      name: "Bizzarrini",
      logoUrl: "https://www.carlogos.org/logo/Bizzarrini-logo-640x550.jpg",
    ),
    GeneralModel(
      id: "48",
      name: "BMW",
      logoUrl: "https://www.carlogos.org/car-logos/bmw-logo-2020-gray.png",
    ),
    GeneralModel(
      id: "49",
      name: "BMW M",
      logoUrl: "https://www.carlogos.org/logo/BMW-M-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "50",
      name: "Borgward",
      logoUrl: "https://www.carlogos.org/logo/Borgward-logo-2016-1920x1080.png",
    ),
    GeneralModel(
      id: "51",
      name: "Bowler",
      logoUrl: "https://www.carlogos.org/logo/Bowler-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "52",
      name: "Brabus",
      logoUrl: "https://www.carlogos.org/logo/Brabus-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "53",
      name: "Brammo",
      logoUrl: "https://www.carlogos.org/logo/Brammo-logo-1024x768.png",
    ),
    GeneralModel(
      id: "54",
      name: "Brilliance",
      logoUrl: "https://www.carlogos.org/logo/Brilliance-logo-3840x2160.png",
    ),
    GeneralModel(
      id: "55",
      name: "Bristol",
      logoUrl: "https://www.carlogos.org/logo/Bristol-Cars-logo.png",
    ),
    GeneralModel(
      id: "56",
      name: "Brooke",
      logoUrl: "https://www.carlogos.org/logo/Brooke-Cars-logo-640x480.png",
    ),
    GeneralModel(
      id: "57",
      name: "Bufori",
      logoUrl: "https://www.carlogos.org/logo/Bufori-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "58",
      name: "Bugatti",
      logoUrl: "https://www.carlogos.org/logo/Bugatti-logo-1024x768.png",
    ),
    GeneralModel(
      id: "59",
      name: "Buick",
      logoUrl: "https://www.carlogos.org/logo/Buick-logo-2002-2560x1440.png",
    ),
    GeneralModel(
      id: "60",
      name: "BYD",
      logoUrl: "https://www.carlogos.org/logo/BYD-logo-2007-2560x1440.png",
    ),
    GeneralModel(
      id: "61",
      name: "Byton",
      logoUrl:
          "https://www.carlogos.org/car-logos/byton-logo-2100x600-show.png",
    ),
    GeneralModel(
      id: "62",
      name: "Cadillac",
      logoUrl:
          "https://www.carlogos.org/car-logos/cadillac-logo-2021-full-640.png",
    ),
    GeneralModel(
      id: "63",
      name: "CAMC",
      logoUrl: "https://www.carlogos.org/car-logos/camc-logo-1600x450-show.png",
    ),
    GeneralModel(
      id: "64",
      name: "Canoo",
      logoUrl:
          "https://www.carlogos.org/car-logos/canoo-logo-1100x500-show.png",
    ),
    GeneralModel(
      id: "65",
      name: "Caparo",
      logoUrl: "https://www.carlogos.org/logo/Caparo-2006-logo-1366x768.png",
    ),
    GeneralModel(
      id: "66",
      name: "Carlsson",
      logoUrl: "https://www.carlogos.org/logo/Carlsson-logo-1024x768.png",
    ),
    GeneralModel(
      id: "67",
      name: "Caterham",
      logoUrl: "https://www.carlogos.org/logo/Caterham-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "68",
      name: "Changan",
      logoUrl: "https://www.carlogos.org/logo/Changan-logo-2010-2560x1440.png",
    ),
    GeneralModel(
      id: "69",
      name: "Changfeng",
      logoUrl: "https://www.carlogos.org/logo/Changfeng-logo-1366x768.png",
    ),
    GeneralModel(
      id: "70",
      name: "Chery",
      logoUrl: "https://www.carlogos.org/logo/Chery-logo-2013-3840x2160.png",
    ),
    GeneralModel(
      id: "71",
      name: "Chevrolet",
      logoUrl:
          "https://www.carlogos.org/logo/Chevrolet-logo-2013-2560x1440.png",
    ),
    GeneralModel(
      id: "72",
      name: "Chevrolet Corvette",
      logoUrl:
          "https://www.carlogos.org/car-logos/chevrolet-corvette-logo-2020-640.png",
    ),
    GeneralModel(
      id: "73",
      name: "Chrysler",
      logoUrl: "https://www.carlogos.org/car-logos/chrysler-logo-2009-640.png",
    ),
    GeneralModel(
      id: "74",
      name: "Cisitalia",
      logoUrl: "https://www.carlogos.org/logo/Cisitalia-logo.png",
    ),
    GeneralModel(
      id: "75",
      name: "Citroën",
      logoUrl: "https://www.carlogos.org/logo/Citroen-logo-2009-2048x2048.png",
    ),
    GeneralModel(
      id: "76",
      name: "Cizeta",
      logoUrl: "https://www.carlogos.org/logo/Cizeta-logo-640x480.png",
    ),
    GeneralModel(
      id: "77",
      name: "Cole",
      logoUrl: "https://www.carlogos.org/logo/Cole-logo.png",
    ),
    GeneralModel(
      id: "78",
      name: "Corre La Licorne",
      logoUrl: "https://www.carlogos.org/logo/Corre-La-Licorne-640x550.jpg",
    ),
    GeneralModel(
      id: "79",
      name: "Cupra",
      logoUrl:
          "/Users/filip.popranec/Develop/car-logos-dataset/local-logos/cupra.png",
    ),
    GeneralModel(
      id: "80",
      name: "Dacia",
      logoUrl: "https://www.carlogos.org/logo/Dacia-logo-2008-1920x1080.png",
    ),
    GeneralModel(
      id: "81",
      name: "Daewoo",
      logoUrl: "https://www.carlogos.org/logo/Daewoo-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "82",
      name: "DAF",
      logoUrl: "https://www.carlogos.org/logo/DAF-logo-6000x3000.png",
    ),
    GeneralModel(
      id: "83",
      name: "Daihatsu",
      logoUrl: "https://www.carlogos.org/logo/Daihatsu-logo-1997-1280x233.png",
    ),
    GeneralModel(
      id: "84",
      name: "Daimler",
      logoUrl: "https://www.carlogos.org/logo/Daimler-logo-2200x500.png",
    ),
    GeneralModel(
      id: "85",
      name: "Dartz",
      logoUrl: "https://www.carlogos.org/logo/Dartz-logo-640x300.jpg",
    ),
    GeneralModel(
      id: "86",
      name: "Datsun",
      logoUrl: "https://www.carlogos.org/logo/Datsun-logo-2013-2560x1440.png",
    ),
    GeneralModel(
      id: "87",
      name: "David Brown",
      logoUrl: "https://www.carlogos.org/logo/David-Brown-logo-1366x768.png",
    ),
    GeneralModel(
      id: "88",
      name: "Dayun",
      logoUrl:
          "https://www.carlogos.org/car-logos/dayun-logo-1100x1100-show.png",
    ),
    GeneralModel(
      id: "89",
      name: "De Tomaso",
      logoUrl: "https://www.carlogos.org/logo/De-Tomaso-logo-2011-640x251.png",
    ),
    GeneralModel(
      id: "90",
      name: "Delage",
      logoUrl: "https://www.carlogos.org/logo/Delage-logo-1440x900.png",
    ),
    GeneralModel(
      id: "91",
      name: "DeSoto",
      logoUrl:
          "https://www.carlogos.org/car-logos/desoto-logo-650x650-show.png",
    ),
    GeneralModel(
      id: "92",
      name: "Detroit Electric",
      logoUrl:
          "https://www.carlogos.org/logo/Detroit-Electric-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "93",
      name: "Devel Sixteen",
      logoUrl: "https://www.carlogos.org/logo/Devel-Sixteen-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "94",
      name: "Diatto",
      logoUrl: "https://www.carlogos.org/logo/Diatto-logo-640x215.jpg",
    ),
    GeneralModel(
      id: "95",
      name: "DINA",
      logoUrl: "https://www.carlogos.org/logo/DINA-logo-1366x768.png",
    ),
    GeneralModel(
      id: "96",
      name: "DKW",
      logoUrl: "https://www.carlogos.org/logo/DKW-logo-black-640x550.jpg",
    ),
    GeneralModel(
      id: "97",
      name: "DMC",
      logoUrl: "https://www.carlogos.org/logo/DMC-logo-1440x900.png",
    ),
    GeneralModel(
      id: "98",
      name: "Dodge",
      logoUrl: "https://www.carlogos.org/car-logos/dodge-logo-2010-640.png",
    ),
    GeneralModel(
      id: "99",
      name: "Dodge Viper",
      logoUrl: "https://www.carlogos.org/logo/Viper-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "100",
      name: "Dongfeng",
      logoUrl: "https://www.carlogos.org/logo/Dongfeng-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "101",
      name: "Donkervoort",
      logoUrl: "https://www.carlogos.org/logo/Donkervoort-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "102",
      name: "Drako",
      logoUrl:
          "https://www.carlogos.org/car-logos/drako-logo-2100x400-show.png",
    ),
    GeneralModel(
      id: "103",
      name: "DS",
      logoUrl: "https://www.carlogos.org/logo/DS-logo-2009-1920x1080.png",
    ),
    GeneralModel(
      id: "104",
      name: "Duesenberg",
      logoUrl:
          "https://www.carlogos.org/car-logos/duesenberg-logo-1000x600-show.png",
    ),
    GeneralModel(
      id: "105",
      name: "Eagle",
      logoUrl:
          "https://www.carlogos.org/logo/Eagle-automobile-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "106",
      name: "EDAG",
      logoUrl: "https://www.carlogos.org/logo/EDAG-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "107",
      name: "Edsel",
      logoUrl: "https://www.carlogos.org/logo/Edsel-logo-1200x1200.png",
    ),
    GeneralModel(
      id: "108",
      name: "Eicher",
      logoUrl: "https://www.carlogos.org/logo/Eicher-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "109",
      name: "Elemental",
      logoUrl: "https://www.carlogos.org/logo/Elemental-logo-1024x768.png",
    ),
    GeneralModel(
      id: "110",
      name: "Elfin",
      logoUrl: "https://www.carlogos.org/logo/Elfin-logo-640x330.jpg",
    ),
    GeneralModel(
      id: "111",
      name: "Elva",
      logoUrl: "https://www.carlogos.org/logo/Elva-logo.png",
    ),
    GeneralModel(
      id: "112",
      name: "Englon",
      logoUrl: "https://www.carlogos.org/logo/Englon-logo-640x550.jpg",
    ),
    GeneralModel(
      id: "113",
      name: "ERF",
      logoUrl: "https://www.carlogos.org/logo/ERF-logo-2300x1500.png",
    ),
    GeneralModel(
      id: "114",
      name: "Eterniti",
      logoUrl: "https://www.carlogos.org/logo/Eterniti-logo-640x408.jpg",
    ),
    GeneralModel(
      id: "115",
      name: "Exeed",
      logoUrl:
          "https://www.carlogos.org/car-logos/exeed-logo-1200x200-show.png",
    ),
    GeneralModel(
      id: "116",
      name: "Facel Vega",
      logoUrl: "https://www.carlogos.org/logo/Facel-Vega-logo-1024x768.png",
    ),
    GeneralModel(
      id: "117",
      name: "Faraday Future",
      logoUrl:
          "https://www.carlogos.org/logo/Faraday-Future-logo-2000x1500.png",
    ),
    GeneralModel(
      id: "118",
      name: "FAW",
      logoUrl: "https://www.carlogos.org/logo/FAW-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "119",
      name: "FAW Jiefang",
      logoUrl:
          "https://www.carlogos.org/car-logos/faw-jiefang-950x700-show.png",
    ),
    GeneralModel(
      id: "120",
      name: "Ferrari",
      logoUrl: "https://www.carlogos.org/car-logos/ferrari-logo-2002-640.png",
    ),
    GeneralModel(
      id: "121",
      name: "Fiat",
      logoUrl: "https://www.carlogos.org/logo/Fiat-logo-2006-1920x1080.png",
    ),
    GeneralModel(
      id: "122",
      name: "Fioravanti",
      logoUrl: "https://www.carlogos.org/logo/Fioravanti-logo-640x274.jpg",
    ),
    GeneralModel(
      id: "123",
      name: "Fisker",
      logoUrl: "https://www.carlogos.org/logo/Fisker-logo-2007-1920x1080.png",
    ),
    GeneralModel(
      id: "124",
      name: "Foden",
      logoUrl: "https://www.carlogos.org/logo/Foden-logo-640x480.png",
    ),
    GeneralModel(
      id: "125",
      name: "Force Motors",
      logoUrl: "https://www.carlogos.org/logo/Force-Motors-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "126",
      name: "Ford",
      logoUrl: "https://www.carlogos.org/car-logos/ford-logo-2017-640.png",
    ),
    GeneralModel(
      id: "127",
      name: "Ford Mustang",
      logoUrl: "https://www.carlogos.org/logo/Mustang-logo-2010-1920x1080.png",
    ),
    GeneralModel(
      id: "128",
      name: "Foton",
      logoUrl: "https://www.carlogos.org/logo/Foton-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "129",
      name: "FPV",
      logoUrl: "https://www.carlogos.org/logo/FPV-logo-640x240.jpg",
    ),
    GeneralModel(
      id: "130",
      name: "Franklin",
      logoUrl: "https://www.carlogos.org/logo/Franklin-logo-640x525.jpg",
    ),
    GeneralModel(
      id: "131",
      name: "Freightliner",
      logoUrl: "https://www.carlogos.org/logo/Freightliner-logo-6000x2000.png",
    ),
    GeneralModel(
      id: "132",
      name: "FSO",
      logoUrl: "https://www.carlogos.org/car-logos/fso-logo-1200x500-show.png",
    ),
    GeneralModel(
      id: "133",
      name: "GAC Group",
      logoUrl: "https://www.carlogos.org/logo/GAC-Group-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "134",
      name: "Gardner Douglas",
      logoUrl: "https://www.carlogos.org/logo/Gardner-Douglas-logo-640x480.png",
    ),
    GeneralModel(
      id: "135",
      name: "GAZ",
      logoUrl: "https://www.carlogos.org/logo/GAZ-logo-2015-1920x1080.png",
    ),
    GeneralModel(
      id: "136",
      name: "Geely",
      logoUrl: "https://www.carlogos.org/logo/Geely-logo-2014-2560x1440.png",
    ),
    GeneralModel(
      id: "137",
      name: "General Motors",
      logoUrl:
          "https://www.carlogos.org/logo/General-Motors-logo-2010-3300x3300.png",
    ),
    GeneralModel(
      id: "138",
      name: "Genesis",
      logoUrl: "https://www.carlogos.org/logo/Genesis-logo-640x248.jpg",
    ),
    GeneralModel(
      id: "139",
      name: "Geo",
      logoUrl: "https://www.carlogos.org/logo/Geo-logo-2000x600.png",
    ),
    GeneralModel(
      id: "140",
      name: "Geometry",
      logoUrl: "https://www.carlogos.org/car-logos/geometry-logo-640x480.png",
    ),
    GeneralModel(
      id: "141",
      name: "Gilbern",
      logoUrl: "https://www.carlogos.org/logo/Gilbern-logo-640x480.png",
    ),
    GeneralModel(
      id: "142",
      name: "Gillet",
      logoUrl: "https://www.carlogos.org/logo/Gillet-logo.png",
    ),
    GeneralModel(
      id: "143",
      name: "Ginetta",
      logoUrl: "https://www.carlogos.org/logo/Ginetta-logo-1024x768.png",
    ),
    GeneralModel(
      id: "144",
      name: "GMC",
      logoUrl: "https://www.carlogos.org/logo/GMC-logo-2200x600.png",
    ),
    GeneralModel(
      id: "145",
      name: "Golden Dragon",
      logoUrl:
          "https://www.carlogos.org/car-logos/golden-dragon-logo-900x700-show.png",
    ),
    GeneralModel(
      id: "146",
      name: "Gonow",
      logoUrl: "https://www.carlogos.org/logo/Gonow-logo-2010-1440x900.png",
    ),
    GeneralModel(
      id: "147",
      name: "Great Wall",
      logoUrl:
          "https://www.carlogos.org/logo/Great-Wall-logo-2007-2048x2048.png",
    ),
    GeneralModel(
      id: "148",
      name: "Grinnall",
      logoUrl: "https://www.carlogos.org/logo/Grinnall-cars-logo-1366x768.png",
    ),
    GeneralModel(
      id: "149",
      name: "Gumpert",
      logoUrl: "https://www.carlogos.org/logo/Gumpert-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "150",
      name: "Hafei",
      logoUrl: "https://www.carlogos.org/logo/Hafei-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "151",
      name: "Haima",
      logoUrl: "https://www.carlogos.org/logo/Haima-logo-3840x2160.png",
    ),
    GeneralModel(
      id: "152",
      name: "Haval",
      logoUrl: "https://www.carlogos.org/logo/Haval-logo-1366x768.png",
    ),
    GeneralModel(
      id: "153",
      name: "Hawtai",
      logoUrl: "https://www.carlogos.org/logo/Hawtai-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "154",
      name: "Hennessey",
      logoUrl: "https://www.carlogos.org/logo/Hennessey-text-logo-1186x130.png",
    ),
    GeneralModel(
      id: "155",
      name: "Higer",
      logoUrl: "https://www.carlogos.org/car-logos/higer-logo-800x600-show.png",
    ),
    GeneralModel(
      id: "156",
      name: "Hillman",
      logoUrl: "https://www.carlogos.org/logo/Hillman-logo-640x145.jpg",
    ),
    GeneralModel(
      id: "157",
      name: "Hindustan Motors",
      logoUrl:
          "https://www.carlogos.org/logo/Hindustan-Motors-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "158",
      name: "Hino",
      logoUrl: "https://www.carlogos.org/logo/Hino-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "159",
      name: "HiPhi",
      logoUrl:
          "https://www.carlogos.org/car-logos/hiphi-logo-2100x600-show.png",
    ),
    GeneralModel(
      id: "160",
      name: "Hispano-Suiza",
      logoUrl: "https://www.carlogos.org/logo/Hispano-Suiza-logo-640x183.jpg",
    ),
    GeneralModel(
      id: "161",
      name: "Holden",
      logoUrl: "https://www.carlogos.org/logo/Holden-logo-2016-1920x1080.png",
    ),
    GeneralModel(
      id: "162",
      name: "Hommell",
      logoUrl: "https://www.carlogos.org/logo/Hommell-logo-1024x768.png",
    ),
    GeneralModel(
      id: "163",
      name: "Honda",
      logoUrl:
          "https://www.carlogos.org/car-logos/honda-logo-2000-full-640.png",
    ),
    GeneralModel(
      id: "164",
      name: "Hongqi",
      logoUrl:
          "https://www.carlogos.org/car-logos/hongqi-logo-2018-800x600-show.png",
    ),
    GeneralModel(
      id: "165",
      name: "Hongyan",
      logoUrl:
          "https://www.carlogos.org/car-logos/hongyan-logo-1200x1200-show.png",
    ),
    GeneralModel(
      id: "166",
      name: "Horch",
      logoUrl: "https://www.carlogos.org/logo/Horch-logo-black-1920x1080.png",
    ),
    GeneralModel(
      id: "167",
      name: "HSV",
      logoUrl: "https://www.carlogos.org/logo/HSV-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "168",
      name: "Hudson",
      logoUrl: "https://www.carlogos.org/logo/Hudson-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "169",
      name: "Hummer",
      logoUrl: "https://www.carlogos.org/logo/Hummer-logo-2000x205.png",
    ),
    GeneralModel(
      id: "170",
      name: "Hupmobile",
      logoUrl: "https://www.carlogos.org/logo/Hupmobile-logo-640x138.jpg",
    ),
    GeneralModel(
      id: "171",
      name: "Hyundai",
      logoUrl: "https://www.carlogos.org/car-logos/hyundai-logo-2011-640.png",
    ),
    GeneralModel(
      id: "172",
      name: "IC Bus",
      logoUrl: "https://www.carlogos.org/logo/IC-Bus-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "173",
      name: "IH",
      logoUrl:
          "https://www.carlogos.org/logo/International-Harvester-logo-1000x1200.png",
    ),
    GeneralModel(
      id: "174",
      name: "IKCO",
      logoUrl: "https://www.carlogos.org/logo/Iran-Khodro-logo-3000x3000.png",
    ),
    GeneralModel(
      id: "175",
      name: "Infiniti",
      logoUrl: "https://www.carlogos.org/logo/Infiniti-logo-1989-2560x1440.png",
    ),
    GeneralModel(
      id: "176",
      name: "Innocenti",
      logoUrl: "https://www.carlogos.org/logo/Innocenti-logo-310x310.png",
    ),
    GeneralModel(
      id: "177",
      name: "Intermeccanica",
      logoUrl: "https://www.carlogos.org/logo/Intermeccanica-logo.png",
    ),
    GeneralModel(
      id: "178",
      name: "International",
      logoUrl:
          "https://www.carlogos.org/logo/International-Trucks-logo-1200x1200.png",
    ),
    GeneralModel(
      id: "179",
      name: "Irizar",
      logoUrl: "https://www.carlogos.org/logo/Irizar-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "180",
      name: "Isdera",
      logoUrl: "https://www.carlogos.org/logo/Isdera-logo-640x413.jpg",
    ),
    GeneralModel(
      id: "181",
      name: "Iso",
      logoUrl: "https://www.carlogos.org/logo/Iso-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "182",
      name: "Isuzu",
      logoUrl: "https://www.carlogos.org/logo/Isuzu-logo-1991-3840x2160.png",
    ),
    GeneralModel(
      id: "183",
      name: "Iveco",
      logoUrl: "https://www.carlogos.org/logo/Iveco-logo-silver-3840x2160.png",
    ),
    GeneralModel(
      id: "184",
      name: "JAC",
      logoUrl:
          "https://www.carlogos.org/logo/JAC-Motors-logo-2016-1920x1080.png",
    ),
    GeneralModel(
      id: "185",
      name: "Jaguar",
      logoUrl: "https://www.carlogos.org/car-logos/jaguar-logo-2021-640.png",
    ),
    GeneralModel(
      id: "186",
      name: "Jawa",
      logoUrl: "https://www.carlogos.org/logo/Jawa-logo-640x333.jpg",
    ),
    GeneralModel(
      id: "187",
      name: "JBA Motors",
      logoUrl: "https://www.carlogos.org/logo/JBA-Motors-logo-1366x768.png",
    ),
    GeneralModel(
      id: "188",
      name: "Jeep",
      logoUrl: "https://www.carlogos.org/car-logos/jeep-logo-1993-640.png",
    ),
    GeneralModel(
      id: "189",
      name: "Jensen",
      logoUrl: "https://www.carlogos.org/logo/Jensen-logo-640x556.jpg",
    ),
    GeneralModel(
      id: "190",
      name: "Jetour",
      logoUrl:
          "/Users/filip.popranec/Develop/car-logos-dataset/local-logos/jetour.png",
    ),
    GeneralModel(
      id: "191",
      name: "Jetta",
      logoUrl:
          "https://www.carlogos.org/car-logos/jetta-logo-2019-1300x1100-show.png",
    ),
    GeneralModel(
      id: "192",
      name: "JMC",
      logoUrl: "https://www.carlogos.org/logo/Jiangling-logo-1280x1024.png",
    ),
    GeneralModel(
      id: "193",
      name: "Kaiser",
      logoUrl: "https://www.carlogos.org/logo/Kaiser-logo-640x346.jpg",
    ),
    GeneralModel(
      id: "194",
      name: "Kamaz",
      logoUrl: "https://www.carlogos.org/logo/Kamaz-logo-2000x2500.png",
    ),
    GeneralModel(
      id: "195",
      name: "Karlmann King",
      logoUrl:
          "https://www.carlogos.org/car-logos/karlmann-king-1400x1000-show.png",
    ),
    GeneralModel(
      id: "196",
      name: "Karma",
      logoUrl: "https://www.carlogos.org/logo/Karma-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "197",
      name: "Keating",
      logoUrl:
          "https://www.carlogos.org/logo/Keating-Supercars-logo-640x480.png",
    ),
    GeneralModel(
      id: "198",
      name: "Kenworth",
      logoUrl: "https://www.carlogos.org/logo/Kenworth-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "199",
      name: "Kia",
      logoUrl: "https://www.carlogos.org/logo/Kia-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "200",
      name: "King Long",
      logoUrl:
          "https://www.carlogos.org/car-logos/king-long-logo-3900x800-show.png",
    ),
    GeneralModel(
      id: "201",
      name: "Koenigsegg",
      logoUrl:
          "https://www.carlogos.org/logo/Koenigsegg-logo-1994-2048x2048.png",
    ),
    GeneralModel(
      id: "202",
      name: "KTM",
      logoUrl: "https://www.carlogos.org/logo/KTM-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "203",
      name: "Lada",
      logoUrl: "https://www.carlogos.org/logo/Lada-logo-silver-640x248.jpg",
    ),
    GeneralModel(
      id: "204",
      name: "Lagonda",
      logoUrl: "https://www.carlogos.org/logo/Lagonda-logo-2014-1024x768.png",
    ),
    GeneralModel(
      id: "205",
      name: "Lamborghini",
      logoUrl:
          "https://www.carlogos.org/car-logos/lamborghini-logo-1998-640.png",
    ),
    GeneralModel(
      id: "206",
      name: "Lancia",
      logoUrl: "https://www.carlogos.org/logo/Lancia-logo-2007-1920x1080.png",
    ),
    GeneralModel(
      id: "207",
      name: "Land Rover",
      logoUrl:
          "https://www.carlogos.org/logo/Land-Rover-logo-2011-1920x1080.png",
    ),
    GeneralModel(
      id: "208",
      name: "Landwind",
      logoUrl: "https://www.carlogos.org/logo/Landwind-logo-5000x2000.png",
    ),
    GeneralModel(
      id: "209",
      name: "Laraki",
      logoUrl: "https://www.carlogos.org/logo/Laraki-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "210",
      name: "Leapmotor",
      logoUrl:
          "https://www.carlogos.org/car-logos/leapmotor-logo-1000x650-show.png",
    ),
    GeneralModel(
      id: "211",
      name: "LEVC",
      logoUrl:
          "https://www.carlogos.org/logo/London-EV-Company-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "212",
      name: "Lexus",
      logoUrl: "https://www.carlogos.org/logo/Lexus-logo-1988-1920x1080.png",
    ),
    GeneralModel(
      id: "213",
      name: "Leyland",
      logoUrl: "https://www.carlogos.org/logo/Leyland-logo-1024x768.png",
    ),
    GeneralModel(
      id: "214",
      name: "Li Auto",
      logoUrl:
          "https://www.carlogos.org/car-logos/lixiang-logo-1050x300-show.png",
    ),
    GeneralModel(
      id: "215",
      name: "Lifan",
      logoUrl: "https://www.carlogos.org/logo/Lifan-logo-4000x1200.png",
    ),
    GeneralModel(
      id: "216",
      name: "Ligier",
      logoUrl: "https://www.carlogos.org/logo/Ligier-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "217",
      name: "Lincoln",
      logoUrl: "https://www.carlogos.org/logo/Lincoln-logo-2019-1920x1080.png",
    ),
    GeneralModel(
      id: "218",
      name: "Lister",
      logoUrl: "https://www.carlogos.org/logo/Lister-Cars-logo-2900x2900.png",
    ),
    GeneralModel(
      id: "219",
      name: "Lloyd",
      logoUrl: "https://www.carlogos.org/logo/Lloyd-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "220",
      name: "Lobini",
      logoUrl: "https://www.carlogos.org/logo/Lobini-logo-800x600.png",
    ),
    GeneralModel(
      id: "221",
      name: "Lordstown",
      logoUrl:
          "https://www.carlogos.org/car-logos/lordstown-logo-2150x1100-show.png",
    ),
    GeneralModel(
      id: "222",
      name: "Lotus",
      logoUrl: "https://www.carlogos.org/logo/Lotus-logo-2019-1800x1800.png",
    ),
    GeneralModel(
      id: "223",
      name: "Lucid",
      logoUrl: "https://www.carlogos.org/logo/Lucid-Motors-logo-1500x200.png",
    ),
    GeneralModel(
      id: "224",
      name: "Luxgen",
      logoUrl: "https://www.carlogos.org/logo/Luxgen-logo-2009-2560x1440.png",
    ),
    GeneralModel(
      id: "225",
      name: "Lynk & Co",
      logoUrl:
          "https://www.carlogos.org/car-logos/lynkco-logo-2150x400-show.png",
    ),
    GeneralModel(
      id: "226",
      name: "Mack",
      logoUrl: "https://www.carlogos.org/logo/Mack-logo-2014-6000x3000.png",
    ),
    GeneralModel(
      id: "227",
      name: "Mahindra",
      logoUrl: "https://www.carlogos.org/logo/Mahindra-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "228",
      name: "MAN",
      logoUrl: "https://www.carlogos.org/logo/MAN-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "229",
      name: "Mansory",
      logoUrl: "https://www.carlogos.org/logo/Mansory-logo-1600x400.png",
    ),
    GeneralModel(
      id: "230",
      name: "Marcos",
      logoUrl: "https://www.carlogos.org/logo/Marcos-logo-640x460.jpg",
    ),
    GeneralModel(
      id: "231",
      name: "Marlin",
      logoUrl: "https://www.carlogos.org/logo/Marlin-car-logo-640x480.png",
    ),
    GeneralModel(
      id: "232",
      name: "Maserati",
      logoUrl: "https://www.carlogos.org/car-logos/maserati-logo-2020-640.png",
    ),
    GeneralModel(
      id: "233",
      name: "Mastretta",
      logoUrl: "https://www.carlogos.org/logo/Mastretta-logo.png",
    ),
    GeneralModel(
      id: "234",
      name: "Maxus",
      logoUrl: "https://www.carlogos.org/logo/Maxus-logo-2014-1920x1080.png",
    ),
    GeneralModel(
      id: "235",
      name: "Maybach",
      logoUrl: "https://www.carlogos.org/logo/Maybach-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "236",
      name: "MAZ",
      logoUrl: "https://www.carlogos.org/logo/MAZ-logo-5000x3000.png",
    ),
    GeneralModel(
      id: "237",
      name: "Mazda",
      logoUrl:
          "https://www.carlogos.org/car-logos/mazda-logo-2018-vertical-640.png",
    ),
    GeneralModel(
      id: "238",
      name: "Mazzanti",
      logoUrl:
          "https://www.carlogos.org/logo/Mazzanti-Automobili-logo-2016-2048x2048.png",
    ),
    GeneralModel(
      id: "239",
      name: "McLaren",
      logoUrl: "https://www.carlogos.org/logo/McLaren-logo-2002-2560x1440.png",
    ),
    GeneralModel(
      id: "240",
      name: "Melkus",
      logoUrl: "https://www.carlogos.org/logo/Melkus-logo-1600x1200.png",
    ),
    GeneralModel(
      id: "241",
      name: "Mercedes-AMG",
      logoUrl: "https://www.carlogos.org/logo/AMG-logo-black-1920x1080.png",
    ),
    GeneralModel(
      id: "242",
      name: "Mercedes-Benz",
      logoUrl:
          "https://www.carlogos.org/logo/Mercedes-Benz-logo-2011-1920x1080.png",
    ),
    GeneralModel(
      id: "243",
      name: "Mercury",
      logoUrl: "https://www.carlogos.org/logo/Mercury-logo-1980-2500x2500.png",
    ),
    GeneralModel(
      id: "244",
      name: "Merkur",
      logoUrl: "https://www.carlogos.org/logo/Merkur-logo-black-1366x768.png",
    ),
    GeneralModel(
      id: "245",
      name: "MEV",
      logoUrl:
          "https://www.carlogos.org/logo/Mills-Extreme-Vehicles-logo-640x480.png",
    ),
    GeneralModel(
      id: "246",
      name: "MG",
      logoUrl: "https://www.carlogos.org/logo/MG-logo-red-2010-1920x1080.png",
    ),
    GeneralModel(
      id: "247",
      name: "Microcar",
      logoUrl: "https://www.carlogos.org/logo/Microcar-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "248",
      name: "Mini",
      logoUrl: "https://www.carlogos.org/logo/Mini-logo-2001-1920x1080.png",
    ),
    GeneralModel(
      id: "249",
      name: "Mitsubishi",
      logoUrl: "https://www.carlogos.org/logo/Mitsubishi-logo-2000x2500.png",
    ),
    GeneralModel(
      id: "250",
      name: "Mitsuoka",
      logoUrl: "https://www.carlogos.org/logo/Mitsuoka-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "251",
      name: "MK",
      logoUrl:
          "https://www.carlogos.org/car-logos/mk-sportscars-logo-1000x600-show.png",
    ),
    GeneralModel(
      id: "252",
      name: "Morgan",
      logoUrl: "https://www.carlogos.org/logo/Morgan-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "253",
      name: "Morris",
      logoUrl: "https://www.carlogos.org/logo/Morris-logo-640x497.jpg",
    ),
    GeneralModel(
      id: "254",
      name: "Mosler",
      logoUrl: "https://www.carlogos.org/logo/Mosler-logo-640x457.png",
    ),
    GeneralModel(
      id: "255",
      name: "Navistar",
      logoUrl:
          "https://www.carlogos.org/logo/Navistar-International-logo-2200x500.png",
    ),
    GeneralModel(
      id: "256",
      name: "NEVS",
      logoUrl: "https://www.carlogos.org/car-logos/nevs-logo-2100x450-show.png",
    ),
    GeneralModel(
      id: "257",
      name: "Nikola",
      logoUrl:
          "https://www.carlogos.org/car-logos/nikola-logo-2100x600-show.png",
    ),
    GeneralModel(
      id: "258",
      name: "NIO",
      logoUrl: "https://www.carlogos.org/car-logos/nio-logo-1800x700-show.png",
    ),
    GeneralModel(
      id: "259",
      name: "Nissan",
      logoUrl:
          "https://www.carlogos.org/car-logos/nissan-logo-2020-black-show.png",
    ),
    GeneralModel(
      id: "260",
      name: "Nissan GT-R",
      logoUrl: "https://www.carlogos.org/logo/GT-R-logo-1024x768.png",
    ),
    GeneralModel(
      id: "261",
      name: "Nissan Nismo",
      logoUrl: "https://www.carlogos.org/logo/Nismo-logo-2000x450.png",
    ),
    GeneralModel(
      id: "262",
      name: "Noble",
      logoUrl: "https://www.carlogos.org/logo/Noble-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "263",
      name: "Oldsmobile",
      logoUrl:
          "https://www.carlogos.org/logo/Oldsmobile-logo-1996-1024x768.png",
    ),
    GeneralModel(
      id: "264",
      name: "Oltcit",
      logoUrl: "https://www.carlogos.org/logo/Oltcit-logo-640x308.png",
    ),
    GeneralModel(
      id: "265",
      name: "Omoda",
      logoUrl:
          "/Users/filip.popranec/Develop/car-logos-dataset/local-logos/omoda.png",
    ),
    GeneralModel(
      id: "266",
      name: "Opel",
      logoUrl: "https://www.carlogos.org/logo/Opel-logo-2009-1920x1080.png",
    ),
    GeneralModel(
      id: "267",
      name: "OSCA",
      logoUrl: "https://www.carlogos.org/logo/OSCA-logo.png",
    ),
    GeneralModel(
      id: "268",
      name: "Paccar",
      logoUrl: "https://www.carlogos.org/logo/Paccar-logo-2200x500.png",
    ),
    GeneralModel(
      id: "269",
      name: "Packard",
      logoUrl:
          "https://www.carlogos.org/car-logos/packard-logo-650x650-show.png",
    ),
    GeneralModel(
      id: "270",
      name: "Pagani",
      logoUrl: "https://www.carlogos.org/logo/Pagani-logo-1992-1440x900.png",
    ),
    GeneralModel(
      id: "271",
      name: "Panhard",
      logoUrl: "https://www.carlogos.org/logo/Panhard-logo.png",
    ),
    GeneralModel(
      id: "272",
      name: "Panoz",
      logoUrl: "https://www.carlogos.org/logo/Panoz-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "273",
      name: "Pegaso",
      logoUrl: "https://www.carlogos.org/logo/Pegaso-logo-black-1920x1080.png",
    ),
    GeneralModel(
      id: "274",
      name: "Perodua",
      logoUrl: "https://www.carlogos.org/logo/Perodua-logo-2008-2560x1440.png",
    ),
    GeneralModel(
      id: "275",
      name: "Peterbilt",
      logoUrl: "https://www.carlogos.org/logo/Peterbilt-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "276",
      name: "Peugeot",
      logoUrl: "https://www.carlogos.org/logo/Peugeot-logo-2010-1920x1080.png",
    ),
    GeneralModel(
      id: "277",
      name: "PGO",
      logoUrl: "https://www.carlogos.org/logo/PGO-logo-640x550.jpg",
    ),
    GeneralModel(
      id: "278",
      name: "Pierce-Arrow",
      logoUrl: "https://www.carlogos.org/logo/Pierce-Arrow-logo-640x416.jpg",
    ),
    GeneralModel(
      id: "279",
      name: "Pininfarina",
      logoUrl: "https://www.carlogos.org/logo/Pininfarina-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "280",
      name: "Plymouth",
      logoUrl: "https://www.carlogos.org/logo/Plymouth-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "281",
      name: "Polestar",
      logoUrl: "https://www.carlogos.org/logo/Polestar-logo-1366x768.png",
    ),
    GeneralModel(
      id: "282",
      name: "Pontiac",
      logoUrl: "https://www.carlogos.org/logo/Pontiac-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "283",
      name: "Porsche",
      logoUrl:
          "https://www.carlogos.org/car-logos/porsche-logo-2014-full-640.png",
    ),
    GeneralModel(
      id: "284",
      name: "Praga",
      logoUrl: "https://www.carlogos.org/logo/Praga-logo-blue-1920x1080.png",
    ),
    GeneralModel(
      id: "285",
      name: "Premier",
      logoUrl: "https://www.carlogos.org/logo/Premier-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "286",
      name: "Prodrive",
      logoUrl: "https://www.carlogos.org/logo/Prodrive-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "287",
      name: "Proton",
      logoUrl: "https://www.carlogos.org/logo/Proton-logo-2016-2048x2048.png",
    ),
    GeneralModel(
      id: "288",
      name: "Qoros",
      logoUrl: "https://www.carlogos.org/logo/Qoros-logo-2007-1440x900.png",
    ),
    GeneralModel(
      id: "289",
      name: "Radical",
      logoUrl:
          "https://www.carlogos.org/logo/Radical-Sportscars-logo-2000x800.png",
    ),
    GeneralModel(
      id: "290",
      name: "RAM",
      logoUrl: "https://www.carlogos.org/logo/RAM-logo-2009-1920x1080.png",
    ),
    GeneralModel(
      id: "291",
      name: "Rambler",
      logoUrl: "https://www.carlogos.org/logo/Rambler-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "292",
      name: "Ranz",
      logoUrl: "https://www.carlogos.org/logo/Ranz-logo-800x600.png",
    ),
    GeneralModel(
      id: "293",
      name: "Renault",
      logoUrl: "https://www.carlogos.org/logo/Renault-logo-2015-2048x2048.png",
    ),
    GeneralModel(
      id: "294",
      name: "Renault Samsung",
      logoUrl:
          "https://www.carlogos.org/logo/Renault-Samsung-Motors-logo-1366x768.png",
    ),
    GeneralModel(
      id: "295",
      name: "Rezvani",
      logoUrl: "https://www.carlogos.org/logo/Rezvani-logo-1024x768.png",
    ),
    GeneralModel(
      id: "296",
      name: "Riley",
      logoUrl: "https://www.carlogos.org/logo/Riley-logo-640x389.png",
    ),
    GeneralModel(
      id: "297",
      name: "Rimac",
      logoUrl: "https://www.carlogos.org/logo/Rimac-logo-2016-2048x2048.png",
    ),
    GeneralModel(
      id: "298",
      name: "Rinspeed",
      logoUrl: "https://www.carlogos.org/logo/Rinspeed-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "299",
      name: "Rivian",
      logoUrl:
          "https://www.carlogos.org/car-logos/rivian-logo-black-1300x1150-show.png",
    ),
    GeneralModel(
      id: "300",
      name: "Roewe",
      logoUrl: "https://www.carlogos.org/logo/Roewe-logo-2006-1920x1080.png",
    ),
    GeneralModel(
      id: "301",
      name: "Rolls-Royce",
      logoUrl: "https://www.carlogos.org/logo/Rolls-Royce-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "302",
      name: "Ronart",
      logoUrl: "https://www.carlogos.org/logo/Ronart-Cars-logo-1366x768.png",
    ),
    GeneralModel(
      id: "303",
      name: "Rossion",
      logoUrl: "https://www.carlogos.org/logo/Rossion-logo-1024x768.png",
    ),
    GeneralModel(
      id: "304",
      name: "Rover",
      logoUrl: "https://www.carlogos.org/logo/Rover-logo-2003-3840x2160.png",
    ),
    GeneralModel(
      id: "305",
      name: "RUF",
      logoUrl: "https://www.carlogos.org/logo/Ruf-logo-1366x768.png",
    ),
    GeneralModel(
      id: "306",
      name: "Saab",
      logoUrl: "https://www.carlogos.org/logo/Saab-logo-2013-2000x450.png",
    ),
    GeneralModel(
      id: "307",
      name: "SAIC Motor",
      logoUrl: "https://www.carlogos.org/logo/SAIC-Motor-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "308",
      name: "Saipa",
      logoUrl: "https://www.carlogos.org/logo/Saipa-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "309",
      name: "Saleen",
      logoUrl: "https://www.carlogos.org/logo/Saleen-logo-640x456.jpg",
    ),
    GeneralModel(
      id: "310",
      name: "Saturn",
      logoUrl: "https://www.carlogos.org/logo/Saturn-logo-1985-2048x2048.png",
    ),
    GeneralModel(
      id: "311",
      name: "Scania",
      logoUrl: "https://www.carlogos.org/logo/Scania-logo-6200x1800.png",
    ),
    GeneralModel(
      id: "312",
      name: "Scion",
      logoUrl: "https://www.carlogos.org/logo/Scion-logo-2003-1920x1080.png",
    ),
    GeneralModel(
      id: "313",
      name: "SEAT",
      logoUrl: "https://www.carlogos.org/logo/SEAT-logo-2012-6000x5000.png",
    ),
    GeneralModel(
      id: "314",
      name: "Setra",
      logoUrl: "https://www.carlogos.org/logo/Setra-logo-3000x1000.png",
    ),
    GeneralModel(
      id: "315",
      name: "SEV",
      logoUrl:
          "/Users/filip.popranec/Develop/car-logos-dataset/local-logos/sev.png",
    ),
    GeneralModel(
      id: "316",
      name: "Shacman",
      logoUrl:
          "https://www.carlogos.org/car-logos/shacman-logo-1400x1400-show.png",
    ),
    GeneralModel(
      id: "317",
      name: "Simca",
      logoUrl: "https://www.carlogos.org/logo/Simca-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "318",
      name: "Singer",
      logoUrl: "https://www.carlogos.org/logo/Singer-logo.png",
    ),
    GeneralModel(
      id: "319",
      name: "Singulato",
      logoUrl:
          "https://www.carlogos.org/car-logos/singulato-logo-1050x400-show.png",
    ),
    GeneralModel(
      id: "320",
      name: "Sinotruk",
      logoUrl:
          "https://www.carlogos.org/car-logos/sinotruk-logo-1100x1100-show.png",
    ),
    GeneralModel(
      id: "321",
      name: "Sisu",
      logoUrl: "https://www.carlogos.org/logo/Sisu-logo-2048x2000.png",
    ),
    GeneralModel(
      id: "322",
      name: "Škoda",
      logoUrl: "https://www.carlogos.org/logo/Skoda-logo-2016-1920x1080.png",
    ),
    GeneralModel(
      id: "323",
      name: "Smart",
      logoUrl: "https://www.carlogos.org/logo/Smart-logo-1994-1366x768.png",
    ),
    GeneralModel(
      id: "324",
      name: "Soueast",
      logoUrl: "https://www.carlogos.org/logo/Soueast-logo-1995-800x600.png",
    ),
    GeneralModel(
      id: "325",
      name: "Spania GTA",
      logoUrl: "https://www.carlogos.org/logo/GTA-Motor-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "326",
      name: "Spirra",
      logoUrl: "https://www.carlogos.org/logo/Spirra-logo-1024x768.png",
    ),
    GeneralModel(
      id: "327",
      name: "Spyker",
      logoUrl: "https://www.carlogos.org/logo/Spyker-logo-black-1920x1080.png",
    ),
    GeneralModel(
      id: "328",
      name: "SsangYong",
      logoUrl: "https://www.carlogos.org/logo/SsangYong-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "329",
      name: "SSC",
      logoUrl: "https://www.carlogos.org/logo/SSC-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "330",
      name: "Sterling",
      logoUrl: "https://www.carlogos.org/logo/Sterling-logo-1366x768.png",
    ),
    GeneralModel(
      id: "331",
      name: "Studebaker",
      logoUrl: "https://www.carlogos.org/logo/Studebaker-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "332",
      name: "Stutz",
      logoUrl: "https://www.carlogos.org/car-logos/stutz-logo-800x600-show.png",
    ),
    GeneralModel(
      id: "333",
      name: "Subaru",
      logoUrl: "https://www.carlogos.org/car-logos/subaru-logo-2019-640.png",
    ),
    GeneralModel(
      id: "334",
      name: "Suffolk",
      logoUrl:
          "https://www.carlogos.org/logo/Suffolk-Sportscars-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "335",
      name: "Suzuki",
      logoUrl: "https://www.carlogos.org/logo/Suzuki-logo-5000x2500.png",
    ),
    GeneralModel(
      id: "336",
      name: "Talbot",
      logoUrl: "https://www.carlogos.org/logo/Talbot-logo-1440x900.png",
    ),
    GeneralModel(
      id: "337",
      name: "Tata",
      logoUrl: "https://www.carlogos.org/logo/Tata-logo-2000-2560x1440.png",
    ),
    GeneralModel(
      id: "338",
      name: "Tatra",
      logoUrl: "https://www.carlogos.org/logo/Tatra-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "339",
      name: "Tauro",
      logoUrl:
          "https://www.carlogos.org/logo/Tauro-Sport-Auto-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "340",
      name: "TechArt",
      logoUrl: "https://www.carlogos.org/logo/TechArt-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "341",
      name: "Tesla",
      logoUrl:
          "https://www.carlogos.org/car-logos/tesla-logo-2007-full-640.png",
    ),
    GeneralModel(
      id: "342",
      name: "Toyota",
      logoUrl:
          "https://www.carlogos.org/car-logos/toyota-logo-2020-europe-640.png",
    ),
    GeneralModel(
      id: "343",
      name: "Toyota Alphard",
      logoUrl:
          "https://www.carlogos.org/car-logos/toyota-alphard-logo-500x600-show.png",
    ),
    GeneralModel(
      id: "344",
      name: "Toyota Century",
      logoUrl:
          "https://www.carlogos.org/car-logos/toyota-century-logo-900x1000-show.png",
    ),
    GeneralModel(
      id: "345",
      name: "Toyota Crown",
      logoUrl: "https://www.carlogos.org/logo/Toyota-Crown-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "346",
      name: "Tramontana",
      logoUrl:
          "https://www.carlogos.org/logo/Tramontana-logo-black-1366x768.png",
    ),
    GeneralModel(
      id: "347",
      name: "Trion",
      logoUrl: "https://www.carlogos.org/logo/Trion-logo-1024x768.png",
    ),
    GeneralModel(
      id: "348",
      name: "Triumph",
      logoUrl: "https://www.carlogos.org/logo/Triumph-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "349",
      name: "Troller",
      logoUrl: "https://www.carlogos.org/logo/Troller-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "350",
      name: "Tucker",
      logoUrl:
          "https://www.carlogos.org/car-logos/tucker-logo-700x900-show.png",
    ),
    GeneralModel(
      id: "351",
      name: "TVR",
      logoUrl: "https://www.carlogos.org/logo/TVR-logo-800x600.png",
    ),
    GeneralModel(
      id: "352",
      name: "UAZ",
      logoUrl: "https://www.carlogos.org/logo/UAZ-logo-1366x768.png",
    ),
    GeneralModel(
      id: "353",
      name: "UD",
      logoUrl: "https://www.carlogos.org/logo/UD-Trucks-logo-3000x2500.png",
    ),
    GeneralModel(
      id: "354",
      name: "Ultima",
      logoUrl: "https://www.carlogos.org/logo/Ultima-Sports-logo-640x480.png",
    ),
    GeneralModel(
      id: "355",
      name: "Vandenbrink",
      logoUrl: "https://www.carlogos.org/logo/Vandenbrink-logo-640x265.jpg",
    ),
    GeneralModel(
      id: "356",
      name: "Vauxhall",
      logoUrl:
          "https://www.carlogos.org/logo/Vauxhall-logo-2008-red-2560x1440.png",
    ),
    GeneralModel(
      id: "357",
      name: "Vector",
      logoUrl: "https://www.carlogos.org/logo/Vector-Motors-logo-1366x768.png",
    ),
    GeneralModel(
      id: "358",
      name: "Vencer",
      logoUrl: "https://www.carlogos.org/logo/Vencer-logo-1024x768.png",
    ),
    GeneralModel(
      id: "359",
      name: "Venturi",
      logoUrl: "https://www.carlogos.org/logo/Venturi-logo-640x151.png",
    ),
    GeneralModel(
      id: "360",
      name: "Venucia",
      logoUrl: "https://www.carlogos.org/logo/Venucia-logo-2017-1920x1080.png",
    ),
    GeneralModel(
      id: "361",
      name: "VinFast",
      logoUrl:
          "https://www.carlogos.org/car-logos/vinfast-logo-900x850-show.png",
    ),
    GeneralModel(
      id: "362",
      name: "VLF",
      logoUrl: "https://www.carlogos.org/car-logos/vlf-logo-600x900-show.png",
    ),
    GeneralModel(
      id: "363",
      name: "Volkswagen",
      logoUrl:
          "https://www.carlogos.org/logo/Volkswagen-logo-2019-1500x1500.png",
    ),
    GeneralModel(
      id: "364",
      name: "Volvo",
      logoUrl: "https://www.carlogos.org/logo/Volvo-logo-2014-1920x1080.png",
    ),
    GeneralModel(
      id: "365",
      name: "W Motors",
      logoUrl: "https://www.carlogos.org/logo/W-Motors-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "366",
      name: "Wanderer",
      logoUrl: "https://www.carlogos.org/logo/Wanderer-logo-black-640x311.jpg",
    ),
    GeneralModel(
      id: "367",
      name: "Wartburg",
      logoUrl: "https://www.carlogos.org/logo/Wartburg-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "368",
      name: "Weltmeister",
      logoUrl:
          "https://www.carlogos.org/car-logos/weltmeister-logo-1200x900-show.png",
    ),
    GeneralModel(
      id: "369",
      name: "Western Star",
      logoUrl: "https://www.carlogos.org/logo/Western-Star-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "370",
      name: "Westfield",
      logoUrl: "https://www.carlogos.org/logo/Westfield-logo-1024x768.png",
    ),
    GeneralModel(
      id: "371",
      name: "WEY",
      logoUrl: "https://www.carlogos.org/car-logos/wey-logo-800x1100-show.png",
    ),
    GeneralModel(
      id: "372",
      name: "Wiesmann",
      logoUrl: "https://www.carlogos.org/logo/Wiesmann-logo-2048x2048.png",
    ),
    GeneralModel(
      id: "373",
      name: "Willys-Overland",
      logoUrl:
          "https://www.carlogos.org/logo/Willys-Overland-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "374",
      name: "Workhorse",
      logoUrl:
          "https://www.carlogos.org/car-logos/workhorse-logo-1400x650-show.png",
    ),
    GeneralModel(
      id: "375",
      name: "Wuling",
      logoUrl: "https://www.carlogos.org/logo/Wuling-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "376",
      name: "XPeng",
      logoUrl:
          "https://www.carlogos.org/car-logos/xpeng-logo-2021-2700x1100-show.png",
    ),
    GeneralModel(
      id: "377",
      name: "Yulon",
      logoUrl: "https://www.carlogos.org/logo/Yulon-logo-2560x1440.png",
    ),
    GeneralModel(
      id: "378",
      name: "Yutong",
      logoUrl:
          "https://www.carlogos.org/car-logos/yutong-logo-2100x1300-show.png",
    ),
    GeneralModel(
      id: "379",
      name: "Zarooq Motors",
      logoUrl: "https://www.carlogos.org/logo/Zarooq-Motors-logo-1024x768.png",
    ),
    GeneralModel(
      id: "380",
      name: "Zastava",
      logoUrl: "https://www.carlogos.org/logo/Zastava-logo-640x274.jpg",
    ),
    GeneralModel(
      id: "381",
      name: "ZAZ",
      logoUrl: "https://www.carlogos.org/logo/ZAZ-logo-800x600.png",
    ),
    GeneralModel(
      id: "382",
      name: "Zeekr",
      logoUrl:
          "https://www.carlogos.org/car-logos/zeekr-logo-2300x700-show.png",
    ),
    GeneralModel(
      id: "383",
      name: "Zenos",
      logoUrl: "https://www.carlogos.org/logo/Zenos-Cars-logo-1920x1080.png",
    ),
    GeneralModel(
      id: "384",
      name: "Zenvo",
      logoUrl: "https://www.carlogos.org/logo/Zenvo-logo-2009-2560x1440.png",
    ),
    GeneralModel(
      id: "385",
      name: "Zhongtong",
      logoUrl:
          "https://www.carlogos.org/car-logos/zhongtong-logo-1400x1100-show.png",
    ),
    GeneralModel(
      id: "386",
      name: "Zinoro",
      logoUrl:
          "https://www.carlogos.org/car-logos/zhinuo-logo-800x600-show.png",
    ),
    GeneralModel(
      id: "387",
      name: "Zotye",
      logoUrl: "https://www.carlogos.org/logo/Zotye-logo-2560x1440.png",
    ),
  ];

  // static final List<GeneralModel> manufacturers = [
  //   GeneralModel(
  //     id: "1",
  //     name: "Toyota",
  //     logoUrl: "assets/images/logos/toyota.png",
  //   ),
  //   GeneralModel(
  //     id: "2",
  //     name: "Volkswagen",
  //     logoUrl: "assets/images/logos/volkswagen.png",
  //   ),
  //   GeneralModel(
  //     id: "3",
  //     name: "Ford",
  //     logoUrl: "assets/images/logos/ford.png",
  //   ),
  //   GeneralModel(
  //     id: "4",
  //     name: "Honda",
  //     logoUrl: "assets/images/logos/honda.png",
  //   ),
  //   GeneralModel(
  //     id: "5",
  //     name: "Nissan",
  //     logoUrl: "assets/images/logos/nissan.png",
  //   ),
  //   GeneralModel(
  //     id: "6",
  //     name: "Hyundai",
  //     logoUrl: "assets/images/logos/hyundai.png",
  //   ),
  //   GeneralModel(id: "7", name: "Kia", logoUrl: "assets/images/logos/kia.png"),
  //   GeneralModel(
  //     id: "8",
  //     name: "Mercedes-Benz",
  //     logoUrl: "assets/images/logos/mercedes.png",
  //   ),
  //   GeneralModel(id: "9", name: "BMW", logoUrl: "assets/images/logos/bmw.png"),
  //   GeneralModel(
  //     id: "10",
  //     name: "Audi",
  //     logoUrl: "assets/images/logos/audi.png",
  //   ),
  //   GeneralModel(
  //     id: "11",
  //     name: "Chevrolet",
  //     logoUrl: "assets/images/logos/chevrolet.png",
  //   ),
  //   GeneralModel(
  //     id: "12",
  //     name: "Tesla",
  //     logoUrl: "assets/images/logos/tesla.png",
  //   ),
  //   GeneralModel(
  //     id: "13",
  //     name: "Renault",
  //     logoUrl: "assets/images/logos/renault.png",
  //   ),
  //   GeneralModel(
  //     id: "14",
  //     name: "Fiat",
  //     logoUrl: "assets/images/logos/fiat.png",
  //   ),
  //   GeneralModel(
  //     id: "15",
  //     name: "Peugeot",
  //     logoUrl: "assets/images/logos/peugeot.png",
  //   ),
  //   GeneralModel(
  //     id: "16",
  //     name: "Suzuki",
  //     logoUrl: "assets/images/logos/suzuki.png",
  //   ),
  //   GeneralModel(
  //     id: "17",
  //     name: "Mazda",
  //     logoUrl: "assets/images/logos/mazda.png",
  //   ),
  //   GeneralModel(
  //     id: "18",
  //     name: "Subaru",
  //     logoUrl: "assets/images/logos/subaru.png",
  //   ),
  //   GeneralModel(
  //     id: "19",
  //     name: "Mitsubishi",
  //     logoUrl: "assets/images/logos/mitsubishi.png",
  //   ),
  //   GeneralModel(
  //     id: "20",
  //     name: "Volvo",
  //     logoUrl: "assets/images/logos/volvo.png",
  //   ),
  //   GeneralModel(
  //     id: "21",
  //     name: "Dacia",
  //     logoUrl: "assets/images/logos/dacia.png",
  //   ),
  //   GeneralModel(
  //     id: "22",
  //     name: "Lexus",
  //     logoUrl: "assets/images/logos/lexus.jpg",
  //   ),
  //   GeneralModel(
  //     id: "23",
  //     name: "Dodge",
  //     logoUrl: "assets/images/logos/dodge.png",
  //   ),
  //   GeneralModel(
  //     id: "24",
  //     name: "Jeep",
  //     logoUrl: "assets/images/logos/leep.png",
  //   ),
  //   GeneralModel(
  //     id: "25",
  //     name: "Jaguar",
  //     logoUrl: "assets/images/logos/jaguar.png",
  //   ),
  //   GeneralModel(
  //     id: "26",
  //     name: "Land Rover",
  //     logoUrl: "assets/images/logos/land_rover.png",
  //   ),
  //   GeneralModel(
  //     id: "27",
  //     name: "Porsche",
  //     logoUrl: "assets/images/logos/porsche.png",
  //   ),
  //   GeneralModel(
  //     id: "28",
  //     name: "Skoda",
  //     logoUrl: "assets/images/logos/sokoda.png",
  //   ),
  //   GeneralModel(
  //     id: "29",
  //     name: "Seat",
  //     logoUrl: "assets/images/logos/seat.png",
  //   ),
  //   GeneralModel(
  //     id: "30",
  //     name: "Opel",
  //     logoUrl: "assets/images/logos/opel.png",
  //   ),
  //   GeneralModel(
  //     id: "31",
  //     name: "Citroën",
  //     logoUrl: "assets/images/logos/citron.png",
  //   ),
  //   GeneralModel(
  //     id: "32",
  //     name: "Chery",
  //     logoUrl: "assets/images/logos/chery.png",
  //   ),
  //   GeneralModel(id: "33", name: "BYD", logoUrl: "assets/images/logos/byd.png"),
  //   GeneralModel(
  //     id: "34",
  //     name: "Great Wall",
  //     logoUrl: "assets/images/logos/great_wall.png",
  //   ),
  //   GeneralModel(id: "35", name: "GWM", logoUrl: "assets/images/logos/gwm.png"),
  //   GeneralModel(
  //     id: "36",
  //     name: "Haval",
  //     logoUrl: "assets/images/logos/haval.png",
  //   ),
  //   GeneralModel(
  //     id: "37",
  //     name: "Tata",
  //     logoUrl: "assets/images/logos/tata.png",
  //   ),
  //   GeneralModel(id: "38", name: "MG", logoUrl: "assets/images/logos/mg.png"),
  //   GeneralModel(
  //     id: "39",
  //     name: "Dongfeng",
  //     logoUrl: "assets/images/logos/dongfeng.png",
  //   ),
  //   GeneralModel(
  //     id: "40",
  //     name: "Geely",
  //     logoUrl: "assets/images/logos/geely.png",
  //   ),
  //   GeneralModel(
  //     id: "41",
  //     name: "Saab",
  //     logoUrl: "assets/images/logos/saab.png",
  //   ),
  //   GeneralModel(
  //     id: "42",
  //     name: "Maserati",
  //     logoUrl: "assets/images/logos/maserati.png",
  //   ),
  //   GeneralModel(
  //     id: "43",
  //     name: "Bentley",
  //     logoUrl: "assets/images/logos/bentley.png",
  //   ),
  //   GeneralModel(
  //     id: "44",
  //     name: "Rolls-Royce",
  //     logoUrl: "assets/images/logos/rolls_royce.png",
  //   ),
  //   GeneralModel(
  //     id: "45",
  //     name: "Ferrari",
  //     logoUrl: "assets/images/logos/ferrari.png",
  //   ),
  //   GeneralModel(
  //     id: "46",
  //     name: "Lamborghini",
  //     logoUrl: "assets/images/logos/lamborghini.png",
  //   ),
  //   GeneralModel(
  //     id: "47",
  //     name: "Alfa Romeo",
  //     logoUrl: "assets/images/logos/alfa_romeo.png",
  //   ),
  //   GeneralModel(
  //     id: "48",
  //     name: "DS (DS Automobiles)",
  //     logoUrl: "assets/images/logos/da_automobiles.png",
  //   ),
  //   GeneralModel(
  //     id: "49",
  //     name: "Daihatsu",
  //     logoUrl: "assets/images/logos/daihatsu.png",
  //   ),
  //   GeneralModel(
  //     id: "50",
  //     name: "Infiniti",
  //     logoUrl: "assets/images/logos/infiniti.png",
  //   ),
  //   GeneralModel(
  //     id: "51",
  //     name: "Isuzu",
  //     logoUrl: "assets/images/logos/isuzu.png",
  //   ),
  //   // --- Japanese ---
  //   GeneralModel(
  //     id: "52",
  //     name: "Acura",
  //     logoUrl: "assets/images/logos/acura.png",
  //   ),
  //   GeneralModel(
  //     id: "53",
  //     name: "Scion",
  //     logoUrl: "assets/images/logos/scion.png",
  //   ),
  //   GeneralModel(
  //     id: "54",
  //     name: "Hino",
  //     logoUrl: "assets/images/logos/hino.png",
  //   ),
  //   GeneralModel(
  //     id: "55",
  //     name: "UD Trucks",
  //     logoUrl: "assets/images/logos/ud_trucks.png",
  //   ),

  //   // --- Korean ---
  //   GeneralModel(
  //     id: "56",
  //     name: "Genesis",
  //     logoUrl: "assets/images/logos/genesis.png",
  //   ),
  //   GeneralModel(
  //     id: "57",
  //     name: "Daewoo",
  //     logoUrl: "assets/images/logos/daewoo.png",
  //   ),
  //   GeneralModel(
  //     id: "58",
  //     name: "SsangYong",
  //     logoUrl: "assets/images/logos/ssang_yong.png",
  //   ),

  //   // --- Chinese ---
  //   GeneralModel(id: "59", name: "FAW", logoUrl: "assets/images/logos/faw.png"),
  //   GeneralModel(
  //     id: "60",
  //     name: "BAIC",
  //     logoUrl: "assets/images/logos/baic.png",
  //   ),
  //   GeneralModel(
  //     id: "61",
  //     name: "SAIC",
  //     logoUrl: "assets/images/logos/saic.png",
  //   ),
  //   GeneralModel(id: "62", name: "JAC", logoUrl: "assets/images/logos/jac.png"),
  //   GeneralModel(
  //     id: "63",
  //     name: "Zotye",
  //     logoUrl: "assets/images/logos/zotye.png",
  //   ),
  //   GeneralModel(id: "64", name: "NIO", logoUrl: "assets/images/logos/nio.png"),
  //   GeneralModel(
  //     id: "65",
  //     name: "XPeng",
  //     logoUrl: "assets/images/logos/xpeng.png",
  //   ),
  //   GeneralModel(
  //     id: "66",
  //     name: "Li Auto",
  //     logoUrl: "assets/images/logos/li_auto.png",
  //   ),
  //   GeneralModel(
  //     id: "67",
  //     name: "Leapmotor",
  //     logoUrl: "assets/images/logos/leapmotor.png",
  //   ),
  //   GeneralModel(
  //     id: "68",
  //     name: "Seres",
  //     logoUrl: "assets/images/logos/seres.png",
  //   ),
  //   GeneralModel(
  //     id: "69",
  //     name: "Hongqi",
  //     logoUrl: "assets/images/logos/hongqi.png",
  //   ),
  //   GeneralModel(
  //     id: "70",
  //     name: "Wuling",
  //     logoUrl: "assets/images/logos/wuling.png",
  //   ),

  //   // --- Indian ---
  //   GeneralModel(
  //     id: "71",
  //     name: "Mahindra",
  //     logoUrl: "assets/images/logos/mahindra.png",
  //   ),
  //   GeneralModel(
  //     id: "72",
  //     name: "Ashok Leyland",
  //     logoUrl: "assets/images/logos/ashok_leyland.png",
  //   ),
  //   GeneralModel(
  //     id: "73",
  //     name: "Force Motors",
  //     logoUrl: "assets/images/logos/force.png",
  //   ),
  //   GeneralModel(
  //     id: "74",
  //     name: "Hindustan Motors",
  //     logoUrl: "assets/images/logos/hindustan_motors.png",
  //   ),

  //   // --- European ---
  //   GeneralModel(
  //     id: "75",
  //     name: "Aston Martin",
  //     logoUrl: "assets/images/logos/aston_martin.png",
  //   ),
  //   GeneralModel(
  //     id: "76",
  //     name: "Bugatti",
  //     logoUrl: "assets/images/logos/bugatti.png",
  //   ),
  //   GeneralModel(
  //     id: "77",
  //     name: "Lancia",
  //     logoUrl: "assets/images/logos/lancia.png",
  //   ),
  //   GeneralModel(
  //     id: "78",
  //     name: "Smart",
  //     logoUrl: "assets/images/logos/smart.png",
  //   ),
  //   GeneralModel(
  //     id: "79",
  //     name: "Mini",
  //     logoUrl: "assets/images/logos/mini.png",
  //   ),
  //   GeneralModel(
  //     id: "80",
  //     name: "Cupra",
  //     logoUrl: "assets/images/logos/cupra.png",
  //   ),
  //   GeneralModel(
  //     id: "81",
  //     name: "Polestar",
  //     logoUrl: "assets/images/logos/polestar.png",
  //   ),
  //   GeneralModel(
  //     id: "82",
  //     name: "Koenigsegg",
  //     logoUrl: "assets/images/logos/koenigsegg.png",
  //   ),
  //   GeneralModel(
  //     id: "83",
  //     name: "Pagani",
  //     logoUrl: "assets/images/logos/pagani.png",
  //   ),

  //   // --- American ---
  //   GeneralModel(
  //     id: "84",
  //     name: "Cadillac",
  //     logoUrl: "assets/images/logos/cadillac.png",
  //   ),
  //   GeneralModel(
  //     id: "85",
  //     name: "Buick",
  //     logoUrl: "assets/images/logos/buick.png",
  //   ),
  //   GeneralModel(id: "86", name: "GMC", logoUrl: "assets/images/logos/GMC.png"),
  //   GeneralModel(
  //     id: "87",
  //     name: "Chrysler",
  //     logoUrl: "assets/images/logos/chrysler.png",
  //   ),
  //   GeneralModel(
  //     id: "88",
  //     name: "Lincoln",
  //     logoUrl: "assets/images/logos/lincoln.png",
  //   ),
  //   GeneralModel(id: "89", name: "Ram", logoUrl: "assets/images/logos/ram.png"),
  //   GeneralModel(
  //     id: "90",
  //     name: "Rivian",
  //     logoUrl: "assets/images/logos/rivian.png",
  //   ),
  //   GeneralModel(
  //     id: "91",
  //     name: "Lucid",
  //     logoUrl: "assets/images/logos/lucid.png",
  //   ),
  //   GeneralModel(
  //     id: "92",
  //     name: "Fisker",
  //     logoUrl: "assets/images/logos/fisker.png",
  //   ),

  //   // --- Electric / New Age ---
  //   GeneralModel(
  //     id: "93",
  //     name: "VinFast",
  //     logoUrl: "assets/images/logos/vin_fast.png",
  //   ),
  //   GeneralModel(
  //     id: "94",
  //     name: "Ather",
  //     logoUrl: "assets/images/logos/ather.png",
  //   ),
  //   GeneralModel(
  //     id: "95",
  //     name: "Ola Electric",
  //     logoUrl: "assets/images/logos/ola_electric.png",
  //   ),
  //   GeneralModel(
  //     id: "96",
  //     name: "Proton",
  //     logoUrl: "assets/images/logos/proton.png",
  //   ),
  //   GeneralModel(
  //     id: "97",
  //     name: "Perodua",
  //     logoUrl: "assets/images/logos/perodua.png",
  //   ),

  //   // --- Commercial / Heavy Vehicles ---
  //   GeneralModel(id: "98", name: "MAN", logoUrl: "assets/images/logos/man.png"),
  //   GeneralModel(
  //     id: "99",
  //     name: "Scania",
  //     logoUrl: "assets/images/logos/scania.png",
  //   ),
  //   GeneralModel(
  //     id: "100",
  //     name: "Iveco",
  //     logoUrl: "assets/images/logos/iveco.png",
  //   ),
  //   GeneralModel(
  //     id: "101",
  //     name: "Kamaz",
  //     logoUrl: "assets/images/logos/kamaz.png",
  //   ),
  //   GeneralModel(
  //     id: "102",
  //     name: "Ural",
  //     logoUrl: "assets/images/logos/ural.png",
  //   ),

  //   GeneralModel(
  //     id: "103",
  //     name: "Lotus",
  //     logoUrl: "assets/images/logos/lotus.png",
  //   ),
  //   GeneralModel(
  //     id: "104",
  //     name: "McLaren",
  //     logoUrl: "assets/images/logos/mcLaren.png",
  //   ),
  //   GeneralModel(
  //     id: "105",
  //     name: "Xiaomi",
  //     logoUrl: "assets/images/logos/xiaomi.png",
  //   ),
  //   GeneralModel(
  //     id: "106",
  //     name: "Zeekr",
  //     logoUrl: "assets/images/logos/zeekr.png",
  //   ),
  //   GeneralModel(
  //     id: "107",
  //     name: "Changan",
  //     logoUrl: "assets/images/logos/changan.png",
  //   ),
  //   GeneralModel(
  //     id: "108",
  //     name: "GAC",
  //     logoUrl: "assets/images/logos/GAC_motor.png",
  //   ),
  //   GeneralModel(
  //     id: "109",
  //     name: "Vauxhall",
  //     logoUrl: "assets/images/logos/vauxhall.png",
  //   ),
  //   GeneralModel(
  //     id: "110",
  //     name: "Mack",
  //     logoUrl: "assets/images/logos/mack_trucks.png",
  //   ),
  //   GeneralModel(
  //     id: "111",
  //     name: "Peterbilt",
  //     logoUrl: "assets/images/logos/peterbilt.png",
  //   ),
  //   GeneralModel(
  //     id: "112",
  //     name: "Alpine",
  //     logoUrl: "assets/images/logos/alpine.png",
  //   ),

  //   // --- Missing High-Value Additions ---
  //   GeneralModel(
  //     id: "113",
  //     name: "Lada",
  //     logoUrl: "assets/images/logos/Lada.png",
  //   ),
  //   GeneralModel(
  //     id: "114",
  //     name: "Maybach",
  //     logoUrl: "assets/images/logos/Maybach.png",
  //   ),
  //   GeneralModel(
  //     id: "115",
  //     name: "Abarth",
  //     logoUrl: "assets/images/logos/Abarth.png",
  //   ),
  //   GeneralModel(
  //     id: "116",
  //     name: "DAF",
  //     logoUrl: "assets/images/logos/DAF.png",
  //   ),
  //   GeneralModel(
  //     id: "117",
  //     name: "Freightliner",
  //     logoUrl: "assets/images/logos/Freightliner.png",
  //   ),
  //   GeneralModel(
  //     id: "118",
  //     name: "Lynk & Co",
  //     logoUrl: "assets/images/logos/Lynk.png",
  //   ),
  //   GeneralModel(
  //     id: "119",
  //     name: "Hozon (Neta)",
  //     logoUrl: "assets/images/logos/Neta.png",
  //   ),
  //   GeneralModel(
  //     id: "120",
  //     name: "Karma",
  //     logoUrl: "assets/images/logos/Karma.png",
  //   ),

  //   // --- 2026 Global Power Players ---
  //   GeneralModel(
  //     id: "121",
  //     name: "Omoda",
  //     logoUrl: "assets/images/logos/Omoda.png",
  //   ),
  //   GeneralModel(
  //     id: "122",
  //     name: "Jaecoo",
  //     logoUrl: "assets/images/logos/Jaecoo.png",
  //   ),
  //   GeneralModel(
  //     id: "123",
  //     name: "Afeela",
  //     logoUrl: "assets/images/logos/Afeela.png",
  //   ),
  //   GeneralModel(
  //     id: "124",
  //     name: "Denza",
  //     logoUrl: "assets/images/logos/Denza.png",
  //   ),
  //   GeneralModel(
  //     id: "125",
  //     name: "Yangwang",
  //     logoUrl: "assets/images/logos/Yangwang.png",
  //   ),
  //   GeneralModel(
  //     id: "126",
  //     name: "Aion",
  //     logoUrl: "assets/images/logos/Aion.png",
  //   ),
  //   GeneralModel(
  //     id: "127",
  //     name: "Hummer",
  //     logoUrl: "assets/images/logos/Hummer.png",
  //   ),
  //   GeneralModel(
  //     id: "128",
  //     name: "Skyworth",
  //     logoUrl: "assets/images/logos/Skyworth.png",
  //   ),
  // ];

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
      } else if (e == "all_the_time") {
        final dd = CommonFunction.accountCreatedDate();
        final fromDate = DateTime(dd.year, dd.month, dd.day);
        final toDate = DateTime(date.year, date.month, date.day);
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
      } else if (e == "custom_date" || e == "") {
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
